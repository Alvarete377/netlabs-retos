# PC recién sacado de la caja: sin IP, la pide por DHCP y la renueva. Como un PC real, aplica en
# cada renovación lo que diga el servidor (también si cambia la puerta de enlace).
cat > /usr/local/bin/dhcp-evento.sh <<'EOF'
#!/bin/sh
case "$1" in
  deconfig) ip addr flush dev "$interface" ;;
  bound|renew)
    ip addr replace "$ip/${mask:-24}" dev "$interface"
    [ -n "$router" ] && ip route replace default via "${router%% *}" dev "$interface"
    [ -n "$dns" ] && printf 'nameserver %s\n' $dns > /etc/resolv.conf 2>/dev/null
    ;;
esac
exit 0
EOF
chmod +x /usr/local/bin/dhcp-evento.sh
ip route del default dev eth0 2>/dev/null
ip addr flush dev eth1 2>/dev/null
pkill udhcpc 2>/dev/null
setsid udhcpc -i eth1 -b -t 0 -T 2 -A 3 -s /usr/local/bin/dhcp-evento.sh </dev/null >/dev/null 2>&1 &
sleep 1
