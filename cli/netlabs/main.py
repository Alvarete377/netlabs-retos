import argparse
import os
import sys
import urllib.parse
from pathlib import Path

from netlabs import account, runtime
from netlabs.account import AccountError
from netlabs.challenge import Challenge, ChallengeError, discover, load_challenge
from netlabs.checks import answer_matches, run_all
from netlabs.flag import flag_for
from netlabs.routeros import RouterOSError
from netlabs.store import Store

REPO = Path(os.environ.get("NETLABS_HOME", Path(__file__).resolve().parents[2]))
STORE_PATH = Path.home() / ".netlabs" / "state.json"
OK, KO, ERR = "✔", "✘", "!"

# Nombres de los módulos (igual que en la web). Los ids de los retos no cambian.
MODULES = {
    0: "Fundamentos",
    1: "Switching y VLANs",
    2: "Rutas estáticas",
    3: "Enrutamiento dinámico",
    4: "Firewalls",
    5: "Acceso y enlace",
    6: "VPNs",
    7: "Multifabricante",
    8: "Diagnóstico",
    9: "TLS y certificados",
}


def module_name(level) -> str:
    try:
        n = int(float(level))
    except (TypeError, ValueError):
        return str(level)
    return MODULES.get(n, f"Módulo {n}")


class Abort(Exception):
    pass


def challenges_dir() -> Path:
    return REPO / "challenges"


def find(cid: str) -> Challenge:
    p = challenges_dir() / cid
    if not (p / "challenge.yml").exists():
        raise Abort(f"No existe el reto '{cid}'. Usa `lab list`.")
    return load_challenge(p)


def active(store: Store) -> Challenge:
    if not store.active:
        raise Abort("No hay ningún lab activo. Usa `lab up <reto>`.")
    return find(store.active)


def cmd_list(args, store):
    level = None
    for ch in discover(challenges_dir()):
        if ch.level != level:
            level = ch.level
            print(f"\n== {module_name(level)} ==")
        mark = OK if store.is_completed(ch.id) else " "
        act = "  <- activo" if store.active == ch.id else ""
        print(f" [{mark}] {ch.id:30} {ch.type:12} {ch.difficulty:6} {ch.title}{act}")
    return 0


def cmd_up(args, store):
    ch = find(args.id)
    if store.active == ch.id and not getattr(args, "force", False):
        print("Ese reto ya está activo. Usa `lab reset` para empezar de cero.")
        return 0
    if store.active and store.active != ch.id and not args.yes:
        answer = input(f"Hay otro lab activo ({store.active}). ¿Apagarlo? [s/N] ").strip().lower()
        if answer not in ("s", "si", "sí", "y", "yes"):
            raise Abort("Cancelado.")
    if store.active:
        print(f"Apagando {store.active}...")
        runtime.destroy(store.active)
        store.set_active(None)
    runtime.preflight(ch)
    print(f"Levantando {ch.id}...")
    store.set_active(ch.id)  # antes de desplegar: si se interrumpe, `lab down` limpia
    runtime.deploy(ch)
    print("Esperando a que arranquen los routers (1-2 min)...")
    runtime.wait_ready(ch)
    runtime.apply_dir(ch, "configs")
    print(f"\n{ch.title}  [{module_name(ch.level)} · {ch.type} · {ch.difficulty}]\n")
    for o in ch.objectives:
        print(f"  - {o}")
    print(f"\nEnunciado: {ch.path / 'README.md'}")
    print(f"Equipos: {', '.join(ch.nodes)}   ->  lab console <equipo>   |   lab check   |   lab hint")
    return 0


def cmd_status(args, store):
    ch = active(store)
    print(f"Lab activo: {ch.id}")
    labels = {"healthy": "listo", "starting": "arrancando", "none": "en marcha", "missing": "no existe"}
    for node, kind in ch.nodes.items():
        print(f"  {node:10} {kind:14} {labels.get(runtime.health(node), runtime.health(node))}")
    return 0


def cmd_console(args, store):
    ch = active(store)
    if args.node not in ch.nodes:
        raise Abort(f"'{args.node}' no está en este lab. Equipos: {', '.join(ch.nodes)}")
    name = runtime.container(args.node)
    if ch.nodes[args.node] == runtime.ROS_KIND:
        print("Usuario: admin  Contraseña: admin   (salir: Ctrl+] y luego 'quit')")
        argv = ["docker", "exec", "-it", name, "telnet", "127.0.0.1", "5000"]
    elif ch.nodes[args.node] == runtime.VYOS_KIND:
        print("CLI de VyOS (configure / set ... / commit / exit; salir: exit)")
        argv = ["docker", "exec", "-it", name, "su", "-", "vyos"]
    else:
        argv = ["docker", "exec", "-it", name, "bash"]
    os.execvp("docker", argv)


def cmd_check(args, store):
    ch = active(store)
    runtime.wait_ready(ch, on_wait=lambda p: print(f"esperando a {', '.join(p)}..."))
    results = run_all(ch.checks, runtime.LabExecutor(), store.answered(ch.id))
    for r in results:
        mark = ERR if r.internal_error else (OK if r.ok else KO)
        print(f" {mark} {r.check.desc}   ({r.detail})")
    if all(r.ok for r in results):
        if account.load() is not None:
            try:
                flag = account.fetch_flag(ch.id)
            except Exception as e:
                msg = str(e) if isinstance(e, AccountError) else "La web no responde, inténtalo más tarde"
                print(f"\n{msg}")
                flag = flag_for(ch.flag_seed)
                existing = store.data["completed"].get(ch.id)
                if not (isinstance(existing, str) and existing.startswith("NL{")):
                    store.mark_completed(ch.id, flag)
                print(f"¡Resuelto! Flag: {flag} (flag local, no válida en la web)")
                return 0
            store.mark_completed(ch.id, flag)
            print(f"\n¡Resuelto! Flag personal (entrégala en https://net-labs.vercel.app/retos/{ch.id}): {flag}")
            return 0
        flag = flag_for(ch.flag_seed)
        store.mark_completed(ch.id, flag)
        print(f"\n¡Resuelto! Flag: {flag}")
        print(
            "Consejo: con `lab login <token>` obtendrás tu flag personal para el ranking "
            "(token en https://net-labs.vercel.app/perfil)"
        )
        return 0
    failed = sum(not r.ok for r in results)
    print(f"\nFaltan {failed} de {len(results)}.")
    if any(r.internal_error for r in results):
        print("Las marcadas con ! son errores del entorno, no tuyos: reintenta en unos segundos.")
    return 2


def cmd_hint(args, store):
    ch = active(store)
    hint = store.next_hint(ch.id, ch.hints)
    print(f"Pista: {hint}" if hint else "No hay más pistas.")
    return 0


def cmd_answer(args, store):
    ch = active(store)
    questions = [c for c in ch.checks if c.kind == "answer"]
    if not questions:
        raise Abort("Este reto no tiene preguntas.")
    if args.qid:
        q = next((c for c in questions if c.params["id"] == args.qid), None)
        if q is None:
            raise Abort(f"No existe la pregunta '{args.qid}'.")
        pending = [(q, " ".join(args.value))]
    else:
        done = store.answered(ch.id)
        pending = [(c, None) for c in questions if c.params["id"] not in done]
        if not pending:
            print("Ya has respondido todas las preguntas.")
            return 0
    all_ok = True
    for q, given in pending:
        if given is None:
            given = input(f"{q.params['question']}\n> ")
        if answer_matches(q, given):
            store.record_answer(ch.id, q.params["id"])
            print(f" {OK} correcto")
        else:
            all_ok = False
            print(f" {KO} incorrecto")
    return 0 if all_ok else 2


def cmd_reset(args, store):
    ch = active(store)
    args.id, args.yes, args.force = ch.id, True, True
    return cmd_up(args, store)


def cmd_down(args, store):
    print(f"Apagando {store.active or 'el lab'}...")
    runtime.destroy(store.active)
    store.set_active(None)
    return 0


def cmd_login(args, store):
    api_url = args.api if args.api is not None else account.default_api_url()
    account.save(api_url, args.token)
    parsed = urllib.parse.urlsplit(api_url)
    if parsed.scheme == "http" and (parsed.hostname or "").lower() not in ("localhost", "127.0.0.1", "::1"):
        print("Aviso: la URL no usa HTTPS; tu token viajará sin cifrar.")
    print("Sesión guardada. Ahora `lab check` te dará tu flag personal para la web.")
    return 0


def cmd_logout(args, store):
    account.clear()
    print("Sesión cerrada.")
    return 0


def build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(prog="lab", description="NetLabs: retos de redes y firewalls")
    sub = p.add_subparsers(dest="cmd", required=True)
    sub.add_parser("list", help="lista los retos").set_defaults(fn=cmd_list)
    up = sub.add_parser("up", help="levanta un reto")
    up.add_argument("id")
    up.add_argument("-y", "--yes", action="store_true", help="apaga el lab activo sin preguntar")
    up.set_defaults(fn=cmd_up)
    sub.add_parser("status", help="estado del lab activo").set_defaults(fn=cmd_status)
    con = sub.add_parser("console", help="abre una terminal en un equipo")
    con.add_argument("node")
    con.set_defaults(fn=cmd_console)
    sub.add_parser("check", help="comprueba si el reto está resuelto").set_defaults(fn=cmd_check)
    sub.add_parser("hint", help="muestra la siguiente pista").set_defaults(fn=cmd_hint)
    ans = sub.add_parser("answer", help="responde las preguntas del reto")
    ans.add_argument("qid", nargs="?")
    ans.add_argument("value", nargs="*")
    ans.set_defaults(fn=cmd_answer)
    sub.add_parser("reset", help="vuelve al estado inicial").set_defaults(fn=cmd_reset)
    sub.add_parser("down", help="apaga el lab").set_defaults(fn=cmd_down)
    login = sub.add_parser("login", help="guarda tu token personal de la web")
    login.add_argument("token")
    login.add_argument("--api", default=None, help="URL base de la web")
    login.set_defaults(fn=cmd_login)
    sub.add_parser("logout", help="cierra la sesión de la web").set_defaults(fn=cmd_logout)
    return p


def run(argv: list[str], store: Store) -> int:
    args = build_parser().parse_args(argv)
    try:
        return args.fn(args, store)
    except (Abort, ChallengeError, runtime.LabError, RouterOSError, AccountError) as e:
        print(f"error: {e}", file=sys.stderr)
        return 1
    except (EOFError, KeyboardInterrupt):
        print("\nCancelado.", file=sys.stderr)
        return 1
    except Exception as e:  # red de seguridad: nada de tracebacks al alumno
        if os.environ.get("NETLABS_DEBUG"):
            raise
        print(f"error inesperado: {e} (usa NETLABS_DEBUG=1 para ver el detalle)", file=sys.stderr)
        return 1


def main(argv: list[str] | None = None) -> None:
    sys.exit(run(sys.argv[1:] if argv is None else argv, Store(STORE_PATH)))
