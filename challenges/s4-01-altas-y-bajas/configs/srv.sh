useradd -m -s /bin/bash marta
echo 'marta:Verano.2023' | chpasswd
mkdir -p /home/marta/informes
echo "Informe del tercer trimestre" > /home/marta/informes/q3.txt
chown -R marta:marta /home/marta/informes
