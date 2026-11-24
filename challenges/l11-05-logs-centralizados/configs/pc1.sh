# Puesto de la sede.
ip route del default dev eth0 2>/dev/null || true
echo 'nameserver 192.168.1.1' > /etc/resolv.conf
