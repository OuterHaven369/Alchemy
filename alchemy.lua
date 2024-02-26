local core = require('core')
print("Alchemy init.lua loaded", core)

local M = {}

function M.setup()
  print("Starting Alchemy setup...")

  -- Dynamically requiring flows
  local flows = {"validation_flow", "feedback_loop_flow"}
  for _, flow in ipairs(flows) do
    local flow_module_path = 'flows.' .. flow
    print("Requiring flow:", flow_module_path)
    local flow_module = require(flow_module_path)
    core.register_flow(flow, flow_module)
    print("Registered flow:", flow)
  end
  print("Dynamic flows loaded")

  -- Dynamically requiring modules, making them accessible to flows
  local modules = {"code_generator", "version_control", "test_runner"}
  for _, moduleName in ipairs(modules) do
    local module_path = 'modules.' .. moduleName
    print("Requiring module:", module_path)
    local module = require(module_path)
    core.register_module(moduleName, module)
    print("Registered module:", moduleName)
  end
  print("Dynamic modules loaded")

  -- Key mappings and commands
  vim.api.nvim_create_user_command('AGenerateCode', function(opts)
    print("AGenerateCode command invoked with args:", opts.args)
    _G['code_generator'].generate(opts.args)
  end, {desc = 'Generate code using AI', nargs = "*"})
  
  vim.api.nvim_create_user_command('AInvokeFlow', function(opts)
    print("AInvokeFlow command invoked with args:", opts.args)
    core.invoke_flow(opts.args)
  end, {desc = 'Invoke an Alchemy flow', nargs = "*"})
  
  vim.api.nvim_create_user_command('ARunTests', function(opts)
    print("ARunTests command invoked with args:", opts.args)
    _G['test_runner'].run(opts.args)
  end, {desc = 'Run tests', nargs = "*"})

  vim.api.nvim_set_keymap('n', '<leader>ag', ':AGenerateCode<CR>', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('n', '<leader>af', ':AInvokeFlow<CR>', {noremap = true, silent = true})
  vim.api.nvim_set_keymap('n', '<leader>at', ':ARunTests<CR>', {noremap = true, silent = true})

  print("Alchemy setup complete.")
end

return M
