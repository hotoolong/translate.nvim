local lang = require('translate.lang')

local DEFAULT_ENDPOINT =
  'https://script.google.com/macros/s/AKfycbzkDzp_dcafykiegGEDpRPDBrsqcgr-tBu-ypahrSqggU8Rsk6G/exec'

local M = {}

function M.build_payload(text)
  if lang.is_english(text) then
    return { source = 'en', target = 'ja', text = text }
  end
  return { source = 'ja', target = 'en', text = text }
end

function M.run(payload, on_result)
  local endpoint = vim.g.translate_endpoint or DEFAULT_ENDPOINT
  local command = { 'curl', '-d', vim.json.encode(payload), '-sL', endpoint }

  vim.system(command, { text = true }, function(obj)
    if obj.code ~= 0 then
      on_result(nil, 'curl exited with status ' .. obj.code)
      return
    end

    local ok, decoded = pcall(vim.json.decode, obj.stdout)
    if not ok or type(decoded) ~= 'table' or decoded.result == nil then
      on_result(nil, 'no translate result')
      return
    end

    on_result(decoded.result, nil)
  end)
end

return M
