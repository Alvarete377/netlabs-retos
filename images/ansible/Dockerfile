# Nodo de control de Ansible (módulo Scripting y automatización), sobre la Debian del laboratorio.
FROM netlabs/debian:0.2
RUN apt-get update && apt-get install -y --no-install-recommends ansible-core openssh-client \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
