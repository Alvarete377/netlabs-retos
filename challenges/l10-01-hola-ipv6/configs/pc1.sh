# Puesto con IPv6 únicamente: se configura solo con los anuncios del router (SLAAC).
ip -6 route del default dev eth0 2>/dev/null || true
