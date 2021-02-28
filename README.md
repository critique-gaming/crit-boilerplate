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

GitHub Actions are configured for this repository to test and build the project.
All Actions that build the game, upload all the artefacts (including debug 
symbols) to an Amazon S3 bucket. For this to work, you need to define the 
following secrets (in the GitHub's repo settings):

* `AWS_ACCESS_KEY_ID`: An access key id with write access to that S3 bucket
* `AWS_SECRET_ACCESS_KEY`: The access key
* `AWS_REGION`: The AWS region of the bucket
* `S3_BUCKET_BUILDS`: The S3 bucket where to store the builds

### Testing

Push to the `dist` branch if you want to run the tests.  If you prefer the tests 
always running when pushing to any branch, just remove the 
`branches: [dist]` line in `run-tests.yml` line in `.github/workflows/run-tests.yml`.

If you plan on making your project repository private, you'll need to obtain and 
add a `CODECOV_TOKEN` to your secrets (in Github's repo settings).

### Documentation

Pushing to the `dist` branch also triggers building of the LDoc documentation.
After being built, it's pushed to the `gh-pages` branch, suitable for Github Pages
hosting.

### Desktop builds

Push to `dist-desktop` to build the game for Windows, macOS and Linux.

macOS code signing and notarization is not enabled by default because it requires
a macOS runner, which is expensive for private repos. To enable it:

* Export your certificates from Keychain as a P12 file, then Base64-encode it
and save it in the `APPLE_CERTIFICATES_P12` secret. Save its password as
`APPLE_CERTIFICATES_P12_PASSWORD`.

* Add `MAC_IDENTITY`, `APPLE_ID`, `APPLE_ID_PASSWORD` and `ASC_PROVIDER` to your 
secrets.

* Un-comment all the macOS specific stuff in `.github/actions/build-desktop.yml`

* Remove the `--skip-notarize` flag from the release build step

### Mobile builds

Push to `dist-mobile` to build the game for iOS and Android.

For Android builds, you'll need to generate a keystore, then Base64-encode it
and save it as the `ANDROID_KEYSTORE_AS_BASE64` secret. Save its alias and password
as `ANDROID_KEYSTORE_ALIAS` and `ANDROID_KEYSTORE_PASSWORD`.

For iOS, the builds are not code signed by default (macOS runners are expensive).
You can either code sign them manually before uploading them to the App Store
([XReSign](https://github.com/xndrs/XReSign) is a handy tool for this), either,
to do it automatically:

* Export your certificates from Keychain as a P12 file, then Base64-encode it
and save it in the `APPLE_CERTIFICATES_P12` secret. Save its password as
`APPLE_CERTIFICATES_P12_PASSWORD`.

* Add `IOS_IDENTITY`, and `IOS_PROVISIONING_AS_BASE64` (the Base64-encoded 
provisioning profile file), to your secrets.

* Un-comment all the macOS specific stuff in `.github/actions/build-mobile.yml`

### Web builds

Push to `dist-web` to build the game for HTML5 and deploy it to S3 web hosting.

You'll need to set up an AWS S3 bucket for web hosting and a Cloudfront distribution
(as HTTPS proxy), then add `S3_BUCKET_WEB` and `CLOUDFRONT_DISTRIBUTION_ID` to
secrets.

## Build script

Install LuaJIT and run `luajit deploy.lua_ --help` to see all the available options.

Most of the options are configurable from the command line or with environment
variables. You can also create a `.deploy_env` file (a Lua module which returns 
a Lua table) instead of environment variables.

You can configure game-specific settings and define build script hooks or commands
in the `deploy/config` directory. You can find all sorts of app icons and 
manifests in there.

### macOS notarization

Add `MAC_IDENTITY`, `APPLE_ID`, `APPLE_ID_PASSWORD` and `ASC_PROVIDER` to your 
environment variables or `.deploy_env` and the app will be 
code signed and notarized for you.

### iOS code signing

Add `IOS_IDENTITY` and `IOS_PROVISIONING` (path to a provisioning profile) to
your environment or `.deploy_env`.

### Android signing

Generate a keystore and add its path to your environment as `ANDROID_KEYSTORE`.
Also add its alias and password as `ANDROID_KEYSTORE_ALIAS` and `ANDROID_KEYSTORE_PASSWORD`.

### Steam

First go to `deploy/config/steam.lua_` and `deploy/config/project_properties/steam.ini` 
and add your Steam app ID and depot IDs.

When bundling with `deploy.lua_ steam`, the [Steamworks extension](https://github.com/britzl/steamworks-defold) 
will be automatically included into your project.

You will also need to 
[download and install SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD#Downloading_SteamCMD) 
and set the `STEAMCMD` env var to its path.

Finally, set the `STEAM_USER` and `STEAM_PASSWORD` environment variables to your
Steam login credentials. It's recommended you make a Steam account just for this.

You can add all of these env vars to `.deploy_env` for convenience.

### GOG

You need to assemble the [GOG Galaxy extension](https://github.com/dapetcu21/defold-gog-galaxy)
yourself in a private repo, add your GitHub access token to the dependency URL,
then use the `GOG_GALAXY_DEPENDENCY_URL` environment variable when running 
`deploy.lua_` to add the extension to your build when bundling with `deploy.lua_ gog`

Then, go to `deploy/config/gog.lua_` and `deploy/config/project_properties/gog.ini` 
and set your Product ID, Client ID and Client Secret.

Add your branch passwords to the
`GOG_BRANCH_PASS_STAGING` and `GOG_BRANCH_PASS_STAGING_DEBUG` env vars.

You will need to download GOG Pipeline Builder, install it and set the
`GOG_PIPELINE_BUILDER` env var to its path.

Finally, set the `GOG_USER` and `GOG_PASSWORD` environment variables to your
GOG login credentials.

You can add all of these env vars to `.deploy_env` for convenience.
