# NetLabs

Retos de redes y firewalls con routers MikroTik reales, para practicar en tu PC al estilo DockerLabs:
levantas una topología con un comando, la resuelves y `lab check` te dice si está bien.

Web, guía de instalación paso a paso, ranking y writeups: **https://net-labs.vercel.app**

## Instalación (Windows + WSL2)
1. En PowerShell: `wsl --install -d Ubuntu-24.04`
2. En `%UserProfile%\.wslconfig`: `[wsl2]` + `nestedVirtualization=true`, y luego `wsl --shutdown`
3. Dentro de Ubuntu:

       git clone https://github.com/Alvarete377/netlabs-retos.git NetLabs
       cd NetLabs
       sudo NETLABS_USER=$USER bash runner/install.sh

   Si pide reiniciar por systemd: `wsl --shutdown` y repite el último comando.

Para tener los retos nuevos: `git pull` dentro de la carpeta.

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
