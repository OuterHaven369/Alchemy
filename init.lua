local core = require('core')
print("Alchemy init.lua loaded", core)

local M = {}

function M.setup()
  -- Dynamically requiring flows
  local flows = {"validation_flow", "feedback_loop_flow"}
  for _, flow in ipairs(flows) do
    -- Corrected the path to be relative to the plugin's root directory
    local flow_module_path = 'flows.' .. flow
    core.register_flow(flow, require(flow_module_path))
  end

  -- Dynamically requiring modules
  local modules = {"code_generator", "version_control", "test_runner"}
  for _, module in ipairs(modules) do
    -- Again, corrected the path to be relative
    local module_path = 'modules.' .. module
    _G[module] = require(module_path)
  end

  -- Key mappings and commands remain the same
  vim.api.nvim_create_user_command('AGenerateCode', function(opts)
    _G['code_generator'].generate(opts.args)
  end, {desc = 'Generate code using AI', nargs = "*"})
  
  vim.api.nvim_create_user_command('AInvokeFlow', function(opts)
    core.invoke_flow(opts.args)
  end, {desc = 'Invoke an Alchemy flow', nargs = "*"})
  
  vim.api.nvim_create_user_command('ARunTests', function(opts)
    _G['test_runner'].run(opts.args)
  end, {desc = 'Run tests', nargs = "*"})

  vim.api.nvim_set_keymap('n', '<leader>ag', ':AGenerateCode<CR>', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('n', '<leader>af', ':AInvokeFlow<CR>', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('n', '<leader>at', ':ARunTests<CR>', {noremap = true, silent = true})
end

return M
