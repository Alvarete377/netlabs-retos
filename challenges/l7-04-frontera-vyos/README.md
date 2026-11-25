# Frontera VyOS

```
   pc1 192.168.1.10          web 192.168.50.10 (DMZ: web en 80, SSH en 22)
        │ eth2 192.168.1.1/24       │ eth3 192.168.50.1/24
        └──────────────── vy1 (VyOS) ┘
                     eth1 │ 100.64.0.2/30   ← IP pública de la empresa
                          │
                     ether2 100.64.0.1/30
                         isp (MikroTik, operador)
                     ether3 │ 198.51.100.1/24
                           srv 198.51.100.10  ← "Internet"
```

La empresa ha cambiado su router de borde por un **VyOS**. Las interfaces y la ruta por defecto ya
están; falta lo que hace que la red funcione hacia fuera:

**Objetivos:**

1. La oficina y la DMZ salen a Internet con la IP pública de vy1 (el operador no sabe nada de
   tus redes `192.168.x.x`, ni debe).
2. La web (`192.168.50.10:80`) se publica en el **80** de la IP pública.
3. El SSH de la web se publica en el **2222** de la IP pública (el 22 público no lleva a ningún sitio).

**Qué aprendes:**

- NAT de origen (masquerade) y de destino (*port forwarding*) en VyOS, y cómo se compara con
  `srcnat`/`dstnat` de RouterOS.
- Traducir también el puerto (`translation port`).
- El modo `configure` / `commit` / `save` de VyOS.

> En este laboratorio no se usa el cortafuegos de VyOS (`set firewall ...`): necesita una función
> del kernel (nftables para bridges) que el kernel de WSL no trae.

`lab console vy1` · `lab console srv` · `lab check` · `lab hint`
