# Notes

## Adding a component:
  * Add its stats to lib/component_data.lua
  * Add its id to lib/component_hashes.lua
  * Create component tilemap and go
  * Make sure there is a factory component for it in level/components.go

## Collision groups:
  * **comp**  -  _comp_, _bounds_, _access_, _heat_, _mouse_, _bonus_
  * **access** - _comp_, _bounds_, _heat_
  * **heat**  - _comp_, _bounds_, _access_
  * **bonus** - _comp_
  * **mouse** - _comp_


---
