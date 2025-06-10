local uv = vim.loop

local M = {
    flows = {}
}

local log = require('alchemy.log')

function M.create_flow(name, opts)
    opts = opts or {}
    M.flows[name] = {
        ai_provider = opts.ai_provider,
        model = opts.model or 'gpt-4',
        instructions = opts.instructions or '',
        run = opts.run or function()
            log.debug('No run function defined for ' .. name)
        end,
        subflows = {},
        timers = {}
    }
end

function M.update_instructions(name, instructions)
    if M.flows[name] then
        M.flows[name].instructions = instructions
    else
        log.debug('Flow not found: ' .. name)
    end
end

function M.run_flow(name, ...)
    local flow = M.flows[name]
    if not flow then
        log.debug('Flow not found: ' .. name)
        return
    end

    if type(flow.run) == 'function' then
        flow.run(...)
    end

    for _, sub in ipairs(flow.subflows) do
        M.run_flow(sub, ...)
    end
end

function M.add_subflow(parent, child)
    if not (M.flows[parent] and M.flows[child]) then
        log.debug('Cannot add subflow, unknown flow')
        return
    end
    table.insert(M.flows[parent].subflows, child)
end

function M.schedule_flow(name, interval)
    local flow = M.flows[name]
    if not flow then
        log.debug('Flow not found: ' .. name)
        return
    end

    interval = interval or 0
    local timer = uv.new_timer()
    timer:start(interval, interval, vim.schedule_wrap(function()
        M.run_flow(name)
    end))
    table.insert(flow.timers, timer)
end

function M.stop_schedules(name)
    local flow = M.flows[name]
    if not flow then
        log.debug('Flow not found: ' .. name)
        return
    end

    for _, t in ipairs(flow.timers) do
        t:stop()
        t:close()
    end
    flow.timers = {}
end

function M.create_flow_from_ai(name, prompt, opts)
    local ai = require('alchemy.modules.ai_integration')
    local instructions = ai.generate_instructions(prompt, opts) or opts.instructions
    opts = opts or {}
    opts.instructions = instructions
    M.create_flow(name, opts)
end

return M
