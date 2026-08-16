# dotfiles

Personal dotfiles: Ghostty, herdr, zsh, tmux, git, Zed, Orca, Spec Kit, and mise-managed dev tools.

## New machine setup

```sh
# 0. Command Line Tools (provides git)
xcode-select --install

# 1. Homebrew — run the official installer from https://brew.sh then, for the current shell:
eval "$(/opt/homebrew/bin/brew shellenv)"

# 2. Clone and install
git clone https://github.com/spin-glass/dotfiles.git ~/dotfiles
brew bundle --file ~/dotfiles/Brewfile   # mise, starship, direnv, tmux, Ghostty, Zed, Obsidian, Orca

# 3. Bootstrap mise config, then let mise do the rest
mkdir -p ~/.config/mise && ln -sf ~/dotfiles/mise/config.toml ~/.config/mise/config.toml
mise trust ~/dotfiles/mise/config.toml
mise run setup                           # symlink all configs (backs up existing), TPM
mise install                             # dev tools incl. herdr from mise/config.toml
exec zsh
```

`mise run setup` creates symlinks idempotently. Existing real files are backed
up as `*.bak.<timestamp>` before linking. It also installs herdr plugins
(reviewr, pluck) when `herdr` is on PATH — rerun it once after `mise install`
on a fresh machine.

Orca ships from the non-official `stablyai/orca` tap, so the Brewfile grants
Homebrew tap trust for that one cask (not the whole tap). `brew bundle` applies
it — no separate `brew trust` step.

## Spec Kit

`specify` (GitHub Spec Kit) は mise 管理なので `mise install` で入る。利用は
プロジェクト単位で初期化が要る:

```sh
cd <project>
specify init --here --integration claude   # .specify/ と .claude/skills/speckit-* を配置
```

`--ai` は旧版のフラグ。0.16 系では `--integration` に変わっている。

この dotfiles 自身は初期化していない（設定リポジトリで spec 駆動する必要がないため）。

## Layout

| Path | Applied to |
|---|---|
| `ghostty/config` | `~/.config/ghostty/config` |
| `herdr/config.toml` | `~/.config/herdr/config.toml` |
| `mise/config.toml` | `~/.config/mise/config.toml` |
| `.zshrc` / `.zprofile` | `~/.zshrc` / `~/.zprofile` |
| `.tmux.conf` / `.gitconfig` | `~/.tmux.conf` / `~/.gitconfig` |
| `zed/settings.json` | `~/.config/zed/settings.json` |
| `claude/statusline-ccusage.sh` | `~/.claude/statusline-ccusage.sh` |
| `claude/ccusage.json` | `~/.claude/ccusage.json` |

`~/.claude/settings.json` is not symlinked (Claude Code rewrites it); `mise run setup`
merges the `statusLine` key into it only when absent.

## Policy

- No secrets, tokens, private hostnames, or work-specific information in this repo.
- Secrets are managed separately (sops + age via mise `[env]`) and are never committed here.
