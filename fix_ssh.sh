#!/bin/bash
set -e


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


chmod 700 /root
chown root:root /root
mkdir -p /root/.ssh
chmod 700 /root/.ssh
chown root:root /root/.ssh


RAND=$(tr -dc 'a-z0-9' </dev/urandom | head -c 8)
KEYNAME="id_ed25519_${RAND}"
KEYPATH="/root/.ssh/${KEYNAME}"
ssh-keygen -q -t ed25519 -f "$KEYPATH" -N "" -C "root_autogen_key_$RAND"


cat "${KEYPATH}.pub" >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys


systemctl restart ssh


