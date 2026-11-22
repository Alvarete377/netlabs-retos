import io
import socket
import time

import paramiko


class RouterOSError(Exception):
    pass


class RouterOS:
    def __init__(self, host: str, user: str = "admin", password: str = "admin", retries: int = 6, delay: float = 5):
        self.host, self.user, self.password = host, user, password
        self.retries, self.delay = retries, delay

    def _connect(self) -> paramiko.SSHClient:
        last = None
        for _ in range(self.retries):
            client = paramiko.SSHClient()
            client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            try:
                client.connect(self.host, username=self.user, password=self.password,
                               look_for_keys=False, allow_agent=False, timeout=10)
                return client
            except (paramiko.SSHException, OSError) as e:
                last = e
                time.sleep(self.delay)
        raise RouterOSError(f"No se puede conectar por SSH a {self.host}: {last}")

    def run(self, cmd: str) -> str:
        client = self._connect()
        try:
            _, out, err = client.exec_command(cmd, timeout=30)
            text = out.read().decode(errors="replace") + err.read().decode(errors="replace")
        except (paramiko.SSHException, socket.timeout, OSError) as e:
            raise RouterOSError(f"Fallo al ejecutar `{cmd}` en {self.host}: {e}")
        finally:
            client.close()
        return text.replace("\r", "")

    def import_script(self, name: str, content: str) -> None:
        client = self._connect()
        try:
            sftp = client.open_sftp()
            sftp.putfo(io.BytesIO(content.encode()), name)
            sftp.close()
            _, out, _ = client.exec_command(f"/import file-name={name}", timeout=120)
            result = out.read().decode(errors="replace")
        except (paramiko.SSHException, socket.timeout, OSError) as e:
            raise RouterOSError(f"Fallo al importar {name} en {self.host}: {e}")
        finally:
            client.close()
        if "successfully" not in result:
            raise RouterOSError(f"Fallo al importar {name} en {self.host}: {result.strip()}")
