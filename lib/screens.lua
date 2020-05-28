local progression = require "crit.progression"
local monarch = require "monarch.monarch"

local M = {}

function M.show(screen_id, data, options)
  options = options or {}
  if options.sequential == nil then
    options.sequential = true
  end

  screen_id = hash(screen_id)

  local fork = progression.fork(function ()
    progression.wait_for_message(monarch.SCREEN_TRANSITION_IN_STARTED, function (_, message)
      return message.screen == screen_id
    end)
  end)

  local callback, wait_for_callback = progression.make_callback()
  callback = progression.with_context(callback)

  monarch.show(screen_id, options, data, callback)
  progression.join(fork)

  return wait_for_callback
end

function M.replace(screen_id, data, options)
  options = options or {}
  if options.pop == nil then
    options.pop = 1
  end
  return M.show(screen_id, data, options)
end

function M.back(data)
  local callback, wait_for_callback = progression.make_callback()
  callback = progression.with_context(callback)
  monarch.back(data, callback)
  return wait_for_callback
end

return M
