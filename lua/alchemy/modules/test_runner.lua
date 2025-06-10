local M = {}
local log = require('alchemy.log')

function M.run_tests()
  log.debug("Running tests...")
  local result = vim.fn.system("python -m unittest discover")
  log.debug("Test results:", result)
end

return M
