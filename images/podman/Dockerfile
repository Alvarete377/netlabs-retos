# Servidor Debian con Podman (módulo Virtualización): contenedores dentro del laboratorio.
# Las imágenes que usan los retos vienen precargadas (imagenes.tar, generado por build.sh) y se
# cargan al arrancar con netlabs-imagenes.service: el laboratorio no depende de Internet.
FROM netlabs/debian:0.2
RUN apt-get update && apt-get install -y --no-install-recommends podman podman-docker \
       containernetworking-plugins golang-github-containernetworking-plugin-dnsname fuse-overlayfs uidmap slirp4netns curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/* \
    && touch /etc/containers/nodocker
COPY storage.conf /etc/containers/storage.conf
COPY imagenes.tar /opt/netlabs/imagenes.tar
COPY netlabs-imagenes.service /etc/systemd/system/netlabs-imagenes.service
COPY --chmod=755 netlabs-imagenes /usr/local/sbin/netlabs-imagenes
COPY registries.conf /etc/containers/registries.conf.d/netlabs.conf
RUN systemctl enable netlabs-imagenes.service
