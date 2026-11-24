# Servidor compartido: aloja web.lab y apuestas.lab en la misma IP y puerto.
ip route del default dev eth0 2>/dev/null
mkdir -p /etc/web /root/ca
cat > /usr/local/bin/web.sh <<'EOF'
#!/bin/sh
read -r _peticion
printf 'HTTP/1.0 200 OK\r\nContent-Type: text/plain; charset=utf-8\r\n\r\n%s\n' "$(cat /etc/web/pagina.txt)"
EOF
cat > /usr/local/bin/servidor-https <<'EOF'
#!/bin/sh
# Arranca (o reinicia) el servidor HTTPS del puerto 443:
#   certificado (seguido de su cadena): /etc/web/servidor.crt
#   clave privada:                      /etc/web/servidor.key
#   si existe /etc/web/ca-clientes.crt, exige certificado de cliente firmado por esa CA (mTLS)
pkill -f OPENSSL-LISTEN 2>/dev/null; sleep 0.5
if [ ! -s /etc/web/servidor.crt ] || [ ! -s /etc/web/servidor.key ]; then
  echo "Falta /etc/web/servidor.crt o /etc/web/servidor.key"; exit 1
fi
opts="cert=/etc/web/servidor.crt,key=/etc/web/servidor.key"
if [ -s /etc/web/ca-clientes.crt ]; then opts="$opts,cafile=/etc/web/ca-clientes.crt,verify=1"
else opts="$opts,verify=0"; fi
setsid socat OPENSSL-LISTEN:443,fork,reuseaddr,$opts EXEC:/usr/local/bin/web.sh </dev/null >>/var/log/https.log 2>&1 &
sleep 0.7
if pgrep -f OPENSSL-LISTEN >/dev/null; then echo "servidor HTTPS en marcha (443)"
else echo "No arranca: mira /var/log/https.log"; exit 1; fi
EOF
chmod +x /usr/local/bin/web.sh /usr/local/bin/servidor-https
cat > /etc/web/servidor.crt <<'PEM'
-----BEGIN CERTIFICATE-----
MIIB/jCCAaOgAwIBAgIUU98Jy15oySvLHcY2z5Tzf5WJA+YwCgYIKoZIzj0EAwIw
LDEQMA4GA1UECgwHTmV0TGFiczEYMBYGA1UEAwwPTmV0TGFicyBDQSBSYWl6MB4X
DTI2MDEwMTAwMDAwMFoXDTMxMDEwMTAwMDAwMFowJDEQMA4GA1UECgwHTmV0TGFi
czEQMA4GA1UEAwwHd2ViLmxhYjBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABCUz
+3Jzx91MGC/Gja5YTofHZKtAeu9Bdz0Fp01MZrJImvK2k4v2TfDT9f5ajcFkUZT3
3/KWhHim+hUF8X8JGLSjgaowgacwDAYDVR0TAQH/BAIwADAdBgNVHQ4EFgQUXUUq
nojs4hSS5KAgr1ys6yqIKs4wHwYDVR0jBBgwFoAUcom7CuBSXkncYAMrrtEO+bjg
ZzMwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUFBwMBMDIGA1UdEQQr
MCmCB3dlYi5sYWKCDGFwdWVzdGFzLmxhYoIQd3d3LmFwdWVzdGFzLmxhYjAKBggq
hkjOPQQDAgNJADBGAiEA6Lle0ZLZ749IlhxaflrNGQJGt5BbMgZuexl1Y9U2UboC
IQD7IxhoQ1RM9GltOR7/aqhNK5IfaDjCWrY9gulfP2VZPA==
-----END CERTIFICATE-----
PEM
cat > /etc/web/servidor.key <<'PEM'
-----BEGIN EC PRIVATE KEY-----
MHcCAQEEICBFPIgYrFYEWlWBKfVfCxuXJ4KUl/V3bkw+qfz/7arAoAoGCCqGSM49
AwEHoUQDQgAEJTP7cnPH3UwYL8aNrlhOh8dkq0B670F3PQWnTUxmskia8raTi/ZN
8NP1/lqNwWRRlPff8paEeKb6FQXxfwkYtA==
-----END EC PRIVATE KEY-----
PEM
echo 'servidor compartido: intranet y otras webs' > /etc/web/pagina.txt
servidor-https >/dev/null
