local uv = vim.loop

local M = {
    flows = {},    -- advanced flow definitions
    graph = {},    -- simple node-based graph
}

-- =========================
-- Node-based graph helpers
-- =========================

function M.add_node(name, fn)
    M.graph[name] = M.graph[name] or { fn = fn, edges = {} }
end

function M.link(source, dest)
    if M.graph[source] and M.graph[dest] then
        table.insert(M.graph[source].edges, dest)
    else
        print('FlowManager: unknown node link ' .. source .. ' -> ' .. dest)
    end
end

local function run_node(name, visited)
    if visited[name] then return end
    visited[name] = true
    local node = M.graph[name]
    if not node then return end
    if type(node.fn) == 'function' then
        node.fn()
    end
    for _, dst in ipairs(node.edges) do
        run_node(dst, visited)
    end
end

function M.run_graph(start)
    run_node(start, {})
end

function M.add_flow(name)
    local ok, flow = pcall(require, 'alchemy.flows.' .. name)
    if ok and type(flow.run) == 'function' then
        M.add_node(name, flow.run)
    else
        print('FlowManager: unable to add flow ' .. name)
    end
end

-- ========================
-- Advanced flow functions
-- ========================

function M.create_flow(name, opts)
    opts = opts or {}
    M.flows[name] = {
        ai_provider = opts.ai_provider,
        model = opts.model or 'gpt-4',
        instructions = opts.instructions or '',
        run = opts.run or function()
            print('No run function defined for ' .. name)
        end,
        subflows = {},
        timers = {},
    }
end

function M.update_instructions(name, instructions)
    if M.flows[name] then
        M.flows[name].instructions = instructions
    else
        print('Flow not found: ' .. name)
    end
end

function M.run_flow(name, ...)
    local flow = M.flows[name]
    if not flow then
        print('Flow not found: ' .. name)
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
        print('Cannot add subflow, unknown flow')
        return
    end
    table.insert(M.flows[parent].subflows, child)
end

function M.schedule_flow(name, interval)
    local flow = M.flows[name]
    if not flow then
        print('Flow not found: ' .. name)
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
        print('Flow not found: ' .. name)
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
    local instructions = ai.generate_instructions(prompt, opts) or (opts and opts.instructions)
    opts = opts or {}
    opts.instructions = instructions
    M.create_flow(name, opts)
end

return M
