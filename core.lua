local M = {
  flows = {},
  modules = {}
}

function M.register_flow(name, flow)
  M.flows[name] = flow
end

function M.register_module(name, module)
  M.modules[name] = module
end

function M.invoke_flow(name, ...)
  if M.flows[name] then
      M.flows[name](...)
  else
      print("Unknown flow: " .. name)
  end
end

-- Example utility function to get a module by name
function M.get_module(name)
  return M.modules[name]
end

return M
