local M = {}

-- Default configuration
local config = { debug = false }

function M.set_config(cfg)
  config = cfg or config
end

function M.debug(...)
  if config.debug then
    print(...)
  end
end

return M
