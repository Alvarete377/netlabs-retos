samba-tool domain provision --realm=EMPRESA.LAB --domain=EMPRESA --server-role=dc \
    --dns-backend=SAMBA_INTERNAL --host-ip=10.0.0.10 --adminpass='Admin.Dominio1' >/var/log/provision.log 2>&1
systemctl unmask -q samba-ad-dc
systemctl enable -q --now samba-ad-dc
i=0; while [ $i -lt 30 ] && ! samba-tool user list >/dev/null 2>&1; do sleep 1; i=$((i+1)); done
samba-tool user create marta 'Verano.2023X' --given-name=Marta >/dev/null
