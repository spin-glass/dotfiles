# dotfiles

Personal dotfiles: Ghostty, herdr, zsh, tmux, git, Zed, and mise-managed dev tools.

## New machine setup

```sh
# 0. Command Line Tools (provides git)
xcode-select --install

# 1. Homebrew — run the official installer from https://brew.sh then, for the current shell:
eval "$(/opt/homebrew/bin/brew shellenv)"

# 2. Clone and install
git clone https://github.com/spin-glass/dotfiles.git ~/dotfiles
brew bundle --file ~/dotfiles/Brewfile   # mise, starship, direnv, tmux, herdr, Ghostty, Zed
cd ~/dotfiles && ./install.sh            # symlink all configs (backs up existing files)
mise install                             # dev tools from mise/config.toml
exec zsh
```

`install.sh` creates symlinks idempotently. Existing real files are backed up
as `*.bak.<timestamp>` before linking.

## Layout

| Path | Applied to |
|---|---|
| `ghostty/config` | `~/.config/ghostty/config` |
| `herdr/config.toml` | `~/.config/herdr/config.toml` |
| `mise/config.toml` | `~/.config/mise/config.toml` |
| `.zshrc` / `.zprofile` | `~/.zshrc` / `~/.zprofile` |
| `.tmux.conf` / `.gitconfig` | `~/.tmux.conf` / `~/.gitconfig` |
| `zed/settings.json` | `~/.config/zed/settings.json` |

## Policy

- No secrets, tokens, private hostnames, or work-specific information in this repo.
- Secrets are managed separately (sops + age via mise `[env]`) and are never committed here.
