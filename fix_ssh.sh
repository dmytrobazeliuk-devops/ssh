#!/bin/bash
set -e

# 1. Перезаписати sshd_config робочим вмістом
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

# 2. Фікс прав /root і .ssh
chmod 700 /root
chown root:root /root
mkdir -p /root/.ssh
chmod 700 /root/.ssh
chown root:root /root/.ssh

# 3. Згенерувати рандомний ed25519-ключ
RAND=$(tr -dc 'a-z0-9' </dev/urandom | head -c 8)
KEYNAME="id_ed25519_${RAND}"
KEYPATH="/root/.ssh/${KEYNAME}"
ssh-keygen -q -t ed25519 -f "$KEYPATH" -N "" -C "root_autogen_key_$RAND"

# 4. Додати публічний ключ у authorized_keys
cat "${KEYPATH}.pub" >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

# 5. Перезапустити sshd
systemctl restart ssh

echo "===================================="
echo "✅ /etc/ssh/sshd_config оновлено та застосовано!"
echo "===================================="
echo "🟢 SSH ключ успішно створено!"
echo "⚡ Скопіюй цей приватний ключ (збережи у файл, наприклад, $KEYNAME):"
echo "===================================="
cat "$KEYPATH"
echo "===================================="
echo "🔑 Підключення:"
echo "ssh -i $KEYNAME root@your-server-ip"
echo "===================================="
