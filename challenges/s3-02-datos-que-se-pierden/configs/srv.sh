systemctl start netlabs-imagenes
podman run -d -q --name registro alpine:3.20 sh -c "mkdir -p /datos; [ -s /datos/registro.txt ] || printf 'HISTORICO 2025-01: 1342 pedidos\\nHISTORICO 2025-02: 1501 pedidos\\n' > /datos/registro.txt; while true; do echo \"\$(date +%F_%T) pedido\" >> /datos/registro.txt; sleep 5; done" >/dev/null
