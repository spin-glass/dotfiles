
# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"



# Ghostty shell integration
if [[ -n "$GHOSTTY_RESOURCES_DIR" ]]; then
  source "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"
fi



# =============================================================================
# Tools
# =============================================================================
eval "$(/opt/homebrew/bin/mise activate zsh)"
export PATH="/Applications/quarto/bin:$PATH"
export EDITOR="zed -n --wait"

# Haskell (ghcup)
[ -f "$HOME/.ghcup/env" ] && . "$HOME/.ghcup/env"

# =============================================================================
# Terminal tab title - worktree対応
# =============================================================================
_set_tab_title() {
  local title
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    local root branch
    root=$(git rev-parse --show-toplevel 2>/dev/null)
    branch=$(git branch --show-current 2>/dev/null)
    title="${root:t}"
    [[ -n "$branch" ]] && title="${title} (${branch})"
  else
    title="${PWD:t}"
  fi
  print -n "\e]2;${title}\a"
}

autoload -U add-zsh-hook
add-zsh-hook precmd _set_tab_title
add-zsh-hook chpwd _set_tab_title

# =============================================================================
# Prompt
# =============================================================================
eval "$(starship init zsh)"
eval "$(direnv hook zsh)"


# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"
