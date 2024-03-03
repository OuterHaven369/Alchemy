local M = {}

function M.commit(message)
  print("Committing with message:", message)
  local cmd = string.format("git commit -am %q", message)
  local result = vim.fn.system(cmd)
  print("Commit result:", result)
end

return M
