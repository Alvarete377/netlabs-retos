# Controlador de dominio Active Directory con Samba (módulo Usuarios y permisos) y cliente Kerberos/LDAP.
# El dominio NO viene creado: se provisiona en cada reto (configs/), para poder romperlo a gusto.
FROM netlabs/debian:0.2
RUN apt-get update && apt-get install -y --no-install-recommends \
      samba samba-ad-provision samba-ad-dc winbind smbclient krb5-user ldb-tools ldap-utils \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && systemctl disable smbd nmbd winbind samba-ad-dc \
    && rm -f /etc/samba/smb.conf /etc/krb5.conf
