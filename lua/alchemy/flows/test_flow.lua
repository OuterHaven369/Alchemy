local core = require('alchemy.core')
local M = {}

function M.run()
  local mod = core.get_module('test_runner')
  if mod and mod.run_tests then
    mod.run_tests()
  end
end

return M
