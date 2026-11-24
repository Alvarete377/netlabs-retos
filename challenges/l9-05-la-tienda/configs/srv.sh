# Servidor de la tienda online (443) con su panel interno (8080).
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
cat > /etc/web/servidor.key <<'PEM'
-----BEGIN EC PRIVATE KEY-----
MHcCAQEEINyBRk3Pt4TiDdsUTJoEzZW4hJ9PhfdAD9vmgbsMMnuOoAoGCCqGSM49
AwEHoUQDQgAEwQsffCsqgc46QL+u/t02uGvUo3Rg6+HwPCS9S/3yGjqHYiJj9LJZ
gGn0R/WuVRN5RlZdvPBjOQCfj2HQ1KaN7Q==
-----END EC PRIVATE KEY-----
PEM
cat > /etc/web/servidor.crt <<'PEM'
-----BEGIN CERTIFICATE-----
MIIB6TCCAY+gAwIBAgIUUvRqV6ij1qYrt7MRQQ/FoRqUtZowCgYIKoZIzj0EAwIw
MjEQMA4GA1UECgwHTmV0TGFiczEeMBwGA1UEAwwVTmV0TGFicyBDQSBJbnRlcm1l
ZGlhMB4XDTI1MDEwMTAwMDAwMFoXDTI2MDEwMTAwMDAwMFowJzEQMA4GA1UECgwH
TmV0TGFiczETMBEGA1UEAwwKdGllbmRhLmxhYjBZMBMGByqGSM49AgEGCCqGSM49
AwEHA0IABMELH3wrKoHOOkC/rv7dNrhr1KN0YOvh8DwkvUv98ho6h2IiY/SyWYBp
9Ef1rlUTeUZWXbzwYzkAn49h0NSmje2jgY0wgYowDAYDVR0TAQH/BAIwADAdBgNV
HQ4EFgQUwX707KoTGAoLxUaBpX9J1UMQdw0wHwYDVR0jBBgwFoAUOTyQmxzLy+b8
4hpOfvKXgL98SxYwDgYDVR0PAQH/BAQDAgeAMBMGA1UdJQQMMAoGCCsGAQUFBwMB
MBUGA1UdEQQOMAyCCnRpZW5kYS5sYWIwCgYIKoZIzj0EAwIDSAAwRQIhAPzxN2SW
aA4PFu4Vfa1EHSwpm4lpxn2j1ZXmrxFx+nIEAiANEAe+qlrSGs0UOwWAOXW0TKke
RpfqwPlsL9JfzHiqfw==
-----END CERTIFICATE-----
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
echo 'tienda online: ofertas de la semana' > /etc/web/pagina.txt
cat > /usr/local/bin/panel.sh <<'EOF'
#!/bin/sh
read -r _peticion
printf 'HTTP/1.0 200 OK\r\nContent-Type: text/plain\r\n\r\npanel interno de la tienda\n'
EOF
chmod +x /usr/local/bin/panel.sh
pkill -f TCP4-LISTEN:8080 2>/dev/null
setsid socat TCP4-LISTEN:8080,fork,reuseaddr EXEC:/usr/local/bin/panel.sh </dev/null >/dev/null 2>&1 &
servidor-https >/dev/null
