#!/bin/bash
set -e

# 1. Скачати твій ssh-конфіг з GitHub і виконати
curl -fsSL "https://raw.githubusercontent.com/dmytrobazeliuk-devops/ssh/refs/heads/main/fix_ssh.sh" -o /tmp/fix_ssh.sh
chmod +x /tmp/fix_ssh.sh
sudo /tmp/fix_ssh.sh

# 2. Підготовка директорії та прав
mkdir -p /root/.ssh
chmod 700 /root/.ssh
chown root:root /root/.ssh

# 3. Згенерувати унікальний ED25519 ключ
RAND=$(tr -dc 'a-z0-9' </dev/urandom | head -c 8)
KEYNAME="id_ed25519_${RAND}"
KEYPATH="/root/.ssh/${KEYNAME}"

ssh-keygen -q -t ed25519 -f "$KEYPATH" -N "" -C "root_autogen_key_$RAND"

# 4. Додати публічний ключ у authorized_keys
cat "${KEYPATH}.pub" >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

# 5. Вивести приватний ключ для копіпасту
echo "===================================="
echo "🟢 SSH ключ успішно створено!"
echo "⚡ Скопіюй цей приватний ключ (збережи у файл, наприклад, $KEYNAME):"
echo "===================================="
cat "$KEYPATH"
echo "===================================="
echo "🔑 Підключення:"
echo "ssh -i $KEYNAME root@your-server-ip"
echo "===================================="

# 6. Опціонально: видалити скрипт після виконання
# rm -f /tmp/fix_ssh.sh
