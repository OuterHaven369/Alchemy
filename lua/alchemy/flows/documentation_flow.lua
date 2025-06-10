local core = require('alchemy.core')
local M = {}

function M.run()
  local mod = core.get_module('documentation_generator')
  if mod and mod.generate_documentation then
    mod.generate_documentation()
  end
end

return M
