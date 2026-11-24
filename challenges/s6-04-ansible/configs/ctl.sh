mkdir -p /root/.ssh /root/ansible
cat > /root/.ssh/id_ed25519 <<'KEY'
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtz
c2gtZWQyNTUxOQAAACD4tzzxxoBYy6DQpmf2VSSw08o5Amacfdiph8RzCUYKzgAA
AIhl2AXuZdgF7gAAAAtzc2gtZWQyNTUxOQAAACD4tzzxxoBYy6DQpmf2VSSw08o5
Amacfdiph8RzCUYKzgAAAECysXynoDqESz1zVhXWI3YZmpeX+wzgP7omq+wzsQ8o
//i3PPHGgFjLoNCmZ/ZVJLDTyjkCZpx92KmHxHMJRgrOAAAAAAECAwQF
-----END OPENSSH PRIVATE KEY-----
KEY
echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPi3PPHGgFjLoNCmZ/ZVJLDTyjkCZpx92KmHxHMJRgrO' > /root/.ssh/id_ed25519.pub
chmod 600 /root/.ssh/id_ed25519
cat > /root/ansible/ansible.cfg <<'EOF'
[defaults]
remote_user = root
host_key_checking = False
interpreter_python = /usr/bin/python3
EOF
