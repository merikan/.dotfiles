-- Plain-lua tests for lib/appdir.lua. Run with: lua tests/appdir_test.lua
-- Uses a real shell-backed "cmd" mock (mirrors mise's cmd.exec semantics:
-- returns stdout, raises an error on non-zero exit) so test -L, cp -R,
-- etc. behave exactly as they do inside mise. All operations run inside a
-- throwaway tmp dir, never touching the real /Applications.
--
-- encode/decode are tiny fakes (not real JSON) since appdir.lua only cares
-- that decode(content).repo/.version round-trip whatever encode wrote -
-- lib/receipt.lua and its own tests cover the real JSON shape.

local script_dir = arg[0]:match("(.*/)") or "./"
package.path = script_dir .. "../lib/?.lua;" .. package.path
local appdir = require("appdir")

local cmd = {}
function cmd.exec(command)
  local handle = io.popen(command .. "; echo EXIT:$?")
  local output = handle:read("*a")
  handle:close()
  local body, exit_code = output:match("^(.*)EXIT:(%d+)\n?$")
  exit_code = tonumber(exit_code)
  if exit_code ~= 0 then
    error("Command failed with status exit status: " .. exit_code .. ": ")
  end
  return body
end

local function encode(t)
  return "repo=" .. t.repo .. "\nversion=" .. t.version
end

local function decode(s)
  local repo = s:match("repo=([^\n]*)")
  local version = s:match("version=([^\n]*)")
  return { repo = repo, version = version }
end

local failures = 0

local function check(name, condition, detail)
  if condition then
    print("ok - " .. name)
  else
    failures = failures + 1
    print("NOT OK - " .. name .. (detail and (": " .. detail) or ""))
  end
end

local function mktemp_dir()
  return cmd.exec("mktemp -d"):gsub("%s+$", "")
end

local function rm(dir)
  os.execute("rm -rf " .. dir)
end

local function file_exists(path)
  local f = io.open(path, "r")
  if f then
    f:close()
    return true
  end
  return false
end

-- Scenario 1: nothing at the target yet -> fresh copy + receipt written.
local function test_fresh_install_copies_app()
  local root = mktemp_dir()
  local install_path = root .. "/install/1.0.0"
  local apps_dir = root .. "/Applications"
  os.execute("mkdir -p " .. install_path .. "/Foo.app")
  os.execute("echo v1 > " .. install_path .. "/Foo.app/marker.txt")
  os.execute("mkdir -p " .. apps_dir)

  local status = appdir.sync(cmd, encode, decode, install_path .. "/Foo.app", "acme/foo", "1.0.0", apps_dir)

  check("fresh install returns installed", status == "installed", tostring(status))
  local is_symlink = cmd.exec("test -L " .. apps_dir .. "/Foo.app && echo yes || echo no"):gsub("%s+$", "")
  check("copy is a real directory, not a symlink", is_symlink == "no")
  local marker = io.open(apps_dir .. "/Foo.app/marker.txt", "r")
  check("app contents were actually copied", marker ~= nil and marker:read("*a") == "v1\n")
  if marker then marker:close() end
  local receipt = io.open(apps_dir .. "/Foo.app.installed_receipt.json", "r")
  check("receipt was written", receipt ~= nil)
  if receipt then receipt:close() end

  rm(root)
end

-- Scenario 2: a real app already at the target with no receipt -> not
-- installed by mise, must be left completely untouched.
local function test_real_conflict_is_left_untouched()
  local root = mktemp_dir()
  local install_path = root .. "/install/1.0.0"
  local apps_dir = root .. "/Applications"
  os.execute("mkdir -p " .. install_path .. "/Foo.app")
  os.execute("mkdir -p " .. apps_dir .. "/Foo.app")
  os.execute("echo not-mise > " .. apps_dir .. "/Foo.app/marker.txt")

  local status, reason = appdir.sync(cmd, encode, decode, install_path .. "/Foo.app", "acme/foo", "1.0.0", apps_dir)

  check("real conflict returns skipped", status == "skipped", tostring(status))
  check("reason mentions no receipt", reason and reason:find("was not installed by mise") ~= nil, reason)
  local marker = io.open(apps_dir .. "/Foo.app/marker.txt", "r")
  check("existing app content untouched", marker ~= nil and marker:read("*a") == "not-mise\n")
  if marker then marker:close() end
  check("no receipt file was created", not file_exists(apps_dir .. "/Foo.app.installed_receipt.json"))

  rm(root)
end

-- Scenario 3: target already has a receipt for a different version (mise
-- installed it before) -> safe to replace with the new version.
local function test_receipted_target_is_replaced_on_version_change()
  local root = mktemp_dir()
  local old_install = root .. "/install/1.0.0"
  local new_install = root .. "/install/2.0.0"
  local apps_dir = root .. "/Applications"
  os.execute("mkdir -p " .. old_install .. "/Foo.app")
  os.execute("mkdir -p " .. new_install .. "/Foo.app")
  os.execute("echo v2 > " .. new_install .. "/Foo.app/marker.txt")
  os.execute("mkdir -p " .. apps_dir .. "/Foo.app")
  os.execute("echo v1 > " .. apps_dir .. "/Foo.app/marker.txt")
  local f = io.open(apps_dir .. "/Foo.app.installed_receipt.json", "w")
  f:write(encode({ repo = "acme/foo", version = "1.0.0" }))
  f:close()

  local status = appdir.sync(cmd, encode, decode, new_install .. "/Foo.app", "acme/foo", "2.0.0", apps_dir)

  check("version change returns installed", status == "installed", tostring(status))
  local marker = io.open(apps_dir .. "/Foo.app/marker.txt", "r")
  check("app content replaced with new version", marker ~= nil and marker:read("*a") == "v2\n")
  if marker then marker:close() end
  local receipt = io.open(apps_dir .. "/Foo.app.installed_receipt.json", "r")
  check("receipt rewritten", receipt ~= nil and receipt:read("*a"):find("version=2.0.0", 1, true) ~= nil)
  if receipt then receipt:close() end

  rm(root)
end

-- Scenario 4 (the fast path this whole redesign is for): the receipt
-- already matches repo+version exactly -> no shell-outs, no copy, just a
-- cheap file read. Proven by pointing app_path at a directory that doesn't
-- even exist - if sync() tried to cp -R it, cmd.exec would raise.
local function test_matching_receipt_is_a_pure_noop()
  local root = mktemp_dir()
  local apps_dir = root .. "/Applications"
  os.execute("mkdir -p " .. apps_dir .. "/Foo.app")
  os.execute("echo already-synced > " .. apps_dir .. "/Foo.app/marker.txt")
  local f = io.open(apps_dir .. "/Foo.app.installed_receipt.json", "w")
  f:write(encode({ repo = "acme/foo", version = "1.0.0" }))
  f:close()

  local nonexistent_app_path = root .. "/does-not-exist/Foo.app"
  local status = appdir.sync(cmd, encode, decode, nonexistent_app_path, "acme/foo", "1.0.0", apps_dir)

  check("matching receipt returns up-to-date", status == "up-to-date", tostring(status))
  local marker = io.open(apps_dir .. "/Foo.app/marker.txt", "r")
  check("existing copy left untouched", marker ~= nil and marker:read("*a") == "already-synced\n")
  if marker then marker:close() end

  rm(root)
end

-- Edge case: a dangling symlink at the target (e.g. left behind by an old
-- version of this plugin that used to symlink) still counts as "occupied"
-- even though `test -e` alone would say it doesn't exist.
local function test_dangling_symlink_without_receipt_is_left_untouched()
  local root = mktemp_dir()
  local install_path = root .. "/install/1.0.0"
  local apps_dir = root .. "/Applications"
  os.execute("mkdir -p " .. install_path .. "/Foo.app")
  os.execute("mkdir -p " .. apps_dir)
  os.execute("ln -s " .. root .. "/nonexistent-target " .. apps_dir .. "/Foo.app")

  local status = appdir.sync(cmd, encode, decode, install_path .. "/Foo.app", "acme/foo", "1.0.0", apps_dir)

  check("dangling unmanaged symlink returns skipped", status == "skipped", tostring(status))
  local is_symlink = cmd.exec("test -L " .. apps_dir .. "/Foo.app && echo yes || echo no"):gsub("%s+$", "")
  check("dangling symlink left in place", is_symlink == "yes")

  rm(root)
end

test_fresh_install_copies_app()
test_real_conflict_is_left_untouched()
test_receipted_target_is_replaced_on_version_change()
test_matching_receipt_is_a_pure_noop()
test_dangling_symlink_without_receipt_is_left_untouched()

if failures > 0 then
  print(failures .. " check(s) failed")
  os.exit(1)
else
  print("all checks passed")
  os.exit(0)
end
