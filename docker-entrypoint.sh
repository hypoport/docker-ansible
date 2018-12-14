#!/bin/sh

PRIVATE_KEY_FILE=$(ansible-config dump | grep DEFAULT_PRIVATE_KEY_FILE | cut -d = -f 2 | awk '{$1=$1};1')
if [ -f "${PRIVATE_KEY_FILE}" ]; then
  PRIVATE_KEY_FILE_BASENAME=$(basename ${PRIVATE_KEY_FILE})
  mkdir "/home/ansible/.ssh"
  chmod 0700 "/home/ansible/.ssh"
  cp "${PRIVATE_KEY_FILE}" "/home/ansible/.ssh/${PRIVATE_KEY_FILE_BASENAME}"
  chmod 0600 "/home/ansible/.ssh/${PRIVATE_KEY_FILE_BASENAME}"
  chown -R ansible:ansible "/home/ansible/.ssh"
  export ANSIBLE_PRIVATE_KEY_FILE="/home/ansible/.ssh/${PRIVATE_KEY_FILE_BASENAME}"
  eval $(gosu ansible ssh-agent)
  gosu ansible ssh-add "${ANSIBLE_PRIVATE_KEY_FILE}"
fi

VAULT_PASSWORD_FILE=$(ansible-config dump | grep DEFAULT_VAULT_PASSWORD_FILE | cut -d = -f 2 | awk '{$1=$1};1')
if [ -f "${VAULT_PASSWORD_FILE}" ]; then
  VAULT_PASSWORD_FILE_BASENAME=$(basename ${VAULT_PASSWORD_FILE})
  cp "${VAULT_PASSWORD_FILE}" "/home/ansible/${VAULT_PASSWORD_FILE_BASENAME}"
  chmod 0600 "/home/ansible/${VAULT_PASSWORD_FILE_BASENAME}"
  chown -R ansible:ansible "/home/ansible/${VAULT_PASSWORD_FILE_BASENAME}"
  export ANSIBLE_VAULT_PASSWORD_FILE="/home/ansible/${VAULT_PASSWORD_FILE_BASENAME}"
fi

ANSIBLE_COMMANDS=$(find /usr/bin/ -name 'ansible*' -exec basename {} \;)
for ansible_command in $ANSIBLE_COMMANDS; do
  if [ "$1" == "${ansible_command}" ]; then
    source /home/ansible/venv/bin/activate
    exec gosu ansible "$@"
  fi
done

exec "$@"
