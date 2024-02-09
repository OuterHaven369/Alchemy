local M = {}

function M.commit(message)
  local cmd = string.format("git commit -am %q", message)
  local result = vim.fn.system(cmd)
  print(result)
end

return M
