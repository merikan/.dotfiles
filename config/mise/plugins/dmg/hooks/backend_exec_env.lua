function PLUGIN:BackendExecEnv(ctx)
  local cmd = require("cmd")
  local json = require("json")
  local appdir = require("appdir")
  local log = require("log")
  local install_path = ctx.install_path

  -- Find any MacOS binary folder inside installed .app bundles
  local res = cmd.exec(string.format("find %s -maxdepth 3 -type d -path '*/Contents/MacOS' | head -n 1", install_path))
  local bin_path = res:gsub("%s+$", "")

  -- If no .app bundle was found, default to install_path itself
  if bin_path == "" then
    bin_path = install_path
  end
  log.debug("PATH bin dir for " .. ctx.tool .. "@" .. ctx.version .. " is " .. bin_path)

  -- Keep /Applications synced with whatever version is active, like
  -- Homebrew Cask. This hook runs on every `mise use`/shell activation
  -- (not just fresh installs), so it's what actually makes the copy show
  -- up reliably. Best-effort: never fails env computation, and appdir.sync
  -- is a cheap no-op once the receipt already matches, so this stays fast
  -- on the common path.
  local ok, err = pcall(function()
    local apps = cmd.exec(string.format("find %s -maxdepth 1 -name '*.app'", install_path))
    for app_path in apps:gmatch("[^\n]+") do
      local status, reason = appdir.sync(cmd, json.encode, json.decode, app_path, ctx.tool, ctx.version)
      log.debug("/Applications sync for " .. app_path .. ": " .. status)
      if status == "skipped" then
        log.warn(reason)
      end
    end
  end)
  if not ok then
    log.warn("failed to sync app bundle into /Applications: " .. tostring(err))
  end

  return {
    env_vars = {
      { key = "PATH", value = bin_path }
    }
  }
end
