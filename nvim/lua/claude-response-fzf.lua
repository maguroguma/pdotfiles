--- editprompt のバッファで、Claude Code の直近の回答から fzf で行を選んで挿入するキーマップ (<C-a>c)。
--- 独立した機能なので、不要になったらこのファイルと myconfig.lua の require を消せば外せる。
local M = {}

--- fzf で回答の行を選ばせ、選ばれた行をカーソル位置に挿入する。複数選択 (Tab) にも対応する。
function M.pick()
  local lines = require('claude-response').read_lines()
  if not lines then
    vim.notify('claude-response-fzf: 回答が見つかりません', vim.log.levels.WARN)
    return
  end
  local source = vim.tbl_filter(function(l)
    return l:match('%S') ~= nil
  end, lines)
  local ok, err = pcall(function()
    vim.fn['fzf#run'](vim.fn['fzf#wrap']({
      source = source,
      ['sink*'] = function(selected)
        if #selected > 0 then
          vim.api.nvim_put(selected, 'c', false, true)
        end
      end,
      options = { '--multi', '--prompt', 'insert claude response> ' },
    }))
  end)
  if not ok then
    vim.notify('claude-response-fzf: fzf を起動できません: ' .. tostring(err), vim.log.levels.ERROR)
  end
end

--- editprompt のバッファに挿入モードのキーマップを設定する。
function M.setup()
  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('ClaudeResponseFzf', { clear = true }),
    pattern = 'editprompt',
    callback = function(args)
      vim.keymap.set('i', '<C-a>c', M.pick, { buffer = args.buf, desc = 'Insert lines from Claude response' })
    end,
  })
end

return M
