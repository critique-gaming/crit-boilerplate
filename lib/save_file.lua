local default_config = require "lib.default_config"
local table_util = require "crit.table_util"

local game_name = sys.get_config("project.title")
local config_version = 1
local save_version = 1

local config_file_path = sys.get_save_file(game_name, "config")
local globals_file_path = sys.get_save_file(game_name, "save_globals")

local config = sys.load(config_file_path)
config.version = config.version or 0
if config.version > config_version then
  error("Config file created by a newer version of the game")
end

local globals = sys.load(globals_file_path)

local full_config = {}
table_util.assign(full_config, default_config)
table_util.assign(full_config, config)

local function set_config(key, value)
  if config[key] ~= value then
    config[key] = value

    local full_value = value
    if full_value == nil then
      full_value = default_config[key]
    end
    full_config[key] = full_value

    config.version = config_version
    sys.save(config_file_path, config)
  end
end

local globals_callback

local function set_global(key, value)
  local old_value = globals[key]
  if old_value ~= value then
    globals[key] = value
    sys.save(globals_file_path, globals)
    if globals_callback then
      globals_callback(key, value, old_value)
    end
  end
end

local function set_globals_callback(fn)
  globals_callback = fn
end

local function backwards_compat(data)
  local version = data.version or 0
  if version > save_version then
    error("Save profile created by a newer version of the game")
  end

  -- Migrate a profile created with an older version of the game
  return data
end

local function get_profile(save_path)
  local data

  local function load()
    data = backwards_compat(sys.load(save_path))
    return data
  end

  local function get()
    if not data then
      return load()
    else
      return data
    end
  end

  local function save(new_data)
    data = new_data
    sys.save(save_path, new_data)
  end

  local function duplicate_from_profile(other_profile)
    save(table_util.deep_clone(other_profile.get()))
  end

  return {
    load = load,
    get = get,
    save = save,
    duplicate_from_profile = duplicate_from_profile,
  }
end

local function get_memory_profile(data)
  data = backwards_compat(data or {
    history = {},
    checkpoints = {},
  })

  local function load()
    return data
  end
  local function save(new_data)
    data = new_data
  end
  return {
    load = load,
    get = load,
    save = save,
  }
end

local function get_profile_by_index(index)
  local save_file_name = index == 1 and "save" or ("save_" .. tostring(index))
  local save_file_path = sys.get_save_file(game_name, save_file_name)
  return get_profile(save_file_path)
end

local current_profile = get_profile_by_index(full_config.profile)

local function get_current_profile()
  return current_profile
end

local function set_current_profile(index)
  current_profile = get_profile_by_index(index)
  set_config("profile", index)
end

return {
  game_name = game_name,
  config_file_path = config_file_path,
  config = full_config,
  set_config = set_config,
  globals = globals,
  set_global = set_global,
  set_globals_callback = set_globals_callback,
  get_profile = get_profile,
  get_profile_by_index = get_profile_by_index,
  get_memory_profile = get_memory_profile,
  get_current_profile = get_current_profile,
  set_current_profile = set_current_profile,
}
