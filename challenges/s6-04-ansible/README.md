# Dos servidores, un playbook

```
 web1 10.0.1.11 ──── ctl ──── web2 10.0.2.12
             (nodo de control de Ansible)
```

Hoy son dos servidores web; el mes que viene, diez. Configurarlos a mano uno a uno ya ha dado
sustos (cada uno acaba un poco distinto). Desde `ctl` vas a describir cómo tienen que estar y que
Ansible lo aplique.

**Objetivo:** un inventario `/root/ansible/hosts` (grupo `web`) y un playbook `/root/ansible/site.yml`
que dejen en los dos:

- el usuario `deploy` con shell bash;
- `/etc/motd` con `Servidor gestionado por Ansible. No tocar a mano.`;
- una portada `/var/www/html/index.html` con `Hola desde <nombre del servidor>` (web1, web2);
- nginx en marcha y habilitado.

Y que sea **idempotente**: la segunda vez, `changed=0`. El check deshace a mano lo de web2 y lanza tu
playbook para ver si lo repone.

**Qué aprendes:**

- Inventarios, playbooks, tareas y módulos de Ansible.
- Idempotencia: describir el estado, no los pasos.
- Variables como `inventory_hostname`.

`lab console ctl` · `lab console web1` · `lab console web2` · `lab check` · `lab hint`
