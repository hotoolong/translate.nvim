local request = require('translate.request')
local window = require('translate.window')

local M = {}

local function notify_error(message)
  vim.notify('[translate.nvim] ' .. message, vim.log.levels.ERROR)
end

function M._get_text(start, end_, args)
  if args == nil or vim.tbl_isempty(args) then
    return table.concat(vim.api.nvim_buf_get_lines(0, start - 1, end_, false), '\n')
  end
  return table.concat(args, '\n')
end

function M.translate(start, end_, args)
  if vim.fn.executable('curl') == 0 then
    notify_error('please install curl')
    return
  end

  local text = M._get_text(start, end_, args)
  if text == '' then
    notify_error('text is empty')
    return
  end

  vim.notify('Translating...')

  request.run(request.build_payload(text), function(result, err)
    vim.schedule(function()
      if err ~= nil then
        notify_error(err)
        return
      end
      window.open(result)
    end)
  end)
end

return M
