--[[--
Held keys table.

This will contain all the input actions that are
currently pressed down. For example:

```lua
if held_keys[hash("key_space")] then
  print("Spacebar is being held down")
end
```
]]
-- @module lib.held_keys

return {}
