local screens = require "lib.screens"

local function game()
  screens.replace("game")
  print("Screen transition finished")
end

return game
