-- Plain-lua tests for lib/versions.lua. Run with: lua tests/versions_test.lua

local script_dir = arg[0]:match("(.*/)") or "./"
package.path = script_dir .. "../lib/?.lua;" .. package.path
local versions = require("versions")

local failures = 0

local function check(name, condition, detail)
  if condition then
    print("ok - " .. name)
  else
    failures = failures + 1
    print("NOT OK - " .. name .. (detail and (": " .. detail) or ""))
  end
end

local function same(a, b)
  if #a ~= #b then
    return false
  end
  for i = 1, #a do
    if a[i] ~= b[i] then
      return false
    end
  end
  return true
end

local function to_s(list)
  return "{" .. table.concat(list, ", ") .. "}"
end

-- GitHub returns releases newest-first: the regression this guards against
-- is mise resolving "@latest" to list.last(), i.e. the oldest release,
-- because the plugin forwarded GitHub's order unchanged.
local function test_reverses_github_newest_first_order()
  local releases = {
    { tag_name = "v1.0.1", draft = false },
    { tag_name = "v1.0.0", draft = false },
    { tag_name = "v0.0.1", draft = false },
  }

  local result = versions.from_releases(releases)

  check("oldest release first", result[1] == "0.0.1", to_s(result))
  check("newest release last (what mise treats as latest)", result[#result] == "1.0.1", to_s(result))
  check("full order reversed", same(result, { "0.0.1", "1.0.0", "1.0.1" }), to_s(result))
end

local function test_strips_leading_v()
  local releases = { { tag_name = "v2.3.4", draft = false } }
  local result = versions.from_releases(releases)
  check("leading v stripped", result[1] == "2.3.4", to_s(result))
end

local function test_excludes_drafts()
  local releases = {
    { tag_name = "v2.0.0", draft = false },
    { tag_name = "v3.0.0-draft", draft = true },
    { tag_name = "v1.0.0", draft = false },
  }
  local result = versions.from_releases(releases)
  check("draft excluded", same(result, { "1.0.0", "2.0.0" }), to_s(result))
end

local function test_empty_releases()
  local result = versions.from_releases({})
  check("empty input yields empty list", #result == 0, to_s(result))
end

test_reverses_github_newest_first_order()
test_strips_leading_v()
test_excludes_drafts()
test_empty_releases()

if failures > 0 then
  print(failures .. " check(s) failed")
  os.exit(1)
else
  print("all checks passed")
  os.exit(0)
end
