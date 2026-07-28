-- Turns a GitHub /releases API response into the version list mise expects.
-- Extracted from backend_list_versions.lua so the ordering logic can be
-- tested without the http/json host modules (see tests/).
local M = {}

-- releases: decoded JSON array from GET /repos/{repo}/releases (as returned
--           by GitHub - newest release first).
--
-- Returns versions oldest-first. mise resolves "@latest" by taking the
-- *last* entry of what backend_list_versions returns (see
-- find_match_in_list/list.last() in mise's backend/mod.rs), so the newest
-- release must end up last here, not first.
function M.from_releases(releases)
  local versions = {}

  for _, release in ipairs(releases) do
    if not release.draft then
      -- Normalize version (strip leading 'v')
      local v = release.tag_name:gsub("^v", "")
      table.insert(versions, v)
    end
  end

  local reversed = {}
  for i = #versions, 1, -1 do
    table.insert(reversed, versions[i])
  end

  return reversed
end

return M
