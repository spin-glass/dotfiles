#!/bin/bash
# 冪等に symlink を張る。既存の実ファイルは .bak.<日時> へ退避
set -u
REPO="$(cd "$(dirname "$0")" && pwd)"
TS="$(date +%Y%m%d_%H%M%S)"

link() {
  src="$REPO/$1"; dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -e "$dst" ]; then
    mv "$dst" "$dst.bak.$TS"
    echo "退避: $dst → $dst.bak.$TS"
  fi
  ln -s "$src" "$dst"
  echo "リンク: $dst → $src"
}

link ghostty/config    "$HOME/.config/ghostty/config"
link herdr/config.toml "$HOME/.config/herdr/config.toml"
link mise/config.toml  "$HOME/.config/mise/config.toml"
link .zshrc            "$HOME/.zshrc"
link .zprofile         "$HOME/.zprofile"
link .tmux.conf        "$HOME/.tmux.conf"
link .gitconfig        "$HOME/.gitconfig"
link zed/settings.json "$HOME/.config/zed/settings.json"

# tmux plugin manager (TPM) — .tmux.conf が参照
[ -d "$HOME/.tmux/plugins/tpm" ] || git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

echo "完了。herdr 起動中なら反映: herdr server reload-config"
