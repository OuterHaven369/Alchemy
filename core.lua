local M = {
  flows = {},
  modules = {}
}

function M.register_flow(name, flow)
  print("Registering flow:", name)
  M.flows[name] = flow
end

function M.register_module(name, module)
  print("Registering module:", name)
  M.modules[name] = module
end

function M.invoke_flow(name, ...)
  print("Invoking flow:", name)
  if M.flows[name] then
      M.flows[name](...)
      print("Flow invoked successfully:", name)
  else
      print("Unknown flow: " .. name)
  end
end

-- Example utility function to get a module by name
function M.get_module(name)
  print("Getting module:", name)
  if M.modules[name] then
    print("Module found:", name)
  else
    print("Module not found:", name)
  end
  return M.modules[name]
end

return M
