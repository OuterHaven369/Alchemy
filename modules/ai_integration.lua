-- Import the AI integration module
local ai_integration = require("ai_integration")

-- Bind a key to interact with the AI
api.nvim_set_keymap('n', '<leader>i', ':lua require("ai_integration").interact_with_ai(vim.fn.input("Message: "))<CR>', { noremap = true, silent = true })
