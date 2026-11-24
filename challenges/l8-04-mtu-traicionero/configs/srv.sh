# Servidor de informes: / responde algo corto; /informe, un informe largo (unos 40 KB).
cat > /usr/local/bin/web.sh <<'EOF'
#!/bin/sh
read -r _m ruta _v
if [ "$ruta" = "/informe" ]; then
  printf 'HTTP/1.0 200 OK\r\nContent-Type: text/plain\r\n\r\n'
  i=0; while [ $i -lt 600 ]; do printf 'linea %04d del informe trimestral: ventas, gastos y previsiones.\n' $i; i=$((i+1)); done
  printf 'FIN-DEL-INFORME\n'
else
  printf 'HTTP/1.0 200 OK\r\nContent-Type: text/plain\r\n\r\nservidor de informes: pide /informe\n'
fi
EOF
chmod +x /usr/local/bin/web.sh
ip route del default dev eth0 2>/dev/null
pkill socat 2>/dev/null
setsid socat TCP4-LISTEN:80,fork,reuseaddr EXEC:/usr/local/bin/web.sh </dev/null >/dev/null 2>&1 &
sleep 1
