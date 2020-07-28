# Critique Gaming's boilerplate project

Ready-to-use starter project based on [Crit], [Monarch] and [DefOS].

[Crit]: https://github.com/critique-gaming/crit
[Monarch]: https://github.com/britzl/monarch
[DefOS]: https://github.com/subsoap/defos

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
* Testing and code coverage with [DefTest], [Codecov] and Github Actions.
* LDoc-ready documentation. Use the provided GitHub Actions workflow to 
[publish it to GitHub Pages](https://critique-gaming.github.io/crit-boilerplate)
* Build script with macOS code-signing and notarization, Steam and GoG upload support and many
other bells and whistles

[DefTest]: https://github.com/britzl/deftest
[Codecov]: https://codecov.io

## Global key bindings

* `Alt + F4` (Windows and Linux only): Quit the game
* `Alt + Enter`: Toggle full screen
* `Ctrl + Backquote` (Debug builds only): Toggle profiler
* `Ctrl + P` (Debug builds only): Toggle physics debugger

## Useful [`env.lua`](https://critique-gaming.github.io/crit/modules/crit.env.html) variables

Create a `_env/env.lua` file that returns a Lua table with development flags for the game.

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

## GitHub Actions

All the GitHub Actions configured for this repository are configured to run when
you push to the `dist` branch. If you prefer the tests always running when 
pushing to any branch, just remove the `branches: [dist]` line in `run-tests.yml`.

If you plan on making your project repository private, you'll need to obtain and 
add a `CODECOV_TOKEN` to your secrets (in GitHub's repo settings).

## Build script

Install Lua and run `lua deploy.lua_ --help` to see all the available options.

Most of the options are configurable from the command line or with environment
variables. You can also create a `.deploy_env` file (a Lua module which returns 
a Lua table) instead of environment variables.

### macOS Notarization

Add `MAC_IDENTITY`, `APPLE_ID`, `APPLE_ID_PASSWORD` and `ASC_PROVIDER` to your 
environment variables, `.deploy_env` or GitHub secrets and the app will be 
code signed and notarized for you.

### Steam

First go to `deploy/steam/config.lua_` and `steam.ini` and add your Steam app ID
and depot IDs.

When bundling with `deploy.lua_ steam`, the [Steamworks extension](https://github.com/britzl/steamworks-defold) 
will be automatically included into your project.

You will also need to 
[download and install SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD#Downloading_SteamCMD) 
and set the `STEAMCMD` env var to its path.

Finally, set the `STEAM_USER` and `STEAM_PASSWORD` environment variables to your
Steam login credentials. It's recommended you make a Steam account just for this.

You can add all of these env vars to `.deploy_env` for convenience.

If you add `STEAM_USER` and `STEAM_PASSWORD` to GitHub secrets, then push
to the `dist-steam` branch, a GitHub Action will automatically build and push
to Steam for you.

### GOG

You need to assemble the [GOG Galaxy extension][https://github.com/dapetcu21/defold-gog-galaxy]
yourself in a private repo, add your GitHub access token to the dependency URL,
then use the `GOG_GALAXY_DEPENDENCY_URL` environment variable when running 
`deploy.lua_` to add the extension to your build when bundling with `deploy.lua_ gog`

Then, go to `deploy/gog/config.lua_` and `gog.ini` and set your Product ID,
Client ID and Client Secret.

Add your branch passwords to the
`GOG_BRANCH_PASS_STAGING` and `GOG_BRANCH_PASS_STAGING_DEBUG` env vars.

You will need to download GOG Pipeline Builder, install it and set the
`GOG_PIPELINE_BUILDER` env var to its path.

Finally, set the `GOG_USER` and `GOG_PASSWORD` environment variables to your
GOG login credentials.

You can add all of these env vars to `.deploy_env` for convenience.

If you add `GOG_GALAXY_DEPENDENCY_URL`, `GOG_USER`, `GOG_PASSWORD`, 
`GOG_BRANCH_PASS_STAGING` and `GOG_BRANCH_PASS_STAGING_DEBUG`
to GitHub secrets, then push to the `dist-gog` branch, a GitHub Action will 
automatically build and push to GOG for you.