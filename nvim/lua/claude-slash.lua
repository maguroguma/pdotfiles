--- editprompt の Neovim で、語の先頭の `/` から Claude Code の skill・カスタムコマンド・組み込みコマンドを補完する
--- nvim-cmp のソース (claude_slash) を提供するモジュール。
--- 候補はユーザー・プロジェクト・プラグイン・同期済み skill のファイルと、組み込みコマンドの固定リストから作る。
local M = {}

local home = vim.env.HOME and vim.fs.normalize(vim.env.HOME) or nil
--- Claude Code のユーザー設定ディレクトリ
local claude_dir = home and vim.fs.joinpath(home, '.claude') or nil

--- frontmatter を探すときに読む最大行数 (本文全体を読まないための上限)
local MAX_HEAD_LINES = 40
--- 丸ごと読み込む JSON ファイルの最大バイト数 (巨大なファイルや信用できないリポジトリ対策)
local MAX_JSON_BYTES = 1024 * 1024

--- 通常のファイル (リンクならリンク先) かを返す。FIFO やデバイスを読んで固まらないための確認。
--- @param path string
--- @return table|nil stat 通常のファイルなら fs_stat の結果、そうでなければ nil
local function regular_file_stat(path)
  local stat = vim.uv.fs_stat(path)
  return (stat and stat.type == 'file') and stat or nil
end

--- 組み込みコマンドと同梱 skill の一覧。Claude Code の更新で増減したら手で直す。
--- @type {name: string, desc: string}[]
local BUILTINS = {
  { name = 'add-dir', desc = '作業ディレクトリを追加する' },
  { name = 'agents', desc = 'サブエージェントを管理する' },
  { name = 'clear', desc = '会話履歴を消して新しく始める' },
  { name = 'compact', desc = '会話を要約してコンテキストを減らす' },
  { name = 'config', desc = '設定画面を開く' },
  { name = 'context', desc = 'コンテキストの使用量を表示する' },
  { name = 'cost', desc = 'トークン使用量とコストを表示する' },
  { name = 'doctor', desc = 'インストール状態を診断する' },
  { name = 'exit', desc = 'Claude Code を終了する' },
  { name = 'export', desc = '会話をファイルやクリップボードに書き出す' },
  { name = 'fast', desc = 'fast mode を切り替える' },
  { name = 'help', desc = 'ヘルプを表示する' },
  { name = 'hooks', desc = 'hook の設定を管理する' },
  { name = 'ide', desc = 'IDE 連携を管理する' },
  { name = 'init', desc = 'CLAUDE.md を作成する' },
  { name = 'login', desc = 'ログインする' },
  { name = 'logout', desc = 'ログアウトする' },
  { name = 'mcp', desc = 'MCP サーバーを管理する' },
  { name = 'memory', desc = 'メモリファイルを編集する' },
  { name = 'model', desc = 'モデルを切り替える' },
  { name = 'output-style', desc = '出力スタイルを切り替える' },
  { name = 'permissions', desc = '権限ルールを管理する' },
  { name = 'plugin', desc = 'プラグインを管理する' },
  { name = 'release-notes', desc = 'リリースノートを表示する' },
  { name = 'resume', desc = '過去の会話を再開する' },
  { name = 'rewind', desc = '会話とコードを以前の状態に戻す' },
  { name = 'status', desc = 'バージョンや接続状態を表示する' },
  { name = 'statusline', desc = 'ステータスラインを設定する' },
  { name = 'terminal-setup', desc = 'ターミナルのキー設定を行う' },
  { name = 'todos', desc = 'TODO リストを表示する' },
  { name = 'usage', desc = 'プランの使用状況を表示する' },
  { name = 'vim', desc = 'vim モードを切り替える' },
  { name = 'code-review', desc = '差分や PR をレビューする' },
  { name = 'security-review', desc = '変更のセキュリティレビューを行う' },
  { name = 'simplify', desc = '変更したコードを簡潔にする' },
  { name = 'fewer-permission-prompts', desc = '許可プロンプトを減らす allowlist を作る' },
  { name = 'loop', desc = 'プロンプトを一定間隔で繰り返し実行する' },
  { name = 'schedule', desc = 'クラウドの定期実行エージェントを管理する' },
  { name = 'run', desc = 'アプリを起動して動作を確認する' },
}

--- 候補のキャッシュ (editprompt の Neovim は短命なので、起動中は作り直さない)
--- @type table[]|nil
local cache = nil

--- ファイル先頭の YAML frontmatter から 1 行で書かれたキーと値を取り出す。
--- description が無いときは、本文の最初の空でない行 (見出しの # は除く) を代わりに入れる。
--- 呼び出し側で regular_file_stat による確認を済ませておくこと (readfile は行末の CR を自動で除く)。
--- @param path string Markdown ファイルのパス
--- @return table<string, string> meta 読めない場合は空のテーブル
local function read_frontmatter(path)
  local ok, lines = pcall(vim.fn.readfile, path, '', MAX_HEAD_LINES)
  if not ok then
    return {}
  end
  -- body_start: 本文の開始行。frontmatter の閉じ記号が読んだ範囲に無ければ nil (本文の位置が分からない)
  local meta, body_start = {}, 1
  if lines[1] == '---' then
    body_start = nil
    -- block_key: `key: >-` や値の無い `description:` の後に続く、インデントされた行を連結している最中のキー
    -- (値の無い他のキーは入れ子のマップやリストのことが多いので連結しない)
    local block_key = nil
    for i = 2, #lines do
      local line = lines[i]
      if line == '---' then
        body_start = i + 1
        break
      end
      local key, value = line:match('^([%w_-]+):%s*(.-)%s*$')
      if key then
        block_key = nil
        if (value == '' and key == 'description') or value:match('^[>|][+-]?%d?[+-]?$') then
          block_key, meta[key] = key, ''
        else
          meta[key] = (value:gsub('^"(.*)"$', '%1'):gsub("^'(.*)'$", '%1'))
        end
      elseif block_key and line:match('^%s+%S') then
        meta[block_key] = vim.trim(meta[block_key] .. ' ' .. vim.trim(line))
      end
    end
  end
  if body_start and (not meta.description or meta.description == '') then
    for i = body_start, #lines do
      local text = vim.trim((lines[i]:gsub('^#+%s*', '')))
      if text ~= '' then
        meta.description = text
        break
      end
    end
  end
  return meta
end

--- 指定ディレクトリの直下にある <name>/SKILL.md を集める。
--- @param dir string skills ディレクトリ
--- @param prefix string 名前空間 (例: "plugin:")。無ければ空文字
--- @param out table[] 候補の追加先
local function collect_skills(dir, prefix, out)
  if vim.fn.isdirectory(dir) == 0 then
    return
  end
  for name, ftype in vim.fs.dir(dir) do
    local skill_md = vim.fs.joinpath(dir, name, 'SKILL.md')
    if (ftype == 'directory' or ftype == 'link') and regular_file_stat(skill_md) then
      local meta = read_frontmatter(skill_md)
      if meta['user-invocable'] ~= 'false' then
        table.insert(out, { name = prefix .. (meta.name or name), desc = meta.description or '', kind = 'skill' })
      end
    end
  end
end

--- commands ディレクトリ配下の *.md を集める。サブディレクトリは "dir:name" の名前空間になる。
--- @param dir string commands ディレクトリ
--- @param prefix string 名前空間 (例: "plugin:")。無ければ空文字
--- @param out table[] 候補の追加先
local function collect_commands(dir, prefix, out)
  if vim.fn.isdirectory(dir) == 0 then
    return
  end
  for rel, ftype in vim.fs.dir(dir, { depth = 3, follow = true }) do
    local path = vim.fs.joinpath(dir, rel)
    -- symlink の .md も、リンク先が通常のファイルなら候補にする
    -- scandir が 'file' と返したものは通常のファイルなので、stat で確かめるのは symlink のときだけにする
    if rel:match('%.md$') and (ftype == 'file' or (ftype == 'link' and regular_file_stat(path))) then
      local meta = read_frontmatter(path)
      local name = rel:gsub('%.md$', ''):gsub('/', ':')
      table.insert(out, { name = prefix .. name, desc = meta.description or '', kind = 'command' })
    end
  end
end

--- JSON ファイルを読んでテーブルにする。
--- @param path string
--- @return table|nil
local function read_json(path)
  local stat = regular_file_stat(path)
  if not stat or stat.size > MAX_JSON_BYTES then
    return nil
  end
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then
    return nil
  end
  local ok_decode, data = pcall(vim.json.decode, table.concat(lines, '\n'))
  return ok_decode and type(data) == 'table' and data or nil
end

--- editprompt の起動元 pane (Claude Code) のカレントディレクトリを返す。
--- @return string|nil
local function target_cwd()
  local pane = vim.env.EDITPROMPT_TARGET_PANE
  if not pane or pane == '' or not vim.env.TMUX then
    return nil
  end
  local ok, out = pcall(vim.fn.system, { 'tmux', 'display-message', '-p', '-t', pane, '#{pane_current_path}' })
  if not ok or vim.v.shell_error ~= 0 then
    return nil
  end
  local cwd = vim.trim(out)
  if cwd == '' then
    return nil
  end
  -- symlink や末尾の / を揃えて、$HOME との比較がずれないようにする
  return vim.fs.normalize(vim.uv.fs_realpath(cwd) or cwd)
end

--- プロジェクトとして探すディレクトリを、cwd から git のルートまで (git 外なら cwd のみ) 返す。
--- $HOME と / は対象外にする (~/.claude はユーザー設定として別に読み、/tmp などの共有の場所は読まない)。
--- @param cwd string|nil
--- @return string[] dirs 内側から順
local function project_dirs(cwd)
  if not cwd then
    return {}
  end
  local root = vim.fs.root(cwd, '.git')
  local real_home = home and (vim.uv.fs_realpath(home) or home) or nil
  local dirs = {}
  local dir = cwd
  while dir and dir ~= '/' and dir ~= home and dir ~= real_home do
    table.insert(dirs, dir)
    if not root or dir == root then
      break
    end
    local parent = vim.fs.dirname(dir)
    dir = parent ~= dir and parent or nil
  end
  return dirs
end

--- プロジェクトの .claude の skill とコマンドを集める。
--- @param dirs string[] project_dirs の結果
--- @param out table[] 候補の追加先
local function collect_project(dirs, out)
  for _, dir in ipairs(dirs) do
    collect_skills(vim.fs.joinpath(dir, '.claude', 'skills'), '', out)
    collect_commands(vim.fs.joinpath(dir, '.claude', 'commands'), '', out)
  end
end

--- ユーザーと、Claude Code の起動ディレクトリ (cwd) の settings から enabledPlugins を合成する (後ろほど優先)。
--- 中間のディレクトリの settings は Claude Code が読まないため対象にしない。
--- @param cwd string|nil Claude Code の pane のカレントディレクトリ
--- @return table<string, boolean>
local function enabled_plugins(cwd)
  local files = { vim.fs.joinpath(claude_dir, 'settings.json') }
  if cwd then
    table.insert(files, vim.fs.joinpath(cwd, '.claude', 'settings.json'))
    table.insert(files, vim.fs.joinpath(cwd, '.claude', 'settings.local.json'))
  end
  local enabled = {}
  for _, file in ipairs(files) do
    local settings = read_json(file)
    if settings and type(settings.enabledPlugins) == 'table' then
      for id, v in pairs(settings.enabledPlugins) do
        enabled[id] = v == true
      end
    end
  end
  return enabled
end

--- インストール済みで有効なプラグインの skill とコマンドを集める。
--- project スコープのものは、インストール先のプロジェクトで作業しているときだけ対象にする。
--- @param cwd string|nil Claude Code の pane のカレントディレクトリ
--- @param dirs string[] project_dirs の結果
--- @param out table[] 候補の追加先
local function collect_plugins(cwd, dirs, out)
  local installed = read_json(vim.fs.joinpath(claude_dir, 'plugins', 'installed_plugins.json'))
  if not installed or type(installed.plugins) ~= 'table' then
    return
  end
  local enabled = enabled_plugins(cwd)
  local in_project = {}
  for _, dir in ipairs(dirs) do
    in_project[dir] = true
  end
  for id, entries in pairs(installed.plugins) do
    if enabled[id] and type(entries) == 'table' then
      for _, entry in ipairs(entries) do
        -- 壊れた要素が 1 つあっても、ほかのプラグインの収集は続ける
        local valid = type(entry) == 'table' and type(entry.installPath) == 'string'
        local project = valid and type(entry.projectPath) == 'string'
          and vim.fs.normalize(vim.uv.fs_realpath(entry.projectPath) or entry.projectPath)
        if valid and (entry.scope == nil or entry.scope == 'user' or (project and in_project[project])) then
          local prefix = id:gsub('@.*$', '') .. ':'
          collect_skills(vim.fs.joinpath(entry.installPath, 'skills'), prefix, out)
          collect_commands(vim.fs.joinpath(entry.installPath, 'commands'), prefix, out)
          break
        end
      end
    end
  end
end

--- claude.ai から同期された skill (anthropic-skills:*) を集める。
--- @param out table[] 候補の追加先
local function collect_synced(out)
  local dir = vim.fs.joinpath(claude_dir, 'skills', 'synced')
  if vim.fn.isdirectory(dir) == 0 then
    return
  end
  for name, ftype in vim.fs.dir(dir) do
    if (ftype == 'directory' or ftype == 'link') and not name:match('^%.') then
      collect_skills(vim.fs.joinpath(dir, name), 'anthropic-skills:', out)
    end
  end
end

--- 補完候補を集めて返す。同名の候補は先に見つかった方を残す (Claude Code と同じく、ユーザーをプロジェクトより優先する)。
--- @return table[] items { name, desc, kind } の配列
function M.items()
  if cache then
    return cache
  end
  local found = {}
  local function try(fn)
    local ok, err = pcall(fn, found)
    if not ok then
      vim.notify('claude-slash: ' .. tostring(err), vim.log.levels.WARN)
    end
  end
  if claude_dir then
    -- cwd の取得や探索で例外が出ても、プロジェクト以外の候補は返せるようにする
    local ok_dirs, cwd, dirs = pcall(function()
      local c = target_cwd()
      return c, project_dirs(c)
    end)
    if not ok_dirs then
      vim.notify('claude-slash: ' .. tostring(cwd), vim.log.levels.WARN)
      cwd, dirs = nil, {}
    end
    try(function(out) collect_skills(vim.fs.joinpath(claude_dir, 'skills'), '', out) end)
    try(function(out) collect_commands(vim.fs.joinpath(claude_dir, 'commands'), '', out) end)
    try(function(out) collect_project(dirs, out) end)
    try(function(out) collect_plugins(cwd, dirs, out) end)
    try(collect_synced)
  end
  for _, b in ipairs(BUILTINS) do
    table.insert(found, { name = b.name, desc = b.desc, kind = 'builtin' })
  end
  local items, seen = {}, {}
  for _, it in ipairs(found) do
    if not seen[it.name] then
      seen[it.name] = true
      table.insert(items, it)
    end
  end
  cache = items
  return items
end

--- nvim-cmp のソース実装
local source = {}

--- @return table source 新しいソースのインスタンス
function source.new()
  return setmetatable({}, { __index = source })
end

--- editprompt のバッファだけで有効にする。
--- @return boolean
function source:is_available()
  return vim.bo.filetype == 'editprompt'
end

--- @return string[] chars `/` の入力で補完を開始する
function source:get_trigger_characters()
  return { '/' }
end

--- `/` から始まり、名前空間の `:` を含む 1 語をキーワードとして扱う。
--- @return string pattern
function source:get_keyword_pattern()
  return [[/[0-9A-Za-z_:.-]*]]
end

--- 行のどこでも、語の先頭にある `/` に続く入力のときに候補を返す (本文中で skill 名を書くときにも使う)。
--- `foo/bar` や `./x` のようなパスの途中の `/` では出さない。
--- @param params table cmp の補完パラメータ
--- @param callback fun(result: table)
function source:complete(params, callback)
  local before = params.context.cursor_before_line
  local prev, typed = before:match('(.?)/([0-9A-Za-z_:.-]*)$')
  -- 直前の文字は ASCII の範囲で判定する (%w はロケール次第でマルチバイト文字のバイトにも一致するため)
  if prev == nil or prev:match('[A-Za-z0-9_.~/:-]') then
    callback({ items = {}, isIncomplete = false })
    return
  end
  local kinds = require('cmp').lsp.CompletionItemKind
  local kind_map = { builtin = kinds.Keyword, skill = kinds.Function, command = kinds.Module }
  local result = {}
  -- 入力に前方一致 (大文字小文字を区別) する候補だけを返す。一致が無ければ第 2 グループの path が表示される
  for _, it in ipairs(M.items()) do
    if vim.startswith(it.name, typed) then
      table.insert(result, {
      label = '/' .. it.name,
      kind = kind_map[it.kind],
      documentation = { kind = 'markdown', value = string.format('**%s**\n\n%s', it.kind, it.desc) },
      })
    end
  end
  -- 入力のたびに問い合わせ直させ、上の前方一致での絞り込みを反映する (候補はキャッシュ済みなので軽い)
  callback({ items = result, isIncomplete = true })
end

--- 補完ソース (claude_slash) を nvim-cmp に登録する。
function M.setup()
  local ok, cmp = pcall(require, 'cmp')
  if not ok then
    vim.notify('claude-slash: nvim-cmp が見つかりません', vim.log.levels.WARN)
    return
  end
  cmp.register_source('claude_slash', source.new())
end

return M
