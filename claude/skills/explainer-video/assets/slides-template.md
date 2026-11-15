---
marp: true
theme: default
paginate: true
size: 16:9
style: |
  section { font-family: "PlemolJP", "Hiragino Sans", "Noto Sans CJK JP", sans-serif; font-size: 28px; background: #fbf1c7; color: #3c3836; padding: 50px 70px; }
  h1 { color: #af3a03; font-size: 46px; }
  h2 { color: #076678; font-size: 38px; border-bottom: 3px solid #d65d0e; padding-bottom: 6px; }
  code { background: #ebdbb2; color: #9d0006; }
  pre { background: #282828; color: #ebdbb2; font-size: 21px; line-height: 1.35; border-radius: 8px; }
  pre code { background: transparent; color: #ebdbb2; }
  pre .hljs-string, pre .hljs-regexp { color: #b8bb26; }
  pre .hljs-keyword, pre .hljs-built_in { color: #fb4934; }
  pre .hljs-comment { color: #a89984; }
  pre .hljs-title, pre .hljs-function { color: #fabd2f; }
  pre .hljs-number, pre .hljs-literal { color: #d3869b; }
  pre .hljs-variable, pre .hljs-attr, pre .hljs-property { color: #83a598; }
  table { font-size: 22px; }
  strong { color: #9d0006; }
---

<!-- この雛形を作業ディレクトリの slides.md にコピーして書き換える。スライドは --- で区切る。 -->

# タイトル（何の解説か）

## サブタイトル（この動画で得られるメンタルモデル）

- 要点 1
- 要点 2
- 要点 3

---

## 全体像: 図は ASCII 文字だけで描く

```text
+--------------+   event    +----------------+
| Producer     | ---------> | Consumer       |
+--------------+            +----------------+
        |                           ^
        v  write                    |  read
   ~/.cache/some/file.md -----------+
```

**このスライドで一番伝えたいことを 1 行で**

---

## コードを見せるスライド

```lua
-- 12 行程度までに収める。長いコードは要所だけ抜き出す
local function example()
  return 'ok'
end
```

- 箇条書きは 3〜5 個まで

---

<!-- 最後のスライドには必ずクレジット欄を残す (build.sh が音声エンジン名に置き換える) -->
<!-- _footer: 音声: {{VOICE_CREDIT}} -->

## まとめ

| 役割 | 対象 | 一言で |
|---|---|---|
| A | `path/to/a` | ... |
| B | `path/to/b` | ... |

**全体を一言で言うと**
