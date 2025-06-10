local M = {}
local log = require('alchemy.log')

function M.commit(message)
  log.debug("Committing with message:", message)
  local cmd = string.format("git commit -am %q", message)
  local result = vim.fn.system(cmd)
  log.debug("Commit result:", result)
end

return M
