local core = require('core')
print("Alchemy init.lua loaded", core)

local M = {}

-- Registering modules
local modules = {"ai_integration", "code_analyzer", "code_generator", "documentation_generator", "test_runner", "version_control"}
for _, moduleName in ipairs(modules) do
    local module_path = 'modules.' .. moduleName
    print("Requiring module:", module_path)
    local module = require(module_path)
    core.register_module(moduleName, module)
    print("Registered module:", moduleName)
end
print("Dynamic modules loaded")

function M.setup(opts)
  print("Starting Alchemy setup...")
  
  opts = opts or {}
  -- Configuration code here. Utilize opts for customizable behavior.
  print("Alchemy configured with options:", vim.inspect(opts))

  -- Example: Setup key mappings only if not disabled by opts
  if not opts.disableKeyMappings then
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

    vim.api.nvim_create_user_command('AAnalyzeCode', function(opts)
      print("AAnalyzeCode command invoked with args:", opts.args)
      _G['code_analyzer'].analyze_code(opts.args)
    end, {desc = 'Analyze code for improvements and potential bugs', nargs = "*"})

    vim.api.nvim_create_user_command('AGenerateDocumentation', function(opts)
      print("AGenerateDocumentation command invoked with args:", opts.args)
      _G['documentation_generator'].generate_documentation(opts.args)
    end, {desc = 'Generate documentation for the codebase', nargs = "*"})
    

    vim.api.nvim_set_keymap('n', '<leader>ag', ':AGenerateCode<CR>', {noremap = true, silent = true})
    print("Keymap set: Press '<leader>ag' to generate code or use ':AGenerateCode' command.")

    vim.api.nvim_set_keymap('n', '<leader>af', ':AInvokeFlow<CR>', {noremap = true, silent = true})
    print("Keymap set: Press '<leader>af' to invoke a flow or use ':AInvokeFlow' command.")

    vim.api.nvim_set_keymap('n', '<leader>at', ':ARunTests<CR>', {noremap = true, silent = true})
    print("Keymap set: Press '<leader>at' to run tests or use ':ARunTests' command.")
  end

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

  print("Alchemy setup complete. Use the key mappings or commands to interact with the plugin.")
end

return M
