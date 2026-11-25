# NetLabs

Retos de redes y sistemas con routers MikroTik y servidores Linux reales, para practicar en tu PC al
estilo DockerLabs: levantas el laboratorio con un comando, lo resuelves y `lab check` te dice si está bien.

Web, guía de instalación paso a paso, ranking y writeups: **https://net-labs.vercel.app**

## Instalación (Windows + WSL2)
1. En PowerShell: `wsl --install -d Ubuntu-24.04`
2. En `%UserProfile%\.wslconfig`: `[wsl2]` + `nestedVirtualization=true`, y luego `wsl --shutdown`
3. Dentro de Ubuntu:

       git clone https://github.com/Alvarete377/netlabs-retos.git NetLabs
       cd NetLabs
       sudo NETLABS_USER=$USER bash runner/install.sh

   Si pide reiniciar por systemd: `wsl --shutdown` y repite el último comando.

Para tener los retos nuevos: `git pull && bash images/build.sh` dentro de la carpeta (reconstruye
las imágenes si han cambiado; los retos de TLS necesitan el cliente 0.2).

## Uso
    lab list                 # retos
    lab up l1-01-bridge-basico
    lab console sw1          # admin / admin
    lab check                # ¿resuelto?
    lab hint                 # pista
    lab down

Para el módulo Multifabricante (routers VyOS), construye su imagen una vez: `bash images/build-vyos.sh`
(descarga ~650 MB).

Con una cuenta en la web, `lab login <token>` hace que `lab check` te dé tu flag personal para el ranking.

## Retos

### Switching y VLANs
| Reto | id | Tipo | Dificultad |
|---|---|---|---|
| Tu primer switch | `l1-01-bridge-basico` | Montar | Fácil |
| Separa a los de contabilidad | `l1-02-vlans-basicas` | Montar | Fácil |
| El trunk que no troncaba | `l1-03-trunk-roto` | Troubleshooting | Fácil |
| El bucle maldito | `l1-04-stp-bucle` | Montar | Media |
| El switch misterioso | `l1-05-switch-misterioso` | Troubleshooting | Media |
| La planta nueva | `l1-06-planta-nueva` | Troubleshooting | Difícil |
### Rutas estáticas
| Reto | id | Tipo | Dificultad |
|---|---|---|---|
| Tu primer router | `l2-01-primer-router` | Montar | Fácil |
| Dos sedes | `l2-02-dos-sedes` | Montar | Fácil |
| Todo hacia el núcleo | `l2-03-ruta-por-defecto` | Montar | Fácil |
| No hay vuelta | `l2-04-no-hay-vuelta` | Troubleshooting | Media |
| Plan B | `l2-05-plan-b` | Troubleshooting | Media |
### Enrutamiento dinámico
| Reto | id | Tipo | Dificultad |
|---|---|---|---|
| Que se descubran solos | `l3-01-ospf-basico` | Montar | Fácil |
| El camino más corto no siempre es el mejor | `l3-02-ospf-coste` | Montar | Media |
| Divide y vencerás | `l3-03-ospf-areas` | Montar | Media |
| Hola, vecino de otro AS | `l3-04-ebgp` | Montar | Media |
| Vecinos que no se hablan | `l3-05-ospf-roto` | Troubleshooting | Media |
| Corre la voz | `l3-06-rip-basico` | Montar | Fácil |
| Dos idiomas, una red | `l3-07-rip-ospf` | Montar | Media |
| La filial heredada | `l3-08-filial-heredada` | Troubleshooting | Difícil |
### Firewalls
| Reto | id | Tipo | Dificultad |
|---|---|---|---|
| Cierra la puerta | `l4-01-cierra-la-puerta` | Montar | Fácil |
| Todos a Internet | `l4-02-todos-a-internet` | Montar | Fácil |
| Publica el servidor | `l4-03-publica-el-servidor` | Montar | Media |
| Lo justo y necesario | `l4-04-lo-justo` | Montar | Media |
| El firewall que no deja pasar | `l4-05-no-deja-pasar` | Troubleshooting | Media |
| La auditoría | `l4-06-la-auditoria` | Troubleshooting | Difícil |
### Acceso y enlace
| Reto | id | Tipo | Dificultad |
|---|---|---|---|
| Dos cables mejor que uno | `l5-01-dos-cables` | Montar | Fácil |
| Conectando con el proveedor | `l5-02-pppoe` | Montar | Fácil |
| Reparto automático | `l5-03-dhcp` | Montar | Fácil |
| El router de reserva | `l5-04-router-de-reserva` | Montar | Media |
| La sucursal sin Internet | `l5-05-sucursal-sin-internet` | Troubleshooting | Media |
| La oficina que se cae | `l5-06-oficina-que-se-cae` | Troubleshooting | Difícil |
### VPNs
| Reto | id | Tipo | Dificultad |
|---|---|---|---|
| Un túnel entre sedes | `l6-01-tunel-gre` | Montar | Fácil |
| WireGuard entre sedes | `l6-02-wireguard` | Montar | Media |
| IPsec y el NAT traicionero | `l6-03-ipsec` | Montar | Media |
| El túnel que no levanta | `l6-04-tunel-no-levanta` | Troubleshooting | Media |
| Todos pasan por la central | `l6-05-hub-and-spoke` | Troubleshooting | Difícil |
### Multifabricante
| Reto | id | Tipo | Dificultad |
|---|---|---|---|
| Hola, VyOS | `l7-01-hola-vyos` | Montar | Fácil |
| OSPF entre fabricantes | `l7-02-ospf-entre-fabricantes` | Montar | Media |
| IPsec entre fabricantes | `l7-03-ipsec-entre-fabricantes` | Montar | Difícil |
| Frontera VyOS | `l7-04-frontera-vyos` | Montar | Media |
| No se entienden | `l7-05-no-se-entienden` | Troubleshooting | Media |
### Diagnóstico
| Reto | id | Tipo | Dificultad |
|---|---|---|---|
| ¿Dónde se pierde? | `l8-01-donde-se-pierde` | Troubleshooting | Fácil |
| ¿Quién escucha? | `l8-02-quien-escucha` | Captura | Fácil |
| Contraseñas en claro | `l8-03-contrasenas-en-claro` | Captura | Media |
| El MTU traicionero | `l8-04-mtu-traicionero` | Troubleshooting | Media |
| El impostor | `l8-05-el-impostor` | Troubleshooting | Media |
### TLS y certificados
| Reto | id | Tipo | Dificultad |
|---|---|---|---|
| Candado verde | `l9-01-candado-verde` | Montar | Fácil |
| La cadena rota | `l9-02-cadena-rota` | Troubleshooting | Media |
| Por el nombre | `l9-03-por-el-nombre` | Montar | Media |
| ¿Quién eres? | `l9-04-quien-eres` | Montar | Media |
| La tienda que nadie ve | `l9-05-la-tienda` | Troubleshooting | Difícil |
### IPv6
| Reto | id | Tipo | Dificultad |
|---|---|---|---|
| Hola, IPv6 | `l10-01-hola-ipv6` | Montar | Fácil |
| Dos sedes, cero NAT | `l10-02-rutas-v6` | Montar | Fácil |
| El ICMP que no debías tirar | `l10-03-icmpv6-roto` | Troubleshooting | Media |
| Rutas que viajan solas (v6) | `l10-04-ospfv3` | Montar | Media |
| El prefijo que no llega | `l10-05-prefijo-delegado` | Troubleshooting | Difícil |
### Servicios de red
| Reto | id | Tipo | Dificultad |
|---|---|---|---|
| Pregúntale a r1 | `l11-01-pregunta-a-r1` | Montar | Fácil |
| El resolvedor abierto | `l11-02-resolvedor-abierto` | Troubleshooting | Media |
| Un DHCP para todas las sedes | `l11-03-dhcp-centralizado` | Montar | Media |
| ¿Qué hora es? | `l11-04-la-hora` | Montar | Fácil |
| Los logs que nadie lee | `l11-05-logs-centralizados` | Montar | Media |
| Lunes negro en la sede | `l11-06-lunes-negro` | Troubleshooting | Difícil |
### MPLS y operadores
| Reto | id | Tipo | Dificultad |
|---|---|---|---|
| Etiquetas en el núcleo | `l12-01-etiquetas` | Montar | Fácil |
| Una VPN para el cliente | `l12-02-vpn-de-cliente` | Montar | Media |
| Dos clientes, las mismas IPs | `l12-03-dos-clientes` | Troubleshooting | Media |
| El cable más largo del mundo | `l12-04-vpls` | Montar | Media |
| El túnel mudo | `l12-05-tunel-mudo` | Troubleshooting | Difícil |
### BGP en Internet
| Reto | id | Tipo | Dificultad |
|---|---|---|---|
| Dos operadores mejor que uno | `l13-01-dos-operadores` | Montar | Media |
| Por la puerta barata | `l13-02-preferencias` | Montar | Media |
| Somos el tránsito de nadie | `l13-03-somos-transito` | Troubleshooting | Difícil |
| Nos atacan | `l13-04-nos-atacan` | Montar | Media |
| Rutas de nadie | `l13-05-rutas-de-nadie` | Troubleshooting | Media |
### Monitorización
| Reto | id | Tipo | Dificultad |
|---|---|---|---|
| SNMP en el router | `l14-01-snmp-en-el-router` | Montar | Fácil |
| SNMP en el servidor | `l14-02-snmp-en-el-servidor` | Montar | Fácil |
| Logs al centro | `l14-03-logs-al-centro` | Montar | Media |
| SNMPv3 | `l14-04-snmpv3` | Montar | Media |
| Monitorización ciega | `l14-05-monitorizacion-ciega` | Troubleshooting | Difícil |
### Sistemas · Linux a fondo
| Reto | id | Tipo | Dificultad |
|---|---|---|---|
| Reconocimiento | `s1-01-reconocimiento` | Captura | Fácil |
| Disco lleno | `s1-02-disco-lleno` | Troubleshooting | Media |
| Red en Linux | `s1-03-red-en-linux` | Troubleshooting | Media |
| Puerto ocupado | `s1-04-puerto-ocupado` | Troubleshooting | Fácil |
| El heredado | `s1-05-el-heredado` | Troubleshooting | Difícil |
### Sistemas · Virtualización
| Reto | id | Tipo | Dificultad |
|---|---|---|---|
| El puerto que no sale | `s3-01-el-puerto-que-no-sale` | Troubleshooting | Fácil |
| Datos que se pierden | `s3-02-datos-que-se-pierden` | Montar | Fácil |
| Sin memoria | `s3-03-sin-memoria` | Troubleshooting | Media |
| No se ven | `s3-04-no-se-ven` | Troubleshooting | Media |
| La mudanza | `s3-05-la-mudanza` | Troubleshooting | Difícil |
### Sistemas · Usuarios y permisos
| Reto | id | Tipo | Dificultad |
|---|---|---|---|
| Altas y bajas | `s4-01-altas-y-bajas` | Montar | Fácil |
| La carpeta del departamento | `s4-02-carpeta-compartida` | Montar | Media |
| sudo a medida | `s4-03-sudo-a-medida` | Montar | Media |
| Permisos rotos | `s4-04-permisos-rotos` | Troubleshooting | Difícil |
| El dominio | `s4-05-el-dominio` | Montar | Media |
### Sistemas · Servicios y procesos
| Reto | id | Tipo | Dificultad |
|---|---|---|---|
| Tu propio servicio | `s5-01-tu-propio-servicio` | Montar | Fácil |
| Recargar sin cortar | `s5-02-recargar-sin-cortar` | Montar | Fácil |
| La CPU por las nubes | `s5-03-cpu-por-las-nubes` | Troubleshooting | Media |
| De cron a timer | `s5-04-de-cron-a-timer` | Montar | Media |
| En bucle | `s5-05-en-bucle` | Troubleshooting | Difícil |
### Sistemas · Scripting y automatización
| Reto | id | Tipo | Dificultad |
|---|---|---|---|
| El script que miente | `s6-01-el-script-que-miente` | Troubleshooting | Fácil |
| A mano funciona | `s6-02-a-mano-funciona` | Troubleshooting | Fácil |
| Las IPs más pesadas | `s6-03-las-ips-mas-pesadas` | Montar | Media |
| Dos servidores, un playbook | `s6-04-ansible` | Montar | Media |
| La copia que nunca se hizo | `s6-05-la-copia-que-nunca-se-hizo` | Troubleshooting | Difícil |
