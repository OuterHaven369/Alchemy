local core = require('alchemy.core')
local M = {}

function M.run()
  local mod = core.get_module('version_control')
  if mod and mod.commit then
    local msg = vim.fn.input('Commit message: ')
    mod.commit(msg)
  end
end

return M
