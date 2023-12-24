## Create SSH Keys

```bash
ssh-keygen -t rsa -b 4096 -C "example@example.com"
```
Generate a new SSH key using RSA encryption with a bit size of 4096 and attach an email address as a label.

### Start SSH Agent

```bash
eval $(ssh-agent -s)
```
initialize ssh keys.

### Add Generated Key to SSH Agent

```bash
ssh-add "~/.ssh/ssh_file_name"
```
Add newly generated SSH key to the SSH agent.
