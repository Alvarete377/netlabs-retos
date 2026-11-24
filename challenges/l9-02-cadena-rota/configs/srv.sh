# Servidor de la intranet, montado por el anterior administrador.
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
cat > /root/ca/inter.crt <<'PEM'
-----BEGIN CERTIFICATE-----
MIIBxjCCAWygAwIBAgIUbjM3Q/dvG3e5IUZ6YKdHx4hLJe0wCgYIKoZIzj0EAwIw
LDEQMA4GA1UECgwHTmV0TGFiczEYMBYGA1UEAwwPTmV0TGFicyBDQSBSYWl6MB4X
DTI2MDEwMTAwMDAwMFoXDTM0MDEwMTAwMDAwMFowMjEQMA4GA1UECgwHTmV0TGFi
czEeMBwGA1UEAwwVTmV0TGFicyBDQSBJbnRlcm1lZGlhMFkwEwYHKoZIzj0CAQYI
KoZIzj0DAQcDQgAEaeK100cq8dS8RQp0uee6XT9W5S1AjDwCHvz1YVABDhHowAfH
u+OLC4ZWge/t8rRzC+9/DvWXG5pxoz9PbNHm5aNmMGQwEgYDVR0TAQH/BAgwBgEB
/wIBADAdBgNVHQ4EFgQUOTyQmxzLy+b84hpOfvKXgL98SxYwHwYDVR0jBBgwFoAU
com7CuBSXkncYAMrrtEO+bjgZzMwDgYDVR0PAQH/BAQDAgEGMAoGCCqGSM49BAMC
A0gAMEUCIFutiT7+9pJxbJ0ASVlNpdSz29qQjD+BVBMcnhUn1GvrAiEAjUIQ8OCw
h1vpTrJItRu3E+PsvEIrH69fhOb4WcvHkhQ=
-----END CERTIFICATE-----
PEM
cat > /root/ca/inter.key <<'PEM'
-----BEGIN EC PRIVATE KEY-----
MHcCAQEEINBTcknx7slGSyyo7E6VKm6SHVXZQZZs+0FPguv4zorVoAoGCCqGSM49
AwEHoUQDQgAEaeK100cq8dS8RQp0uee6XT9W5S1AjDwCHvz1YVABDhHowAfHu+OL
C4ZWge/t8rRzC+9/DvWXG5pxoz9PbNHm5Q==
-----END EC PRIVATE KEY-----
PEM
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
chmod 600 /root/ca/inter.key
cat > /etc/web/servidor.crt <<'PEM'
-----BEGIN CERTIFICATE-----
MIIB6zCCAZGgAwIBAgIURnfc/A1b+n5jRa4bWmsv5pszg08wCgYIKoZIzj0EAwIw
MjEQMA4GA1UECgwHTmV0TGFiczEeMBwGA1UEAwwVTmV0TGFicyBDQSBJbnRlcm1l
ZGlhMB4XDTI2MDEwMTAwMDAwMFoXDTMxMDEwMTAwMDAwMFowKDEQMA4GA1UECgwH
TmV0TGFiczEUMBIGA1UEAwwLd3d3LndlYi5sYWIwWTATBgcqhkjOPQIBBggqhkjO
PQMBBwNCAASPsFLHPFtGLk8xc3c2whsB9m0RSqYk/leeVsitMzz8j07YbsK1M+I+
InjPL+WitSrVw2moXK89kQxOFGpGDZk5o4GOMIGLMAwGA1UdEwEB/wQCMAAwHQYD
VR0OBBYEFPOMpiTUQTx9Aa8Pyhg+3utxTWZwMB8GA1UdIwQYMBaAFDk8kJscy8vm
/OIaTn7yl4C/fEsWMA4GA1UdDwEB/wQEAwIHgDATBgNVHSUEDDAKBggrBgEFBQcD
ATAWBgNVHREEDzANggt3d3cud2ViLmxhYjAKBggqhkjOPQQDAgNIADBFAiEA39YQ
nSatRTToxQnqfduk/S72OO14RFNK8gbXXZsViJoCIA1blZ4YEPWDWdsd5b924Qcl
kAcMEs5Wc2OW72ajK5Ho
-----END CERTIFICATE-----
PEM
cat > /etc/web/servidor.key <<'PEM'
-----BEGIN EC PRIVATE KEY-----
MHcCAQEEIOdon2H1zToN4Fg5yX7By7FtLlVFrRwKTKcjioTGf6kgoAoGCCqGSM49
AwEHoUQDQgAEj7BSxzxbRi5PMXN3NsIbAfZtEUqmJP5XnlbIrTM8/I9O2G7CtTPi
PiJ4zy/lorUq1cNpqFyvPZEMThRqRg2ZOQ==
-----END EC PRIVATE KEY-----
PEM
echo 'intranet de la empresa: bienvenido' > /etc/web/pagina.txt
servidor-https >/dev/null
