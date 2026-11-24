/system identity set name=r1
/ip address add address=203.0.113.1/24 interface=ether2 comment="WAN (Internet)"
/ip address add address=192.168.20.1/24 interface=ether3 comment="servidores"
/ip address add address=192.168.1.1/24 interface=ether4 comment="oficina"
/ip dns set allow-remote-requests=yes
/ip dns static add name=tienda.lab address=203.0.113.1 comment="tienda online (IP publica)"
/ip firewall nat add chain=srcnat out-interface=ether2 action=masquerade comment="salida a Internet"
/ip firewall nat add chain=dstnat in-interface=ether2 protocol=tcp dst-port=443 action=dst-nat to-addresses=192.168.20.10 to-ports=8443 comment="publicar la tienda"
/ip firewall filter add chain=forward connection-state=established,related action=accept comment="respuestas"
/ip firewall filter add chain=forward connection-state=invalid action=drop comment="invalidos"
/ip firewall filter add chain=forward protocol=tcp dst-port=443 action=drop comment="mantenimiento: tienda cerrada"
/ip firewall filter add chain=forward connection-nat-state=dstnat action=accept comment="lo publicado"
/ip firewall filter add chain=forward in-interface=ether4 action=accept comment="la oficina sale a todas partes"
/ip firewall filter add chain=forward action=drop comment="todo lo demas, fuera"
