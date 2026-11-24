groupadd ventas; groupadd marketing; groupadd rrhh
useradd -m -s /bin/bash -G ventas ana
useradd -m -s /bin/bash -G ventas luis
useradd -m -s /bin/bash -G marketing pedro
useradd -m -s /bin/bash -G rrhh eva
mkdir -p /srv/compartido/ventas
echo "tarifa 2025: 49 EUR/mes" > /srv/compartido/ventas/tarifas.txt
chmod 755 /srv/compartido/ventas
