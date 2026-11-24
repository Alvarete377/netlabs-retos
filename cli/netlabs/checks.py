import hashlib
import re
from dataclasses import dataclass
from typing import Protocol

KINDS = {
    "ping": ("from", "to", "expect"),
    "tcp": ("from", "host", "port", "expect"),
    "udp": ("from", "host", "port", "expect"),
    "http": ("from", "url"),
    "routeros": ("node", "cmd", "expect"),
    "vyos": ("node", "cmd", "expect"),
    # Orden de shell en un nodo Linux (PC o servidor); se compara su salida como en routeros.
    "shell": ("node", "cmd", "expect"),
    "answer": ("id", "question", "answer"),
}
EXPECT_VALUES = {"ping": ("ok", "fail"), "tcp": ("open", "closed"), "udp": ("open", "closed")}


class CheckError(ValueError):
    pass


@dataclass
class Check:
    kind: str
    params: dict
    desc: str


@dataclass
class CheckResult:
    check: Check
    ok: bool
    detail: str
    internal_error: bool = False


class Executor(Protocol):
    def exec(self, node: str, argv: list[str]) -> tuple[int, str]: ...
    def routeros(self, node: str, cmd: str) -> str: ...
    def vyos(self, node: str, cmd: str) -> str: ...


def _default_desc(kind: str, p: dict) -> str:
    if kind == "ping":
        verb = "alcanza" if p["expect"] == "ok" else "NO alcanza"
        return f"{p['from']} {verb} {p['to']} (ping)"
    if kind in ("tcp", "udp"):
        state = "abierto" if p["expect"] == "open" else "cerrado"
        return f"{p['from']} → {p['host']}:{p['port']}/{kind} {state}"
    if kind == "http":
        return f"{p['from']} → {p['url']}"
    if kind in ("routeros", "vyos", "shell"):
        return f"{p['node']}: {p['cmd']}"
    return p["question"]


def parse_checks(raw) -> list[Check]:
    if not isinstance(raw, list):
        raise CheckError("checks.yml debe ser una lista")
    checks = []
    for i, item in enumerate(raw, 1):
        if not isinstance(item, dict) or len(item) != 1:
            raise CheckError(f"check #{i}: debe tener exactamente un tipo")
        kind, params = next(iter(item.items()))
        if kind not in KINDS:
            raise CheckError(f"check #{i}: tipo desconocido '{kind}'")
        if params is None:
            params = {}
        if not isinstance(params, dict):
            raise CheckError(f"check #{i} ({kind}): los parámetros deben ser un mapa")
        params = dict(params)
        missing = [k for k in KINDS[kind] if k not in params]
        if missing:
            raise CheckError(f"check #{i} ({kind}): faltan {missing}")
        if kind in EXPECT_VALUES and params["expect"] not in EXPECT_VALUES[kind]:
            raise CheckError(f"check #{i} ({kind}): expect debe ser uno de {EXPECT_VALUES[kind]}")
        if kind in ("routeros", "vyos", "shell") and str(params["expect"]).startswith("re:"):
            try:
                re.compile(str(params["expect"])[3:])
            except re.error as e:
                raise CheckError(f"check #{i} ({kind}): regex inválida: {e}")
        desc = params.pop("desc", None) or _default_desc(kind, params)
        checks.append(Check(kind, params, desc))
    return checks


def normalize_answer(text: str) -> str:
    return " ".join(text.strip().lower().split())


def hash_answer(text: str) -> str:
    return hashlib.sha256(normalize_answer(text).encode()).hexdigest()


def answer_matches(check: Check, given: str) -> bool:
    return hash_answer(given) == check.params["answer"]


def _run(check: Check, ex: Executor, answered) -> CheckResult:
    p = check.params
    if check.kind == "ping":
        rc, _ = ex.exec(p["from"], ["ping", "-I", str(p.get("iface", "eth1")), "-c", str(p.get("count", 3)),
                                  "-W", "1", str(p["to"])])
        reached = rc == 0
        return CheckResult(check, reached == (p["expect"] == "ok"), "responde" if reached else "sin respuesta")
    if check.kind == "tcp":
        rc, _ = ex.exec(p["from"], ["nc", "-z", "-w", "2", str(p["host"]), str(p["port"])])
        is_open = rc == 0
        return CheckResult(check, is_open == (p["expect"] == "open"), "abierto" if is_open else "cerrado o filtrado")
    if check.kind == "udp":
        _, out = ex.exec(p["from"], ["sh", "-c", 'echo netlabs | nc -u -w 2 "$1" "$2"', "_",
                                     str(p["host"]), str(p["port"])])
        is_open = "netlabs" in out
        return CheckResult(check, is_open == (p["expect"] == "open"), "responde" if is_open else "sin respuesta")
    if check.kind == "http":
        _, out = ex.exec(p["from"], ["curl", "-s", "--max-time", "3", "-w", "\n%{http_code}", str(p["url"])])
        body, _, code = out.rpartition("\n")
        code = code.strip()
        ok = code not in ("", "000")
        if "expect_code" in p:
            ok = ok and code == str(p["expect_code"])
        if "contains" in p:
            ok = ok and str(p["contains"]) in body
        return CheckResult(check, ok, f"HTTP {code}" if code not in ("", "000") else "sin respuesta")
    if check.kind in ("routeros", "vyos", "shell"):
        if check.kind == "shell":
            out = ex.exec(p["node"], ["sh", "-c", str(p["cmd"])])[1].strip()
        else:
            run = ex.routeros if check.kind == "routeros" else ex.vyos
            out = run(p["node"], p["cmd"]).strip()
        expect = str(p["expect"])
        ok = bool(re.search(expect[3:], out)) if expect.startswith("re:") else out == expect
        return CheckResult(check, ok, f"salida: {out[:80]!r}")
    ok = p["id"] in answered
    return CheckResult(check, ok, "respondida" if ok else "pendiente (usa `lab answer`)")


def run_check(check: Check, ex: Executor, answered=frozenset()) -> CheckResult:
    try:
        return _run(check, ex, answered)
    except Exception as e:  # fallo del entorno, no del alumno
        return CheckResult(check, False, f"error de comprobación: {e}", internal_error=True)


def run_all(checks: list[Check], ex: Executor, answered=frozenset()) -> list[CheckResult]:
    return [run_check(c, ex, answered) for c in checks]
