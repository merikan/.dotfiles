function PLUGIN:BackendInstall(ctx)
  local cmd = require("cmd")
  local http = require("http")
  local json = require("json")
  local receipt = require("receipt")
  local log = require("log")

  local repo = ctx.tool            -- e.g., "block/buzz"
  local version = ctx.version        -- e.g., "0.6.2"
  local install_path = ctx.install_path

  log.debug("installing " .. repo .. "@" .. version .. " into " .. install_path)

  -- Fetch release details from GitHub API to locate the .dmg download URL
  local tag = "v" .. version
  local api_url = "https://api.github.com/repos/" .. repo .. "/releases/tags/" .. tag

  log.debug("looking up release " .. tag .. " via " .. api_url)
  local resp = http.get({
    url = api_url,
    headers = { ["User-Agent"] = "mise-dmg-plugin" }
  })

  -- Fall back to raw tag without 'v' if 'v1.0' failed
  if resp.status_code ~= 200 then
    tag = version
    api_url = "https://api.github.com/repos/" .. repo .. "/releases/tags/" .. tag
    log.debug("tag with 'v' prefix not found, retrying as " .. tag)
    resp = http.get({
      url = api_url,
      headers = { ["User-Agent"] = "mise-dmg-plugin" }
    })
  end

  if resp.status_code ~= 200 then
    error("Failed to locate release metadata for " .. repo .. " at tag " .. tag)
  end

  local release_data = json.decode(resp.body)
  local download_url = nil

  -- Look through release assets for a file ending in .dmg
  for _, asset in ipairs(release_data.assets or {}) do
    if asset.name:match("%.dmg$") then
      download_url = asset.browser_download_url
      log.debug("found .dmg asset: " .. asset.name)
      break
    end
  end

  if not download_url then
    error("No .dmg asset found in GitHub release for " .. repo .. "@" .. version)
  end

  -- Download DMG
  local safe_name = repo:gsub("/", "_")
  local temp_dmg = "/tmp/" .. safe_name .. "_" .. version .. ".dmg"
  local mount_point = "/tmp/" .. safe_name .. "_mount_" .. version

  log.debug("downloading " .. download_url .. " to " .. temp_dmg)
  http.download_file({ url = download_url }, temp_dmg)

  -- Mount and extract .app bundle
  log.debug("mounting " .. temp_dmg .. " at " .. mount_point)
  cmd.exec(string.format("mkdir -p %s", mount_point))
  cmd.exec(string.format("hdiutil attach %s -mountpoint %s -quiet", temp_dmg, mount_point))

  -- Copy all .app packages inside the mounted drive to the install path
  log.debug("copying extracted contents to " .. install_path)
  cmd.exec(string.format("cp -R %s/*.app %s/ 2>/dev/null || cp -R %s/* %s/", mount_point, install_path, mount_point, install_path))

  -- Clean up
  log.debug("unmounting and cleaning up temp files")
  cmd.exec(string.format("hdiutil detach %s -quiet", mount_point))
  cmd.exec(string.format("rm -rf %s %s", temp_dmg, mount_point))

  -- Record what got installed, like Homebrew's per-keg INSTALL_RECEIPT.json.
  -- The /Applications copy itself is kept in sync from backend_exec_env,
  -- since that hook runs on every `mise use`/shell activation - not just a
  -- fresh install - which is what actually makes the app show up there
  -- reliably.
  local receipt_path = install_path .. "/installed_receipt.json"
  log.debug("writing install receipt to " .. receipt_path)
  receipt.write(receipt_path, receipt.build(repo, version), json.encode)

  return {}
end
