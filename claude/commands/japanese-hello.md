---
description: "日本語であいさつする（カスタムスラッシュコマンドのサンプル）"
---

# 日本語であいさつする

私は日本人ですので、日本語であいさつしてみてくれますか？
時間帯に応じて、以下のいずれかで返してください。

- おはようございます、$ARGUMENTS
- こんにちは、$ARGUMENTS
- こんばんは、$ARGUMENTS

**※このあとの記述は、カスタムスラッシュコマンドの定義の仕方を示すだけなので、本サンプルコマンド実行時は考慮しないでください。**

## コンテキストを含める

This is a Rust project using:

- Rust 2021 edition
- Clippy with pedantic lints enabled
- cargo-nextest for parallel test execution
- Conventional commits
- workspace with multiple crates

Keep these constraints in mind when executing commands.

## 明確で具体的な手順を記述する

1. Run `cargo test` and ensure all tests pass
2. Run `cargo clippy -- -D warnings` and fix any lints
3. Run `cargo fmt --check` for formatting validation
4. Run `cargo check` for compilation errors
5. If all pass, commit with conventional commit format

## エラーハンドリング方法を指定・例示する

If any step fails:

- Stop execution immediately
- Show the full error message with cargo's verbose output
- For test failures, show the specific test name and assertion
- For clippy warnings, provide the lint name and suggested fix
- Do NOT proceed to the next step

## 出力フォーマットを指定する

After completion, provide a summary in this format:

- Tests: ✅ Passed (42/42)
- Clippy: ✅ No warnings
- Format: ✅ Properly formatted
- Build: ✅ Clean compilation
- Commit: abc123 - feat: add new parser module

