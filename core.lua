local M = {
  flows = {},
  modules = {}
}

-- Dynamically requires a flow from the 'flows' directory
function M.require_flow(flow_name)
    local ok, flow = pcall(require, "alchemy.flows." .. flow_name)
    if not ok then
        error("Failed to load flow: " .. flow_name)
    end
    return flow
end

-- Dynamically requires a module from the 'modules' directory
function M.require_module(module_name)
    local ok, module = pcall(require, "alchemy.modules." .. module_name)
    if not ok then
        error("Failed to load module: " .. module_name)
    end
    return module
end

function M.register_flow(name)
  print("Registering flow:", name)
  local flow = M.require_flow(name)
  M.flows[name] = flow
  print("Flow registered successfully:", name)
end

function M.register_module(name)
  print("Registering module:", name)
  local module = M.require_module(name)
  M.modules[name] = module
  print("Module registered successfully:", name)
end

function M.invoke_flow(name, ...)
  print("Invoking flow:", name)
  if M.flows[name] then
      M.flows[name](...)
      print("Flow invoked successfully:", name)
  else
      print("Unknown flow:", name)
  end
end

-- Utility function to get a module by name
function M.get_module(name)
  if M.modules[name] then
    print("Module found:", name)
    return M.modules[name]
  else
    print("Module not found:", name)
    return nil
  end
end

return M
