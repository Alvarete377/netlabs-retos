# Servidor de logs: guarda en /var/log/remoto.log todo lo que llega por syslog (UDP 514).
ip route del default dev eth0 2>/dev/null || true
pkill socat 2>/dev/null
: > /var/log/remoto.log
setsid socat -u UDP4-RECV:514 OPEN:/var/log/remoto.log,creat,append </dev/null >/dev/null 2>&1 &
sleep 1
