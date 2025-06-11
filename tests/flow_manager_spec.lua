package.path = package.path .. ';./lua/?.lua;./lua/?/init.lua'

local flow_manager = require('alchemy.modules.flow_manager')

before_each(function()
  -- Stop any running timers and reset flows
  for name, flow in pairs(flow_manager.flows) do
    for _, timer in ipairs(flow.timers or {}) do
      timer:stop()
      timer:close()
    end
  end
  flow_manager.flows = {}
end)

describe('flow_manager', function()
  it('creates a flow', function()
    flow_manager.create_flow('test', {})
    assert.is_truthy(flow_manager.flows['test'])
  end)

  it('invokes a flow', function()
    local called = false
    flow_manager.create_flow('invoke', { run = function() called = true end })
    flow_manager.run_flow('invoke')
    assert.is_true(called)
  end)

  it('schedules a flow', function()
    flow_manager.create_flow('scheduled', {})
    flow_manager.schedule_flow('scheduled', 0)
    assert.is_true(#flow_manager.flows['scheduled'].timers > 0)
    flow_manager.stop_schedules('scheduled')
  end)
end)
