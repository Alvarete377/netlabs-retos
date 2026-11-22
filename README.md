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
