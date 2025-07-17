#!/bin/bash
set -e

# Перезаписати sshd_config повністю робочим вмістом
cat > /etc/ssh/sshd_config <<EOF
Port 22
Protocol 2
PermitRootLogin yes
PubkeyAuthentication yes
PasswordAuthentication no
AuthorizedKeysFile .ssh/authorized_keys
PermitEmptyPasswords no
PermitUserEnvironment no
PermitTunnel no
PermitTTY yes
AllowTcpForwarding yes
X11Forwarding no
PrintMotd no
UsePAM no
Subsystem sftp /usr/lib/openssh/sftp-server
EOF

# Перезапустити sshd для застосування налаштувань
systemctl restart ssh

echo "===================================="
echo "✅ /etc/ssh/sshd_config оновлено та застосовано!"
echo "===================================="
