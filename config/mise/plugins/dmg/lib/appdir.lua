-- Keeps an installed .app bundle synced into an "Applications" directory,
-- like Homebrew Cask, guarded by a sibling installed_receipt.json so mise
-- never clobbers an app it didn't put there itself.
--
-- Called from backend_exec_env (which runs on every `mise use`/shell
-- activation, not just fresh installs) so it must be cheap in the common
-- case: if the receipt already matches repo+version, sync() returns
-- "up-to-date" after a single file read - no shelling out, no copying.
local receipt = require("receipt")

local M = {}

-- cmd: the vfox "cmd" module (must expose cmd.exec(shell_command) -> stdout,
--      raising an error on non-zero exit).
-- encode/decode: json.encode/json.decode-compatible functions (injected so
--      this is testable without the host "json" module).
-- app_path: absolute path to the extracted .app bundle (inside mise's own
--      install directory - this is never modified).
-- apps_dir: directory to sync into (defaults to "/Applications").
--
-- Returns "up-to-date" if the target already matches repo+version,
-- "installed" if it was (re)copied and a fresh receipt written, or
-- "skipped", reason if an existing, unmanaged target was left untouched.
function M.sync(cmd, encode, decode, app_path, repo, version, apps_dir)
  apps_dir = apps_dir or "/Applications"
  local app_name = app_path:match("([^/]+)$")
  local target = apps_dir .. "/" .. app_name
  local receipt_path = target .. ".installed_receipt.json"

  local receipt_content = nil
  local receipt_file = io.open(receipt_path, "r")
  if receipt_file then
    receipt_content = receipt_file:read("*a")
    receipt_file:close()
  end

  if receipt_content then
    local ok, existing = pcall(decode, receipt_content)
    if ok and existing and existing.repo == repo and existing.version == version then
      return "up-to-date"
    end
  end

  -- Check -L (symlink, even if dangling) or -e (exists, follows symlinks) -
  -- either means something already occupies the target.
  local is_symlink = cmd.exec(string.format("test -L %s && echo yes || echo no", target)):gsub("%s+$", "")
  local exists = cmd.exec(string.format("test -e %s && echo yes || echo no", target)):gsub("%s+$", "")
  local occupied = (is_symlink == "yes") or (exists == "yes")

  if occupied and not receipt_content then
    return "skipped", target .. " already exists and was not installed by mise (no " .. receipt_path .. ") - leaving it untouched. Remove or move it manually if you want mise to manage it."
  end

  cmd.exec(string.format("rm -rf %s", target))
  cmd.exec(string.format("cp -R %s %s", app_path, target))
  receipt.write(receipt_path, receipt.build(repo, version), encode)

  return "installed"
end

return M
