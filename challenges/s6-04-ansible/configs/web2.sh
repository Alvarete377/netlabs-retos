mkdir -p /root/.ssh
echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPi3PPHGgFjLoNCmZ/ZVJLDTyjkCZpx92KmHxHMJRgrO' > /root/.ssh/authorized_keys
chmod 700 /root/.ssh; chmod 600 /root/.ssh/authorized_keys
echo 'Bienvenido' > /etc/motd
systemctl disable -q --now nginx
