--- Claude Code の直近の回答を editprompt の Neovim から使えるようにするモジュール。
--- scripts/claude-last-response.sh (Stop hook) が保存したファイルを読み、
--- 無名レジスタへのセットと nvim-cmp の補完ソース (claude_response) を提供する。
local M = {}

--- 回答ファイルの保存先ディレクトリ (scripts/claude-last-response.sh と揃える)
local base_dir = vim.env.HOME and vim.fs.joinpath(vim.env.HOME, '.cache', 'claude-responses') or nil

--- 補完候補にする単語の最小文字数
local MIN_WORD_LEN = 3

--- 読み込み結果のキャッシュ (mtime が変わらない限り再パースしない)
local cache = { path = nil, mtime = nil, text = nil, words = nil }

--- editprompt の起動元 pane に対応する回答ファイルのパスを返す。
--- @return string|nil path tmux 外、または editprompt 以外から起動された場合は nil
--- tmux サーバーの起動時刻のキャッシュ (false は取得失敗)
local start_time = nil

--- tmux サーバーの起動時刻 (epoch 秒) を返す。tmux の呼び出しは初回の 1 回だけ行う。
--- @return string|nil
local function get_start_time()
  if start_time == nil then
    local ok, out = pcall(vim.fn.system, { 'tmux', 'display-message', '-p', '#{start_time}' })
    start_time = (ok and vim.v.shell_error == 0 and out:match('^(%d+)%s*$')) or false
  end
  return start_time or nil
end

function M.path()
  local pane = vim.env.EDITPROMPT_TARGET_PANE
  local tmux = vim.env.TMUX
  if not base_dir or not pane or pane == '' or not tmux then
    return nil
  end
  -- $TMUX は "<socket>,<server pid>,<session>" 形式
  local server_pid = tmux:match(',(%d+),')
  local pane_num = pane:match('^%%(%d+)$')
  if not server_pid or not pane_num then
    return nil
  end
  local started = get_start_time()
  if not started then
    return nil
  end
  return vim.fs.joinpath(base_dir, server_pid .. '-' .. started, pane_num .. '.md')
end

--- 回答テキストから補完候補の単語を抜き出す。
--- バッククォートで囲まれた文字列、パスや識別子のような ASCII の並びを対象にする。
--- @param text string 回答テキスト
--- @return string[] words 重複を除いた候補 (出現順)
local function extract_words(text)
  local words, seen = {}, {}
  local function add(w)
    if #w >= MIN_WORD_LEN and not seen[w] and w:find('%a') then
      seen[w] = true
      table.insert(words, w)
    end
  end
  for code in text:gmatch('`([^`\n]+)`') do
    add(code)
  end
  for w in text:gmatch('[%w_%-%./~#]+') do
    -- 文末の句読点やドットなどを落とす
    add((w:gsub('[%.%-#]+$', '')))
  end
  return words
end

--- 回答ファイルを読み込み、キャッシュを更新する。
--- @return boolean ok 読み込めた場合は true
local function load()
  local path = M.path()
  if not path then
    return false
  end
  local stat = vim.uv.fs_stat(path)
  if not stat then
    return false
  end
  local mtime = stat.mtime.sec .. '.' .. stat.mtime.nsec
  if cache.path == path and cache.mtime == mtime then
    return true
  end
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then
    vim.notify('claude-response: failed to read ' .. path, vim.log.levels.WARN)
    return false
  end
  local text = table.concat(lines, '\n')
  cache = { path = path, mtime = mtime, text = text, words = extract_words(text) }
  return true
end

--- 直近の回答を行の配列で返す。
--- @return string[]|nil lines 回答が無い場合は nil
function M.read_lines()
  if not load() then
    return nil
  end
  return vim.split(cache.text, '\n', { plain = true })
end

--- set_register でレジスタに入れた内容 (終了時の消去判定に使う)
local registered = nil

--- 直近の回答を無名レジスタに行単位でセットする。回答が無ければ何もしない。
function M.set_register()
  local lines = M.read_lines()
  if lines then
    vim.fn.setreg('"', lines, 'l')
    registered = lines
  end
end

--- 終了時に、回答がまだ残っているレジスタ (無名・0) を空にする。
--- 回答に機密が含まれていても shada (~/.local/state/nvim/shada) に書き出されないようにするため。
function M.clear_register()
  if not registered then
    return
  end
  for _, reg in ipairs({ '"', '0' }) do
    if vim.deep_equal(vim.fn.getreg(reg, 1, true), registered) then
      vim.fn.setreg(reg, {})
    end
  end
  registered = nil
end

--- nvim-cmp のソース実装
local source = {}

--- @return table source 新しいソースのインスタンス
function source.new()
  return setmetatable({}, { __index = source })
end

--- editprompt のバッファで回答ファイルがあるときだけ有効にする。
--- @return boolean
function source:is_available()
  return vim.bo.filetype == 'editprompt' and M.path() ~= nil
end

--- パスを 1 語として扱うため、キーワードに / . ~ - を含める。
--- @return string pattern
function source:get_keyword_pattern()
  return [[\%([0-9A-Za-z_./~-]\)\+]]
end

--- 補完候補を返す。
--- @param _ table cmp の補完パラメータ (未使用)
--- @param callback fun(result: table)
function source:complete(_, callback)
  if not load() then
    callback({ items = {}, isIncomplete = false })
    return
  end
  local kind = require('cmp').lsp.CompletionItemKind.Text
  local items = {}
  for _, w in ipairs(cache.words) do
    table.insert(items, { label = w, kind = kind })
  end
  callback({ items = items, isIncomplete = false })
end

--- 補完ソースの登録と、editprompt 起動時にレジスタへセットする autocmd を設定する。
function M.setup()
  local ok, cmp = pcall(require, 'cmp')
  if ok then
    cmp.register_source('claude_response', source.new())
  end
  local group = vim.api.nvim_create_augroup('ClaudeResponse', { clear = true })
  vim.api.nvim_create_autocmd('FileType', {
    group = group,
    pattern = 'editprompt',
    callback = M.set_register,
  })
  -- shada は VimLeave より前に書き出されるため、VimLeavePre で消す
  vim.api.nvim_create_autocmd('VimLeavePre', {
    group = group,
    callback = M.clear_register,
  })
end

return M
