# El impostor

```
   pc1 192.168.1.10      pc2 192.168.1.20      pc3 (equipo nuevo)
        │ ether2               │ ether3               │ ether4
        └──────────────── bridge-lan (r1) ────────────┘
                          192.168.1.1/24
                               r1
                        ether5 │ 192.168.20.1/24
                              srv 192.168.20.10
```

r1 hace de switch (`bridge-lan`) y de router de la oficina. Desde que ayer instalaron un equipo nuevo,
**pc1 pierde la conexión con el servidor a ratos**: unos pings van, otros no, y nadie ha tocado r1.

**Inventario de IPs** (lo que *debería* tener cada uno): pc1 `192.168.1.10`, pc2 `192.168.1.20`,
pc3 `192.168.1.30`.

**Objetivos:**

- Averigua qué equipo está causando el problema y a qué puerto de r1 está conectado
  (`lab answer`).
- Que cada equipo tenga su IP del inventario y pc1 llegue al servidor **sin cortes**.
- Arréglalo en el origen: sin entradas ARP estáticas en r1 y sin desactivar puertos.

**Qué aprendes:** cómo un conflicto de IP envenena la caché ARP de un router, y a seguir la pista
IP → MAC → puerto del switch, que es como se encuentra un equipo en una red real.

Herramientas útiles: `/ip arp print` (varias veces), `/interface bridge host print`,
`/tool sniffer quick`, y en los PCs `ip -br addr`, `ip -br link`, `tcpdump -eni eth1 arp`.

`lab console r1` · `lab console pc1` · `lab console pc3` · `lab check` · `lab answer` · `lab hint`
