import http.client
import json
import os
import re
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path

AUTH_PATH = Path.home() / ".netlabs" / "auth.json"
DEFAULT_API_URL = "https://net-labs.vercel.app"
MAX_RESPONSE_BYTES = 65536

_URL_RE = re.compile(r"\Ahttps?://[^\s\x00-\x1f\x7f]+\Z")
_TOKEN_RE = re.compile(r"\Anlt_[A-Za-z0-9_-]{16,196}\Z")
_FLAG_RE = re.compile(r"\ANL\{[0-9a-f]{16}\}\Z")


class AccountError(Exception):
    pass


class _NoRedirectHandler(urllib.request.HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        return None


def default_api_url() -> str:
    return os.environ.get("NETLABS_API") or DEFAULT_API_URL


def _validate_api_url(api_url: str) -> str:
    if not isinstance(api_url, str) or not _URL_RE.fullmatch(api_url):
        raise AccountError("URL de API inválida: debe usar http:// o https:// y no contener espacios")
    parsed = urllib.parse.urlsplit(api_url)
    if parsed.scheme not in ("http", "https") or not parsed.netloc or not parsed.hostname:
        raise AccountError("URL de API inválida: debe usar http:// o https:// y no contener espacios")
    return api_url.rstrip("/")


def _validate_token(token: str) -> str:
    if not isinstance(token, str) or not _TOKEN_RE.fullmatch(token):
        raise AccountError(
            "Token inválido: debe empezar por 'nlt_' y tener entre 20 y 200 caracteres [A-Za-z0-9_-]"
        )
    return token


def save(api_url: str, token: str) -> None:
    clean_url = _validate_api_url(api_url)
    clean_token = _validate_token(token)
    AUTH_PATH.parent.mkdir(mode=0o700, parents=True, exist_ok=True)
    payload = json.dumps({"api_url": clean_url, "token": clean_token}, indent=2, ensure_ascii=False)
    flags = os.O_WRONLY | os.O_CREAT | os.O_TRUNC
    fd = os.open(AUTH_PATH, flags, 0o600)
    if hasattr(os, "fchmod"):
        try:
            os.fchmod(fd, 0o600)
        except OSError:
            pass
    with os.fdopen(fd, "w", encoding="utf-8", newline="\n") as f:
        f.write(payload)
    try:
        os.chmod(AUTH_PATH, 0o600)
    except OSError:
        pass


def load() -> dict | None:
    if not AUTH_PATH.exists():
        return None
    try:
        data = json.loads(AUTH_PATH.read_text(encoding="utf-8"))
    except (OSError, ValueError):
        return None
    if not isinstance(data, dict):
        return None
    try:
        api_url = _validate_api_url(data.get("api_url"))
        token = _validate_token(data.get("token"))
    except AccountError:
        return None
    return {"api_url": api_url, "token": token}


def clear() -> None:
    AUTH_PATH.unlink(missing_ok=True)


def fetch_flag(challenge_id: str, timeout: float = 10) -> str:
    session = load()
    if not session:
        raise AccountError("No hay sesión iniciada: usa lab login <token>")
    api_url = (session.get("api_url") or default_api_url()).rstrip("/")
    token = session["token"]
    url = f"{api_url}/api/flag"
    body = json.dumps({"challenge_id": challenge_id}).encode("utf-8")
    req = urllib.request.Request(
        url,
        data=body,
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/json",
        },
        method="POST",
    )
    opener = urllib.request.build_opener(_NoRedirectHandler())
    try:
        with opener.open(req, timeout=timeout) as resp:
            if not (200 <= getattr(resp, "status", 200) < 300):
                raise AccountError("La web no responde, inténtalo más tarde")
            raw_bytes = resp.read(MAX_RESPONSE_BYTES + 1)
    except urllib.error.HTTPError as e:
        if e.code == 401:
            raise AccountError(
                "Tu sesión de lab no es válida o fue revocada: vuelve a hacer lab login"
            ) from None
        if e.code == 404:
            raise AccountError("Ese reto no existe en la web") from None
        raise AccountError("La web no responde, inténtalo más tarde") from None
    except (urllib.error.URLError, http.client.HTTPException, TimeoutError, OSError, ValueError):
        raise AccountError("La web no responde, inténtalo más tarde") from None

    if len(raw_bytes) > MAX_RESPONSE_BYTES:
        raise AccountError("La web devolvió una respuesta inválida")

    try:
        raw = raw_bytes.decode("utf-8")
        payload = json.loads(raw)
    except (UnicodeDecodeError, ValueError):
        raise AccountError("La web devolvió una respuesta inválida") from None

    flag = payload.get("flag") if isinstance(payload, dict) else None
    if not isinstance(flag, str) or not _FLAG_RE.fullmatch(flag):
        raise AccountError("La web devolvió una flag con formato inválido")
    return flag
