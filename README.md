# dotfiles

Personal dotfiles. Ghostty and herdr are applied via `install.sh`; shell, tmux,
and Zed configs are also tracked here and will migrate to mise-based management.

## Apply

```sh
git clone https://github.com/spin-glass/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install.sh
```

`install.sh` creates symlinks idempotently. Existing real files are backed up
as `*.bak.<timestamp>` before linking.

## Policy

- No secrets, tokens, private hostnames, or work-specific information in this repo.
- Secrets are managed separately (sops + age via mise `[env]`) and are never committed here.
