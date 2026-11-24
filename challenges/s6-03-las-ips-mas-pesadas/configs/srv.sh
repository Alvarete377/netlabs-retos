python3 - <<'PY'
import random
r = random.Random()
ips = random.sample([f'10.{a}.{b}.{c}' for a in range(1, 4) for b in range(1, 4) for c in range(1, 30)], 9)
lines = []
for n, ip in enumerate(ips, start=1):
    lines += [f'{ip} - - [24/Nov/2026:10:00:{n:02d} +0100] "GET /p{n} HTTP/1.1" 200 512 "-" "curl"'] * (n * 3)
r.shuffle(lines)
open('/tmp/acceso.log', 'w').write('\n'.join(lines) + '\n')
PY
cp /tmp/acceso.log /var/log/nginx/acceso-ejemplo.log
rm -f /tmp/acceso.log
