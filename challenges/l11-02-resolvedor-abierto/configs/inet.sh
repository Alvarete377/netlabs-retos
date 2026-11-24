# Un equipo cualquiera de Internet.
ip route del default dev eth0 2>/dev/null || true
echo 'nameserver 203.0.113.1' > /etc/resolv.conf
