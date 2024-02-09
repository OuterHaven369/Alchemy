local M = {}

function M.run_tests()
  local result = vim.fn.system("python -m unittest discover")
  print(result)
end

return M
