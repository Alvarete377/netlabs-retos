/system identity set name=isp
/ip address add address=203.0.113.1/24 interface=ether3 comment="resto de Internet"
/ip pool add name=clientes ranges=100.64.0.10-100.64.0.50
/ppp profile add name=pppoe-clientes local-address=100.64.0.1 remote-address=clientes
/ppp secret add name=oficina password=N3tL4bs profile=pppoe-clientes service=pppoe
/interface pppoe-server server add service-name=fibra interface=ether2 default-profile=pppoe-clientes disabled=no
