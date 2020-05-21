# Critique Gaming's boilerplate project

Ready-to-use starter project based on [Crit](https://github.com/dapetcu21/crit), [Monarch](https://github.com/britzl/monarch) and [DefOS](https://github.com/subsoap/defos)

## Features

* Monarch and a fade-to-black screen transition for Monarch
* Coreograph your game's high-level progression with `crit.progression`
* Wrapped a few Monarch functions as `crit.progression`-friendly versions
* Integrated `crit.layout` with the render script
* `crit.intl`
* `crit.analog_to_digital`
* Set-up input method switching (`crit.input_state`)
* Common global keybindings already set-up
* Quickly check which keys are being held down with the `held_keys` table
* Save profile management
* Testing and code coverage with [DefTest], [TravisCI] and codecov

[DefTest]: https://github.com/britzl/deftest
[TravisCI]: https://travis-ci.org
[CodeCov]: https://codecov.io

## Global key bindings

* `Alt + F4` (Windows and Linux only): Quit the game
* `Alt + Enter`: Toggle full screen
* `Ctrl + Backquote` (Debug builds only): Toggle profiler
* `Ctrl + P` (Debug builds only): Toggle physics debugger

## Useful [`env.lua`](https://github.com/dapetcu21/crit/blob/master/docs/env.md) variables

|Var name|Type|Usage|
|-|-|-|
|`window_width`|`number`|On start-up, resize the window to this width.&ast;|
|`window_height`|`number`|On start-up, resize the window to this height.&ast;|
|`display`|`number`|On start-up, move the window to this display.|
|`full_screen`|`boolean`|Force full screen (`true`) or windowed (`false`) on start-up.|
|`entry_progression`|`string`|On start-up, run this progression instead of the `"main"` progression.|
|`entry_screen`|`string or hash`|On start-up, load the Monarch screen with this ID.|
|`entry_screen_data`|`any`|If `entry_screen` is specified, this will be the screen data passed to Monarch.|
|`language`|`string`|Intl language override.|

&ast;Specifying just one of `window_width` and `window_height` will assume the game's design aspect ratio (`display.width`:`display.height` from `game.project`, by default 16:9)
