function PLUGIN:BackendListVersions(ctx)
  local http = require("http")
  local json = require("json")
  local versions_lib = require("versions")
  local log = require("log")

  -- ctx.tool will be "owner/repo" (e.g., "block/buzz")
  local repo = ctx.tool

  log.debug("listing releases for " .. repo)
  local resp = http.get({
    url = "https://api.github.com/repos/" .. repo .. "/releases",
    headers = {
      ["User-Agent"] = "mise-dmg-plugin"
    }
  })

  if resp.status_code ~= 200 then
    error("Failed to fetch releases for " .. repo .. " (HTTP " .. tostring(resp.status_code) .. ")")
  end

  local releases = json.decode(resp.body)
  local versions = versions_lib.from_releases(releases)
  log.debug("found " .. #versions .. " version(s), latest is " .. tostring(versions[#versions]))

  return { versions = versions }
end
