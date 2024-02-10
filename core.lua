local M = {
    flows = {}
  }
  
  function M.register_flow(name, flow)
    M.flows[name] = flow
  end
  
  function M.invoke_flow(name, ...)
    if M.flows[name] then
      M.flows[name](...)
    else
      print("Unknown flow: " .. name)
    end
  end
  
  return M
  