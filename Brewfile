# CLI tools (configs in this repo assume these)
# herdr is mise-managed — see mise/config.toml [tools]
brew "mise"
brew "starship"
brew "direnv"
brew "tmux"

# Apps
cask "ghostty"
cask "zed"
cask "obsidian"

# Orca (ADE) — 素の `orca` cask は無関係な plotly ツール(deprecated)なので tap 修飾必須。
# 非公式 tap は Homebrew 6.0 の tap trust で明示信頼が要る。将来追加される cask まで
# 巻き込まないよう、tap 全体(trusted: true)ではなく orca cask だけを信頼する
tap "stablyai/orca", trusted: { cask: "orca" }
cask "stablyai/orca/orca"
