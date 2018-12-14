#!/bin/sh

if [ -f "${ANSIBLE_PRIVATE_KEY_FILE}" ]; then
  eval $(gosu ansible ssh-agent)
  gosu ansible ssh-add "${ANSIBLE_PRIVATE_KEY_FILE}"
fi

ANSIBLE_COMMANDS=$(find /usr/bin/ -name 'ansible*' -exec basename {} \;)
for ansible_command in $ANSIBLE_COMMANDS; do
  if [ "$1" == "${ansible_command}" ]; then
    source /home/ansible/venv/bin/activate
    exec gosu ansible "$@"
  fi
done

exec "$@"
