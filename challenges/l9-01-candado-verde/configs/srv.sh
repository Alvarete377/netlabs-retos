# Servidor web de la intranet: tiene la CA de la empresa, pero ningún certificado propio.
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
cat > /root/ca/raiz.crt <<'PEM'
-----BEGIN CERTIFICATE-----
MIIBoDCCAUWgAwIBAgIUUpuZKMRJF4mE0SIuJ9XR2JNeaf0wCgYIKoZIzj0EAwIw
LDEQMA4GA1UECgwHTmV0TGFiczEYMBYGA1UEAwwPTmV0TGFicyBDQSBSYWl6MB4X
DTI2MDEwMTAwMDAwMFoXDTM2MDEwMTAwMDAwMFowLDEQMA4GA1UECgwHTmV0TGFi
czEYMBYGA1UEAwwPTmV0TGFicyBDQSBSYWl6MFkwEwYHKoZIzj0CAQYIKoZIzj0D
AQcDQgAE74Z3232bcyqGJcSwxBEek0jk62WlLacrn0mj08pKAZBk/vMOBNXFW4W6
eek1wSynrT9N4psRvo6SCVTG3B9z/aNFMEMwEgYDVR0TAQH/BAgwBgEB/wIBATAd
BgNVHQ4EFgQUcom7CuBSXkncYAMrrtEO+bjgZzMwDgYDVR0PAQH/BAQDAgEGMAoG
CCqGSM49BAMCA0kAMEYCIQDGqSY8dFSeBM4iqv12bIJvS3jVArGMNwqRxPw02oXp
RAIhAKHZbDs5vbO586B9V9ikvA3ZRVJc3MjYYwIXspvZ9pZL
-----END CERTIFICATE-----
PEM
cat > /root/ca/raiz.key <<'PEM'
-----BEGIN EC PRIVATE KEY-----
MHcCAQEEILaHA3S1uHOCnedDX0lhlxvFNd6ENZwxiMTqx4ek/dBhoAoGCCqGSM49
AwEHoUQDQgAE74Z3232bcyqGJcSwxBEek0jk62WlLacrn0mj08pKAZBk/vMOBNXF
W4W6eek1wSynrT9N4psRvo6SCVTG3B9z/Q==
-----END EC PRIVATE KEY-----
PEM
chmod 600 /root/ca/raiz.key
echo 'intranet de la empresa: bienvenido' > /etc/web/pagina.txt
pkill -f OPENSSL-LISTEN 2>/dev/null; rm -f /etc/web/servidor.crt /etc/web/servidor.key
