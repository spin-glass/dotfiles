
# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"

# Ghostty shell integration
if [[ -n "$GHOSTTY_RESOURCES_DIR" ]]; then
  source "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"
fi



# Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =============================================================================
# Oh My Zsh
# =============================================================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
DISABLE_AUTO_TITLE="true"
plugins=(
  git
  z
  docker
  brew
)

source $ZSH/oh-my-zsh.sh

# =============================================================================
# Tools
# =============================================================================
eval "$(/opt/homebrew/bin/mise activate zsh)"
export PATH="/Applications/quarto/bin:$PATH"
export EDITOR="zed -n --wait"

# =============================================================================
# Terminal tab title - worktree対応
# =============================================================================
DISABLE_AUTO_TITLE="true"

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
# Powerlevel10k config
# =============================================================================
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export LINEAR_API_KEY="***REMOVED***"


# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"
