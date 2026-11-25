# Las nóminas están en claro en /root. vdb es un disco nuevo y vacío para guardarlas cifradas.
cat > /root/nominas.csv <<'EOF'
empleado;bruto_anual
Ana Ruiz;31200
Luis Pardo;28750
Marta Gil;35400
EOF
chmod 600 /root/nominas.csv
