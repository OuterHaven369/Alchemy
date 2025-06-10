local M = {
    flows = {},
    modules = {}
}

local log = require('alchemy.log')

function M.require_flow(flow_name)
    local ok, flow = pcall(require, "alchemy.flows." .. flow_name)
    if not ok then
        error("Failed to load flow: " .. flow_name)
    end
    return flow
end

function M.require_module(module_name)
    local ok, module = pcall(require, "alchemy.modules." .. module_name)
    if not ok then
        error("Failed to load module: " .. module_name)
    end
    return module
end

function M.register_flow(name)
    log.debug("Registering flow:", name)
    local flow = M.require_flow(name)
    M.flows[name] = flow
    log.debug("Flow registered successfully:", name)
end

function M.register_module(name)
    log.debug("Registering module:", name)
    local module = M.require_module(name)
    M.modules[name] = module
    log.debug("Module registered successfully:", name)
end

function M.invoke_flow(name, ...)
    log.debug("Invoking flow:", name)
    if M.flows[name] then
        local flow = M.flows[name]
        if type(flow.run) == 'function' then
            flow.run(...)
        end
        log.debug("Flow invoked successfully:", name)
    else
        local fm = M.modules['flow_manager']
        if fm and fm.flows[name] then
            fm.run_flow(name, ...)
            log.debug("Flow invoked successfully:", name)
        else
            log.debug("Unknown flow:", name)
        end
    end
end

function M.get_module(name)
    if M.modules[name] then
        log.debug("Module found:", name)
        return M.modules[name]
    else
        log.debug("Module not found:", name)
        return nil
    end
end

return M
