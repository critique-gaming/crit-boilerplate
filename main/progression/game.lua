local screens = require "lib.screens"

local function game()
  local wait_for_transition = screens.replace("game")
  print("Screen loaded")
  wait_for_transition()
  print("Screen transition finished")
end

return game
