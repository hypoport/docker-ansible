A simple containerized Ansible environment.

There are several mountpoints allowing you to customize the container:

- `/ansible` - The working directory for Ansible. Mount your Playbooks, Roles, etc. here
- `/ansible-support/ssh_key` - The key file used for SSH connections
- `/ansible-support/vault_key` - Got a vault key? Mount it here

To enable the vault key you need to add the following parameter to the
`docker run` command:

```
-e ANSIBLE_VAULT_PASSWORD_FILE=/ansible-support/vault_key
```
