# Puerto de SSH no estándar
sed -i 's/^#\?Port .*/Port 2222/' /etc/ssh/sshd_config
systemctl restart ssh
# Usuarios con distintas shells
useradd -m -s /bin/bash ana
useradd -m -s /bin/sh pedro
useradd -M -r -s /usr/sbin/nologin webapp
# Copias de seguridad de distintos tamaños
head -c 1500K /dev/urandom > /var/backups/facturas-2024.tar.gz
head -c 3200K /dev/urandom > /var/backups/nominas-2024.tar.gz
head -c 2600K /dev/urandom > /var/backups/clientes-2023.sql.gz
# Configuración de una aplicación, con una contraseña olvidada en un directorio oculto
mkdir -p /etc/app/conf.d/.antiguo
printf 'APP_NAME=gestion\nAPP_PORT=8080\n' > /etc/app/app.conf
printf 'CACHE_SIZE=256\n' > /etc/app/conf.d/10-cache.conf
printf 'LOG_LEVEL=info\n' > /etc/app/conf.d/20-logs.conf
printf '# migración 2022, borrar\nDB_HOST=10.0.5.20\nDB_USER=gestion\nDB_PASSWORD=Tr1gal-77\n' > /etc/app/conf.d/.antiguo/db.env
