local core = require('alchemy.core')
print("Alchemy init.lua loaded", core)

local M = {}

function M.setup()
  -- Corrected path for dynamically requiring flows
  local flows = {"validation_flow", "feedback_loop_flow"}
  for _, flow in ipairs(flows) do
    local flow_module_path = 'alchemy.flows.' .. flow
    core.register_flow(flow, require(flow_module_path))
  end

  -- Corrected path for dynamically requiring modules
  local modules = {"code_generator", "version_control", "test_runner"}
  for _, module in ipairs(modules) do
    local module_path = 'alchemy.modules.' .. module
    _G[module] = require(module_path)
  end

  -- Updated key mappings with `<leader>a` prefix
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
