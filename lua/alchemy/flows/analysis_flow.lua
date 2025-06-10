local core = require('alchemy.core')
local M = {}

function M.run()
  local mod = core.get_module('code_analyzer')
  if mod and mod.analyze_code then
    mod.analyze_code()
  end
end

return M
