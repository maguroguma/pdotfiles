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
```

### tmux操作（prefix: C-t）
- `|`: 縦分割
- `-`: 横分割  
- `hjkl`: vim風ペイン移動
- `Ctrl+f`: yaziファイルマネージャー起動

### Git操作
```bash
# カスタムエイリアス（git/config）
git lg      # グラフログ表示
git push-f  # force-with-lease
git gone    # 削除済みブランチ整理
git df      # delta差分表示
```

## 特別な設定

### Neovim
- jetpackプラグイン管理
- GitHub Copilot + CopilotChat統合
- TypeScript、Go、Shell用スニペット
- プロファイリング機能（カスタムProfile）

### 日本語環境
- AquaSKK（macOS日本語入力）
- PlemolJPフォント（プログラミング用日本語フォント）
- 日本語での操作を前提とした設定

## ディレクトリ構造の意味

- `_docs/`: セットアップドキュメント・スクリプト
- `_ai_works/`: AI関連の作業ファイル
- `scripts/`: 開発支援ユーティリティスクリプト
- 各設定ディレクトリ: 対応するツールの設定ファイル

## 開発時の注意事項

- git commitは行わない（ユーザーが不慣れなため）
- 日本語でのやりとりを優先
- 既存の設定パターンに従い、破壊的変更は避ける
- シンボリックリンク構造を維持する
