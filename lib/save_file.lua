local M = require "crit.save_file"
local dispatcher = require "crit.dispatcher"

local h_config_change = hash("config_change")

M.config = M.get_config(M.get_save_file("config"), {
  version = 1,
  defaults = {
    profile = 1,
    full_screen = true,
  },
  callback = function (key, value, old_value)
    dispatcher.dispatch(h_config_change, {
      key = key,
      value = value,
      old_value = old_value,
    })
  end,
})

M.globals = M.get_config(M.get_save_file("save_globals"), {
  version = 1,
})

local current_profile = M.get_save_profile(M.config.profile)

function M.get_current_profile()
  return current_profile
end

function M.set_current_profile(index)
  current_profile = M.get_save_file(index)
  M.config.profile = index
end

return M
