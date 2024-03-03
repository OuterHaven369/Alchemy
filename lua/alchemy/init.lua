local core = require('alchemy.core') -- Ensure this matches the path to your core module
print("Alchemy init.lua loaded", core)

local M = {}

-- Registering modules
local modules = {"ai_integration", "code_analyzer", "code_generator", "documentation_generator", "test_runner", "version_control"}
for _, moduleName in ipairs(modules) do
    print("Registering module:", moduleName)
    core.register_module(moduleName) -- Fixed to match the core's method signature
end
print("Dynamic modules loaded")

function M.setup(opts)
    print("Starting Alchemy setup...")

    opts = opts or {}
    print("Before setting disableKeyMappings:", vim.inspect(opts))
    local disableKeyMappings = opts.disableKeyMappings or false
    print("After setting disableKeyMappings:", disableKeyMappings)
    
    print("Alchemy configured with options:", vim.inspect(opts))
    
    -- Example: Setup key mappings only if not disabled by opts
    if not opts.disableKeyMappings then
        -- Key mappings and commands
        vim.api.nvim_create_user_command('AGenerateCode', function(opts)
            local code_generator = core.get_module('code_generator') -- Correct way to access modules
            if code_generator then
                code_generator.generate(opts.args)
            else
                print("Error: code_generator module not found")
            end
        end, {desc = 'Generate code using AI', nargs = "*"})
        
        vim.api.nvim_create_user_command('AInvokeFlow', function(opts)
            core.invoke_flow(opts.args)
        end, {desc = 'Invoke an Alchemy flow', nargs = "*"})

        vim.api.nvim_create_user_command('ARunTests', function(opts)
            local test_runner = core.get_module('test_runner') -- Correct way to access modules
            if test_runner then
                test_runner.run_tests(opts.args)
            end
        end, {desc = 'Run tests', nargs = "*"})

        vim.api.nvim_create_user_command('AAnalyzeCode', function(opts)
            local code_analyzer = core.get_module('code_analyzer') -- Correct way to access modules
            if code_analyzer then
                code_analyzer.analyze_code(opts.args)
            end
        end, {desc = 'Analyze code for improvements and potential bugs', nargs = "*"})

        vim.api.nvim_create_user_command('AGenerateDocumentation', function(opts)
            local documentation_generator = core.get_module('documentation_generator') -- Correct way to access modules
            if documentation_generator then
                documentation_generator.generate_documentation(opts.args)
            end
        end, {desc = 'Generate documentation for the codebase', nargs = "*"})
        
        -- Setting key mappings
        vim.api.nvim_set_keymap('n', '<leader>ag', ':AGenerateCode<CR>', {noremap = true, silent = true})
        vim.api.nvim_set_keymap('n', '<leader>af', ':AInvokeFlow<CR>', {noremap = true, silent = true})
        vim.api.nvim_set_keymap('n', '<leader>at', ':ARunTests<CR>', {noremap = true, silent = true})
    end

    -- Dynamically requiring flows
    local flows = {"validation_flow", "feedback_loop"}
    for _, flowName in ipairs(flows) do
        print("Registering flow:", flowName)
        core.register_flow(flowName) -- Adjusted to match the register_flow method signature
    end
    print("Dynamic flows loaded")

    print("Alchemy setup complete. Use the key mappings or commands to interact with the plugin.")
end

return M
