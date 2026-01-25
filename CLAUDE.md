# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

このリポジトリは、日本語環境での開発作業に最適化されたdotfilesです。主にGo、TypeScript/Node.js、Rust開発環境をサポートし、効率的なターミナル操作とGit管理を重視しています。

## 主要なアーキテクチャ

### 設定管理
- XDG Base Directory Specification準拠
- シンボリックリンクベースの設定ファイル管理
- OS別（macOS/Linux）のセットアップスクリプト

### 開発環境構成
- **エディタ**: Neovim（メイン、GitHub Copilot統合）、VSCode（サブ）
- **シェル**: Zsh + zplug（プラグイン管理）
- **ターミナル**: tmux（prefix: C-t）
- **ファイル管理**: yazi（メイン）、vifm（サブ）
- **Git UI**: lazygit + 豊富なカスタムエイリアス

### 言語・ツールチェーン
- **Go**: golangci-lint、sqlc、swag等のツール群
- **Node.js**: volta管理、TypeScript、AWS CDK
- **Rust**: bat、delta、silicon等のCLIツール
- **その他**: ghq（リポジトリ管理）、fzf（検索）、ripgrep

## 共通操作コマンド

### セットアップ
```bash
# 初期セットアップ（macOS）
_docs/setup_macos.sh

# 共通セットアップ
_docs/setup_common.sh
```

### 開発ユーティリティ
```bash
# GitHub PR比較
scripts/github_compare.sh

# 最近使用したGitブランチ一覧
scripts/mru-branch-list.sh

# 一時作業ディレクトリ作成
scripts/tmpspace.sh

# 日時変換
scripts/date-to-ts.sh
scripts/ts-to-date.sh

# その他のユーティリティ
scripts/github_go.sh          # GitHubリポジトリへの直接移動
scripts/github_search_PR.sh   # GitHub PR検索
scripts/google.sh             # Google検索
scripts/my-ascii.sh           # ASCII アート生成
scripts/cherry-pick-to.sh     # Git cherry-pick支援
```

### tmux操作（prefix: C-t）
- `|`: 縦分割
- `-`: 横分割
- `hjkl`: vim風ペイン移動
- `=`: ペインを均等分割

### zsh操作
- `Ctrl+f`: yaziファイルマネージャー起動（ディレクトリ移動機能付き）
- `clear` または `c`: 画面クリア後に瞑想を促すアスキーアートを表示
- `meditation-off`: 瞑想リマインダーを一時的に無効化（プレゼン時など）
- `meditation-on`: 瞑想リマインダーを再度有効化

### Git操作
```bash
# 主要なカスタムエイリアス（git/config）
git lg          # グラフログ表示
git push-f      # force-with-lease --force-if-includes
git gone        # リモートで削除済みブランチの整理
git today       # 過去12時間のコミット表示
git cancel      # 直前コミットを取り消し（soft reset）
git prev        # HEADを1つ前に戻す
git amend       # 最新コミットを修正
git append      # 最新コミットに変更を追加（メッセージ変更なし）
git save-tag    # ローカル作業用タグ作成
git wip-commit  # WIP用コミット作成
git sec-scan-history # git-secretsでhistory全体をスキャン

# delta統合（差分表示の改善）
git diff        # deltaによる美しい差分表示
git log         # ナビゲーション機能付き（n/N で移動）
```

## 特別な設定

### セキュリティ機能
- **git-secrets**: AWS認証情報の自動検出・防止
- **envchain**: API キーの安全な管理（ChatGPT等）
- **typos-cli**: コード中のタイポ検出

### Neovim
- **設定ファイル**: init.vim（メイン）、lua/myconfig.lua（モダン機能）
- **プラグイン管理**: jetpack
- **AI統合**: GitHub Copilot + CopilotChat
- **スニペット**: UltiSnips（TypeScript、Go、Shell）
- **テーマ**: gruvbox_light
- **プロファイリング**: vim-startuptime連携

### 日本語環境
- AquaSKK（macOS日本語入力）
- PlemolJPフォント（プログラミング用日本語フォント）
- 日本語での操作を前提とした設定

### パッケージ管理・開発ワークフロー
- **Node.js**: asdf管理（`asdf install nodejs latest`）
- **Go**: GOPATH (`~/go/src`) + ghq によるリポジトリ管理
- **Rust**: rustup + cargo
- **リポジトリ管理**: ghq (`ghq get <repo>`) でGitHub等から取得
- **依存関係**: Homebrew（macOS）+ 各言語のツールチェーン

## ディレクトリ構造とXDG準拠

### 特殊ディレクトリ
- `_docs/`: セットアップドキュメント・スクリプト
- `_ai_works/`: AI関連の作業ファイル（Claude設定等）
- `scripts/`: 開発支援ユーティリティスクリプト
- `tmp/`: 一時作業用ディレクトリ

### 設定ディレクトリ（XDG準拠のシンボリックリンク）
- `zsh/` → `~/.config/zsh/`
- `tmux/` → `~/.config/tmux/`
- `nvim/` → `~/.config/nvim/`
- `git/` → `~/.config/git/`
- `yazi/` → `~/.config/yazi/`
- `lazygit/` → `~/.config/lazygit/`

### ホームディレクトリ直下へのリンク
- `.zshenv` → `~/.zshenv`
- `.editorconfig` → `~/.editorconfig`
- `.wezterm.lua` → `~/.wezterm.lua`

## 開発時の注意事項

- git commitは行わない（ユーザーが不慣れなため）
- 日本語でのやりとりを優先
- 既存の設定パターンに従い、破壊的変更は避ける
- シンボリックリンク構造を維持する

## Active Technologies
- Zsh (POSIX準拠シェルスクリプト) + なし（zsh組み込み機能のみ） (001-meditation-ascii)
- `~/.config/meditation/config` (フラグファイル) (001-meditation-ascii)
- Bash (POSIX準拠シェルスクリプト) + なし（シェル組み込み機能のみ） (002-update-meditation-text)

## Recent Changes
- 001-meditation-ascii: Added Zsh (POSIX準拠シェルスクリプト) + なし（zsh組み込み機能のみ）
