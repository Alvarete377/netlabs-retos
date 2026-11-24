cat > /etc/krb5.conf <<'EOF'
[libdefaults]
    default_realm = EMPRESA.LAB
    dns_lookup_kdc = false
    dns_lookup_realm = false
[realms]
    EMPRESA.LAB = {
        kdc = 10.0.0.10
    }
EOF
