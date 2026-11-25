/system identity set name=r1
/ip address add address=192.168.1.1/24 interface=ether2 comment="LAN de la central"
/ip address add address=172.16.12.1/30 interface=ether3 comment="enlace con el router VyOS de la filial"
/ip firewall address-list add list=redes-central address=192.168.1.0/24
/routing filter rule add chain=entrada rule="reject" comment="pruebas del viernes: no aceptar nada de la filial"
/routing bgp connection add name=filial as=65001 router-id=10.255.255.1 local.role=ebgp remote.address=172.16.12.2 remote.as=65002 output.network=redes-central input.filter=entrada
