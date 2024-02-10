-- Correctly requiring the core module
local core = require('alchemy.core')
print("Alchemy init.lua loaded", core)

local M = {}

function M.setup()
  -- Dynamically require flows
  local flows = {
    "validation_flow",
    "feedback_loop_flow",
    -- Add the names of other flows here
  }

  -- Dynamically loading flows
  for _, flow in ipairs(flows) do
    local flow_module_path = 'plugins.Haven.lua.devos.flows.' .. flow
    core.register_flow(flow, require(flow_module_path))
  end

  -- Dynamically require modules
  local modules = {
    "code_generator",
    "version_control",
    "test_runner",
    -- Add the names of other modules here
  }

  -- Dynamically loading modules
  for _, module in ipairs(modules) do
    local module_path = 'plugins.DevOS.lua.devos.modules.' .. module
    _G[module] = require(module_path)
  end

  -- Setup commands
  vim.api.nvim_create_user_command('GenerateCode', function(opts)
    _G['code_generator'].generate(opts.args)
  end, {desc = 'Generate code using GPT-4', nargs = "*"})

  vim.api.nvim_create_user_command('InvokeFlow', function(opts)
    core.invoke_flow(opts.args)
  end, {desc = 'Invoke a DevOS flow', nargs = "*"})

  vim.api.nvim_create_user_command('RunTests', function(opts)
    _G['test_runner'].run(opts.args)
  end, {desc = 'Run tests', nargs = "*"})

  vim.api.nvim_create_user_command('VersionControl', function(opts)
    _G['version_control'].run(opts.args)
  end, {desc = 'Run version control commands', nargs = "*"})

  -- Setup keymaps
  vim.api.nvim_set_keymap('n', '<leader>g', ':GenerateCode<CR>', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('n', '<leader>f', ':InvokeFlow<CR>', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('n', '<leader>t', ':RunTests<CR>', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('n', '<leader>v', ':VersionControl<CR>', {noremap = true, silent = true})
end

return M
