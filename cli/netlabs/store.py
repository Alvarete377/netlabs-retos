import json
import os
import sys
from pathlib import Path


class Store:
    """Estado local del alumno: lab activo, retos completados, respuestas y pistas vistas."""

    def __init__(self, path: Path):
        self.path = path
        self.data = {"active": None, "completed": {}, "answers": {}, "hints": {}}
        if path.exists():
            try:
                loaded = json.loads(path.read_text(encoding="utf-8"))
                if not isinstance(loaded, dict):
                    raise ValueError("no es un objeto JSON")
                self.data.update(loaded)
            except ValueError:  # JSON invalido (UnicodeDecodeError tambien es ValueError)
                os.replace(path, path.with_name(path.name + ".bak"))
                print("aviso: state.json estaba corrupto; se ha guardado como state.json.bak "
                      "y se empieza de cero", file=sys.stderr)

    def save(self) -> None:
        self.path.parent.mkdir(parents=True, exist_ok=True)
        tmp = self.path.with_name(self.path.name + ".tmp")
        tmp.write_text(json.dumps(self.data, indent=2, ensure_ascii=False), encoding="utf-8")
        os.replace(tmp, self.path)

    @property
    def active(self) -> str | None:
        return self.data["active"]

    def set_active(self, cid: str | None) -> None:
        self.data["active"] = cid
        self.save()

    def is_completed(self, cid: str) -> bool:
        return cid in self.data["completed"]

    def mark_completed(self, cid: str, flag: str) -> None:
        self.data["completed"][cid] = flag
        self.save()

    def answered(self, cid: str) -> set[str]:
        return set(self.data["answers"].get(cid, []))

    def record_answer(self, cid: str, qid: str) -> None:
        answers = self.data["answers"].setdefault(cid, [])
        if qid not in answers:
            answers.append(qid)
        self.save()

    def next_hint(self, cid: str, hints: list[str]) -> str | None:
        shown = self.data["hints"].get(cid, 0)
        if shown >= len(hints):
            return None
        self.data["hints"][cid] = shown + 1
        self.save()
        return hints[shown]
