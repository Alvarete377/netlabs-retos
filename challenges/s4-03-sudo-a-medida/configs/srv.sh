useradd -m -s /bin/bash -G sudo ana
echo 'ana:Admin.2024' | chpasswd
useradd -m -s /bin/bash -G sudo soporte
echo 'soporte:Soporte.2024' | chpasswd
systemctl restart nginx
