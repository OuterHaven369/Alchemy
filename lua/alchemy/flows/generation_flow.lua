local core = require('alchemy.core')
local M = {}

function M.run()
  local mod = core.get_module('code_generator')
  if mod and mod.generate then
    local prompt = vim.fn.input('Gen prompt: ')
    mod.generate(prompt)
  end
end

return M
