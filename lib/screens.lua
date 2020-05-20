local progression = require "crit.progression"
local monarch = require "monarch.monarch"

local M = {}

function M.replace(screen_id, data, options)
  local co = coroutine.running()
  monarch.replace(screen_id, options, data, function ()
    if co then progression.resume(co) end
  end)
  coroutine.yield(function () co = nil end)
end

function M.show(screen_id, data, options)
  local co = coroutine.running()
  monarch.show(screen_id, options, data, function ()
    if co then progression.resume(co) end
  end)
  coroutine.yield(function () co = nil end)
end

function M.back(data)
  local co = coroutine.running()
  monarch.back(data, function ()
    if co then progression.resume(co) end
  end)
  coroutine.yield(function () co = nil end)
end

return M
