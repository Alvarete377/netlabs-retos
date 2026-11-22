from dataclasses import dataclass
from pathlib import Path

import yaml

from netlabs.checks import Check, CheckError, parse_checks

LAB_NAME = "netlabs"
TYPES = {"build", "troubleshoot", "capture"}
DIFFICULTIES = {"easy", "medium", "hard"}
REQUIRED = ("id", "title", "level", "type", "difficulty", "objectives", "flag_seed", "ram_mb")


class ChallengeError(Exception):
    pass


@dataclass
class Challenge:
    id: str
    title: str
    level: str
    type: str
    difficulty: str
    objectives: list[str]
    hints: list[str]
    flag_seed: str
    ram_mb: int
    path: Path
    checks: list[Check]
    nodes: dict[str, str]

    @property
    def topology(self) -> Path:
        return self.path / "topology.clab.yml"


def _read_yaml(p: Path):
    try:
        return yaml.safe_load(p.read_text(encoding="utf-8"))
    except FileNotFoundError:
        raise ChallengeError(f"{p.parent.name}: falta {p.name}")
    except yaml.YAMLError as e:
        raise ChallengeError(f"{p.parent.name}/{p.name}: YAML inválido: {e}")


def topology_nodes(topo: dict) -> dict[str, str]:
    t = topo.get("topology") or {}
    default_kind = (t.get("defaults") or {}).get("kind")
    return {name: (spec or {}).get("kind", default_kind) for name, spec in (t.get("nodes") or {}).items()}


def load_challenge(path: Path) -> Challenge:
    name = path.name
    meta = _read_yaml(path / "challenge.yml") or {}
    missing = [k for k in REQUIRED if k not in meta]
    if missing:
        raise ChallengeError(f"{name}: faltan campos {missing}")
    if meta["id"] != name:
        raise ChallengeError(f"{name}: el id '{meta['id']}' no coincide con la carpeta")
    if meta["type"] not in TYPES:
        raise ChallengeError(f"{name}: type debe ser uno de {sorted(TYPES)}")
    if meta["difficulty"] not in DIFFICULTIES:
        raise ChallengeError(f"{name}: difficulty debe ser uno de {sorted(DIFFICULTIES)}")

    for field in ("objectives", "hints"):
        value = meta.get(field)
        if value is not None and not isinstance(value, list):
            raise ChallengeError(f"{name}: {field} debe ser una lista de textos")
    items = list(meta["objectives"] or []) + list(meta.get("hints") or [])
    if not all(isinstance(i, str) for i in items):
        raise ChallengeError(f"{name}: objectives y hints deben ser textos (pon comillas si contienen ': ')")

    topo = _read_yaml(path / "topology.clab.yml") or {}
    if topo.get("name") != LAB_NAME:
        raise ChallengeError(f"{name}: la topología debe tener name: {LAB_NAME}")
    nodes = topology_nodes(topo)

    try:
        checks = parse_checks(_read_yaml(path / "checks.yml") or [])
    except CheckError as e:
        raise ChallengeError(f"{name}: {e}")
    if not checks:
        raise ChallengeError(f"{name}: checks.yml no tiene comprobaciones")
    for c in checks:
        for key in ("from", "node"):
            if key in c.params and c.params[key] not in nodes:
                raise ChallengeError(f"{name}: el check '{c.desc}' usa el nodo desconocido '{c.params[key]}'")

    return Challenge(
        id=meta["id"], title=meta["title"], level=str(meta["level"]), type=meta["type"],
        difficulty=meta["difficulty"], objectives=list(meta["objectives"]),
        hints=list(meta.get("hints") or []), flag_seed=str(meta["flag_seed"]),
        ram_mb=int(meta["ram_mb"]), path=path, checks=checks, nodes=nodes,
    )


def discover(root: Path) -> list[Challenge]:
    found = [load_challenge(d) for d in sorted(root.iterdir()) if (d / "challenge.yml").exists()]
    return sorted(found, key=lambda c: (float(c.level), c.id))
