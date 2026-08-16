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

# Fonts
# HackGen(白源) = Hack + 源柔ゴシック。日本語グリフ内蔵の等幅フォント。
# macOS の優先言語が en-JP だと Chromium 系(VS Code / Chrome)が漢字を中国語字形で
# 表示するため、日本語を持つフォントを明示指定して回避する。半角:全角 = 1:2 で
# CJK 混在でも罫線と表組みが崩れず、Nerd Font 同梱で starship のアイコンも出る
cask "font-hackgen-nerd"
