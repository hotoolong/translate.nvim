local M = {}

local ENGLISH_PATTERN = [==[^[[:alnum:][:space:]_.,()"$’'"-<>?!//\\`]\+$]==]

function M.is_english(text)
  return vim.regex(ENGLISH_PATTERN):match_str(text) == 0
end

return M
