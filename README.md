# Linux Hardening Baseline (Ubuntu 24.04 LTS)

**Language versions:** [Deutsch](README_DE.md)

Idempotent Ansible baseline plus a Lynis before/after measurement. Derived from hardening work on my own hosting platform ([isol.cz](https://www.isol.cz)); a starting point, not a certified CIS/BSI profile.

## What it does
- **Patching:** `unattended-upgrades` enabled.
- **SSH:** key-only login, no password / keyboard-interactive auth, `MaxAuthTries 3`, no X11/agent forwarding, optional `AllowUsers`. Drop-in file is `00-hardening.conf` so it wins over cloud-init snippets (first value wins in `sshd_config.d`).
- **Firewall:** `ufw` default deny incoming, explicit allow list.
- **fail2ban:** `sshd` jail always; optional `postfix`, `dovecot`, `apache-auth` jails.
- **Kernel/network:** conservative `sysctl` settings (rp_filter, no redirects, syncookies, kptr_restrict).
- **Audit:** `auditd` enabled; `lynis` installed.

## Usage
```bash
ansible-galaxy collection install community.general
cp ansible/inventory.example.ini ansible/inventory.ini     # edit hosts
sudo ./scripts/lynis_before_after.sh before                # on the target, baseline score
ansible-playbook -i ansible/inventory.ini ansible/site.yml --check --diff
ansible-playbook -i ansible/inventory.ini ansible/site.yml
sudo ./scripts/lynis_before_after.sh after
```

## Read before running on a real server
- **Do not lock yourself out.** Confirm key-based login works in a second session before applying. Set `ssh_port` to your *actual* SSH port — on Ubuntu 24.04 the port is controlled by `ssh.socket`, which this playbook does not change.
- Set `fail2ban_enable_mail` / `fail2ban_enable_web` only on hosts that run those services.
- Always run with `--check --diff` first and keep console access to the machine.
