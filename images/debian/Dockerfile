# Servidor Debian con systemd para los retos de Sistemas. Arranca /sbin/init como PID 1.
FROM debian:12-slim
ENV container=docker DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
      systemd systemd-sysv dbus sudo bash-completion less nano vim-tiny man-db manpages \
      openssh-server nginx cron rsyslog logrotate curl ca-certificates iproute2 iputils-ping \
      procps psmisc lsof file acl tree htop strace ncdu \
      e2fsprogs xfsprogs lvm2 parted quota util-linux \
      python3 snmpd snmp \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    # Fuera lo que no tiene sentido en un contenedor y sólo ensucia el arranque.
    && systemctl mask systemd-udevd.service systemd-udevd-kernel.socket systemd-udevd-control.socket \
         systemd-modules-load.service sys-kernel-config.mount sys-kernel-debug.mount \
         systemd-remount-fs.service getty.target console-getty.service systemd-logind.service \
    && echo 'PS1="\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ "' >> /root/.bashrc \
    && echo "NetLabs · Sistemas. Estás dentro de un servidor Debian del laboratorio." > /etc/motd
# 0.2: MIBs estándar de SNMP (SNMPv2-MIB, IF-MIB, HOST-RESOURCES-MIB...), en non-free porque su licencia
# no es DFSG; el paquete las descarga al instalarse. Sin ellas habría que usar OIDs numéricos.
RUN sed -i 's/^Components: main$/Components: main non-free/' /etc/apt/sources.list.d/debian.sources \
    && apt-get update && apt-get install -y --no-install-recommends snmp-mibs-downloader \
    && sed -i 's/^mibs :/# mibs :/' /etc/snmp/snmp.conf \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
