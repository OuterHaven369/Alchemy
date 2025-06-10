local M = {
    config = {
        disableKeyMappings = false,
        ai_provider = 'openai',
        model = 'gpt-4',
        api_key = nil
    }
}

local core = require('alchemy.core')
print("Configuring Alchemy...")

-- Registering modules
local modules = {"ai_integration", "code_analyzer", "code_generator", "documentation_generator", "test_runner", "version_control", "flow_manager"}
for _, moduleName in ipairs(modules) do
    print("Registering module:", moduleName)
    core.register_module(moduleName) -- Corrected, no additional parameter needed
end
print("Dynamic modules loaded")

function M.setup(opts)
    opts = opts or {}
    M.config = vim.tbl_extend('force', M.config, opts)
    print("Starting Alchemy setup with options:", vim.inspect(M.config))

    opts = opts or {}
    print("Before setting disableKeyMappings:", vim.inspect(opts))
    local disableKeyMappings = opts.disableKeyMappings or false
    print("After setting disableKeyMappings:", disableKeyMappings)

    print("Alchemy configured with options:", vim.inspect(opts))

    -- Example: Setup key mappings only if not disabled by opts
    if not M.config.disableKeyMappings then
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

        vim.api.nvim_create_user_command('ACreateFlow', function(opts)
            local flow_manager = core.get_module('flow_manager')
            if flow_manager then
                local name = opts.fargs[1]
                local instructions = table.concat(opts.fargs, ' ', 2)
                flow_manager.create_flow(name, { instructions = instructions })
            end
        end, {desc = 'Create a simple flow', nargs = '+'})

        vim.api.nvim_create_user_command('AScheduleFlow', function(opts)
            local flow_manager = core.get_module('flow_manager')
            if flow_manager then
                local name = opts.fargs[1]
                local interval = tonumber(opts.fargs[2]) or 0
                flow_manager.schedule_flow(name, interval)
            end
        end, {desc = 'Schedule a flow to run on an interval', nargs = '+'})

        vim.api.nvim_create_user_command('AAddSubflow', function(opts)
            local flow_manager = core.get_module('flow_manager')
            if flow_manager then
                local parent = opts.fargs[1]
                local child = opts.fargs[2]
                flow_manager.add_subflow(parent, child)
            end
        end, {desc = 'Attach a subflow to another flow', nargs = 2})

        vim.api.nvim_create_user_command('ACreateFlowAI', function(opts)
            local flow_manager = core.get_module('flow_manager')
            if flow_manager then
                local name = opts.fargs[1]
                local prompt = table.concat(opts.fargs, ' ', 2)
                flow_manager.create_flow_from_ai(name, prompt)
            end
        end, {desc = 'Use the AI to generate and register a flow', nargs = '+'})

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

    -- Dynamically requiring and registering flows and modules...
    local modules = {"ai_integration", "code_analyzer", "code_generator", "documentation_generator", "test_runner", "version_control", "flow_manager"}
    for _, moduleName in ipairs(modules) do
        core.register_module(moduleName)
    end

    local flows = {"validation_flow", "feedback_loop"}
    for _, flowName in ipairs(flows) do
        core.register_flow(flowName)
    end

    print("Alchemy setup complete. Use the key mappings or commands to interact with the plugin.")
end

return M

