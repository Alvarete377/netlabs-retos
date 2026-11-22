import shutil
import subprocess
import time
from pathlib import Path

from netlabs.challenge import LAB_NAME, Challenge
from netlabs.routeros import RouterOS

RUN_DIR = Path.home() / ".netlabs" / "run"
ROS_KIND = "mikrotik_ros"


class LabError(Exception):
    pass


def container(node: str) -> str:
    return f"clab-{LAB_NAME}-{node}"


def parse_meminfo(text: str) -> int:
    for line in text.splitlines():
        if line.startswith("MemAvailable:"):
            return int(line.split()[1]) // 1024
    raise LabError("No se pudo leer la memoria disponible")


def preflight(ch: Challenge) -> None:
    if not Path("/dev/kvm").exists():
        raise LabError("No hay /dev/kvm. En Windows añade nestedVirtualization=true en "
                       "%UserProfile%\\.wslconfig y ejecuta `wsl --shutdown`.")
    avail = parse_meminfo(Path("/proc/meminfo").read_text())
    if avail < ch.ram_mb:
        raise LabError(f"El reto necesita ~{ch.ram_mb} MB de RAM y hay {avail} MB libres. Cierra programas o apaga otros labs.")


def _run(argv: list[str], timeout: int = 900, input: str | None = None) -> str:
    try:
        r = subprocess.run(argv, capture_output=True, text=True, timeout=timeout, input=input)
    except subprocess.TimeoutExpired:
        raise LabError(f"`{' '.join(argv)}` tardó más de {timeout}s y se canceló.")
    except FileNotFoundError:
        raise LabError(f"No encuentro el comando `{argv[0]}`. ¿Está instalado? Ejecuta runner/install.sh.")
    if r.returncode != 0:
        raise LabError(f"`{' '.join(argv)}` falló:\n{(r.stderr or r.stdout)[-2000:]}")
    return r.stdout


def deploy(ch: Challenge) -> None:
    dst = RUN_DIR / ch.id
    if dst.exists():
        try:
            shutil.rmtree(dst)
        except PermissionError:
            raise LabError(f"No puedo borrar {dst}. Ejecuta: sudo rm -rf {dst}")
    shutil.copytree(ch.path, dst, ignore=shutil.ignore_patterns("solution"))
    _run(["sudo", "-n", "containerlab", "deploy", "-t", str(dst / "topology.clab.yml"), "--reconfigure"])


def destroy(cid: str | None = None) -> None:
    """Apaga el lab (siempre se llama 'netlabs'); no depende de la topologia copiada.

    `cid` se acepta por compatibilidad y se ignora.
    """
    try:
        _run(["sudo", "-n", "containerlab", "destroy", "--name", LAB_NAME, "--cleanup"])
    except LabError:
        # Sin lab desplegado containerlab falla; limpiamos a mano cualquier resto.
        ids = _run(["docker", "ps", "-aq", "--filter", f"label=containerlab={LAB_NAME}"]).split()
        if ids:
            _run(["docker", "rm", "-f", *ids])
    if cid:
        shutil.rmtree(RUN_DIR / cid, ignore_errors=True)


def health(node: str) -> str:
    try:
        r = subprocess.run(["docker", "inspect", "-f",
                            "{{if .State.Health}}{{.State.Health.Status}}{{else}}none{{end}}", container(node)],
                           capture_output=True, text=True)
    except FileNotFoundError:
        raise LabError("No encuentro docker. Ejecuta runner/install.sh o arranca Docker.")
    return r.stdout.strip() if r.returncode == 0 else "missing"


def is_running(node: str) -> bool:
    try:
        r = subprocess.run(["docker", "inspect", "-f", "{{.State.Running}}", container(node)],
                           capture_output=True, text=True)
    except FileNotFoundError:
        raise LabError("No encuentro docker. Ejecuta runner/install.sh o arranca Docker.")
    return r.returncode == 0 and r.stdout.strip() == "true"


def wait_ready(ch: Challenge, timeout: int = 420, poll: int = 5, on_wait=None) -> None:
    routers = [n for n, k in ch.nodes.items() if k == ROS_KIND]
    deadline = time.monotonic() + timeout
    while True:
        states = {n: health(n) for n in routers}
        if any(s == "missing" for s in states.values()) or not all(is_running(n) for n in routers):
            raise LabError("El lab no está en marcha (¿reiniciaste WSL?). Usa `lab reset`.")
        pending = [n for n in routers if states[n] != "healthy"]
        if not pending:
            return
        if time.monotonic() > deadline:
            raise LabError(f"Los routers no arrancaron en {timeout}s: {', '.join(pending)}")
        if on_wait:
            on_wait(pending)
        time.sleep(poll)


def mgmt_ip(node: str) -> str:
    ips = _run(["docker", "inspect", "-f", "{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}",
                container(node)]).split()
    if not ips:
        raise LabError(f"{node} no tiene IP de gestión")
    return ips[0]


def files_for(ch: Challenge, sub: str) -> list[tuple[str, Path]]:
    d = ch.path / sub
    if not d.is_dir():
        return []
    out = []
    for f in sorted(d.iterdir()):
        if f.name == "README.md":
            continue
        if f.suffix not in (".rsc", ".sh"):
            raise LabError(f"{sub}/{f.name}: solo se admiten .rsc (routers) y .sh (clientes)")
        if f.stem not in ch.nodes:
            raise LabError(f"{sub}/{f.name}: el nodo '{f.stem}' no existe en la topología")
        out.append((f.stem, f))
    return out


def apply_dir(ch: Challenge, sub: str) -> None:
    for node, f in files_for(ch, sub):
        content = f.read_text(encoding="utf-8")
        if f.suffix == ".rsc":
            RouterOS(mgmt_ip(node)).import_script(f.name, content)
        else:
            _run(["docker", "exec", "-i", container(node), "sh", "-s"], input=content)


class LabExecutor:
    def exec(self, node: str, argv: list[str]) -> tuple[int, str]:
        r = subprocess.run(["docker", "exec", container(node), *argv], capture_output=True, text=True, timeout=30)
        return r.returncode, r.stdout + r.stderr

    def routeros(self, node: str, cmd: str) -> str:
        return RouterOS(mgmt_ip(node)).run(cmd)
