mkdir -p /var/log/remoto
cat > /etc/rsyslog.d/10-servidor.conf <<'EOF'
module(load="imudp")
input(type="imudp" port="5140")
template(name="PorEquipo" type="string" string="/var/log/remoto/%FROMHOST-IP%.log")
if $fromhost-ip != "127.0.0.1" then {
    action(type="omfile" dynaFile="PorEquipo")
    stop
}
EOF
systemctl restart rsyslog
