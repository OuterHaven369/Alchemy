local core = require('core')
print("Alchemy init.lua loaded", core)

local M = {}

function M.setup()
  -- Dynamically requiring flows
  local flows = {"validation_flow", "feedback_loop_flow"}
  for _, flow in ipairs(flows) do
    local flow_module_path = 'flows.' .. flow
    local flow_module = require(flow_module_path)
    core.register_flow(flow, flow_module)
  end

  -- Dynamically requiring modules, making them accessible to flows
  local modules = {"code_generator", "version_control", "test_runner"}
  for _, moduleName in ipairs(modules) do
    local module_path = 'modules.' .. moduleName
    local module = require(module_path)
    core.register_module(moduleName, module)
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
