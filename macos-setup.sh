#!/bin/bash

# ── キーボード ──
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# 自動修正系（既存設定の明示的な確定）
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# 全コントロールにTabフォーカス
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# ── トラックパッド ──
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 3
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true  # タップでクリック

# ── Finder ──
defaults write com.apple.finder AppleShowAllFiles -bool true          # 隠しファイル表示
defaults write NSGlobalDomain AppleShowAllExtensions -bool true       # 拡張子表示
defaults write com.apple.finder ShowPathbar -bool true                # パスバー表示
defaults write com.apple.finder ShowStatusBar -bool true              # ステータスバー表示
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"  # 検索はカレントフォルダ
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true    # タイトルにフルパス

# ── Dock ──
defaults write com.apple.dock autohide -bool true                     # 自動非表示
defaults write com.apple.dock autohide-delay -float 0                 # 表示ディレイなし
defaults write com.apple.dock autohide-time-modifier -float 0.2      # 表示アニメ高速化
defaults write com.apple.dock tilesize -int 48
defaults write com.apple.dock show-recents -bool false                # 最近使ったApp非表示

# ── スクリーンショット ──
defaults write com.apple.screencapture location -string "~/Desktop"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true      # 影なし

# ── その他 ──
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001         # ウィンドウアニメ最速

# 反映
killall Finder
killall Dock
