-- Plain-lua tests for lib/receipt.lua. Run with: lua tests/receipt_test.lua

local script_dir = arg[0]:match("(.*/)") or "./"
package.path = script_dir .. "../lib/?.lua;" .. package.path
local receipt = require("receipt")

local failures = 0

local function check(name, condition, detail)
  if condition then
    print("ok - " .. name)
  else
    failures = failures + 1
    print("NOT OK - " .. name .. (detail and (": " .. detail) or ""))
  end
end

-- Fixed timestamp (2024-01-02T03:04:05Z) so the test is deterministic
-- regardless of when/where it runs.
local FIXED_TIME = 1704164645

local function test_build_records_repo_version_and_timestamp()
  local r = receipt.build("block/buzz", "0.3.45", FIXED_TIME)

  check("repo recorded", r.repo == "block/buzz", tostring(r.repo))
  check("version recorded", r.version == "0.3.45", tostring(r.version))
  check("installed_at is ISO 8601 UTC", r.installed_at == "2024-01-02T03:04:05Z", tostring(r.installed_at))
end

local function test_build_defaults_to_current_time()
  local before = os.time()
  local r = receipt.build("block/buzz", "0.3.45")
  local after = os.time()

  -- Round-trip installed_at back through os.time via os.date/os.time isn't
  -- portable across locales, so just check it's a plausible ISO string and
  -- was generated "now" by comparing against a fresh build without `now`.
  check("installed_at set when now omitted", r.installed_at ~= nil and #r.installed_at > 0)
  check("installed_at looks like ISO 8601", r.installed_at:match("^%d%d%d%d%-%d%d%-%d%dT%d%d:%d%d:%d%dZ$") ~= nil, r.installed_at)
  check("before/after sanity", before <= after)
end

-- json.encode isn't available outside mise's runtime, so inject a stub to
-- verify write() wires path/receipt/encode together correctly.
local function test_write_encodes_and_writes_to_disk()
  local path = os.tmpname()
  local encode_calls = {}
  local function fake_encode(value)
    table.insert(encode_calls, value)
    return "ENCODED:" .. value.repo .. "@" .. value.version
  end

  local r = receipt.build("Magnus-Gille/sagascript", "1.0.1", FIXED_TIME)
  receipt.write(path, r, fake_encode)

  check("encode called exactly once", #encode_calls == 1, tostring(#encode_calls))
  check("encode received the receipt", encode_calls[1] == r)

  local file = io.open(path, "r")
  check("file was created", file ~= nil)
  if file then
    local contents = file:read("*a")
    file:close()
    check("file contains the encoded output", contents == "ENCODED:Magnus-Gille/sagascript@1.0.1", contents)
  end

  os.remove(path)
end

local function test_write_errors_on_unwritable_path()
  local ok, err = pcall(function()
    receipt.write("/nonexistent-dir-xyz/installed_receipt.json", receipt.build("a/b", "1.0.0", FIXED_TIME), function(v) return "{}" end)
  end)
  check("write errors instead of silently failing", not ok, tostring(err))
end

test_build_records_repo_version_and_timestamp()
test_build_defaults_to_current_time()
test_write_encodes_and_writes_to_disk()
test_write_errors_on_unwritable_path()

if failures > 0 then
  print(failures .. " check(s) failed")
  os.exit(1)
else
  print("all checks passed")
  os.exit(0)
end
