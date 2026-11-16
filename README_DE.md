# Linux-Härtungs-Baseline (Ubuntu 24.04 LTS)

**Sprachversionen:** [English](README.md)

Idempotente Ansible-Baseline mit Lynis-Messung vorher/nachher. Abgeleitet aus Härtungsarbeiten auf meiner eigenen Hosting-Plattform ([isol.cz](https://www.isol.cz)); ein Ausgangspunkt, kein zertifiziertes CIS-/BSI-Profil.

## Umfang
- **Patching:** `unattended-upgrades` aktiviert.
- **SSH:** nur Schlüssel-Login, keine Passwort-/Keyboard-Interactive-Authentifizierung, `MaxAuthTries 3`, kein X11-/Agent-Forwarding, optional `AllowUsers`. Die Drop-in-Datei heißt `00-hardening.conf`, damit sie Cloud-Init-Snippets überstimmt (in `sshd_config.d` gilt der erste Wert).
- **Firewall:** `ufw`, eingehend standardmäßig gesperrt, explizite Freigabeliste.
- **fail2ban:** `sshd`-Jail immer; optional `postfix`, `dovecot`, `apache-auth`.
- **Kernel/Netzwerk:** konservative `sysctl`-Einstellungen.
- **Audit:** `auditd` aktiv; `lynis` installiert.

## Verwendung
```bash
ansible-galaxy collection install community.general
cp ansible/inventory.example.ini ansible/inventory.ini
sudo ./scripts/lynis_before_after.sh before
ansible-playbook -i ansible/inventory.ini ansible/site.yml --check --diff
ansible-playbook -i ansible/inventory.ini ansible/site.yml
sudo ./scripts/lynis_before_after.sh after
```

## Vor dem Einsatz auf echten Servern
- **Nicht aussperren.** Schlüssel-Login in einer zweiten Sitzung prüfen. `ssh_port` auf den *tatsächlichen* SSH-Port setzen — unter Ubuntu 24.04 steuert `ssh.socket` den Port; das Playbook ändert das nicht.
- `fail2ban_enable_mail` / `fail2ban_enable_web` nur auf Hosts mit diesen Diensten aktivieren.
- Immer zuerst `--check --diff` und Konsolenzugriff bereithalten.
