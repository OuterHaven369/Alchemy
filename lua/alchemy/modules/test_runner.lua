local M = {}

function M.run_tests()
  print("Running tests...")
  local result = vim.fn.system("python -m unittest discover")
  print("Test results:", result)
end

return M
