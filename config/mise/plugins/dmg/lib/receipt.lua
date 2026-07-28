-- Writes installed_receipt.json into an install directory, similar to
-- Homebrew's per-keg INSTALL_RECEIPT.json, so it's possible to tell if and
-- what version of a tool mise installed here.
local M = {}

-- now: unix timestamp (defaults to os.time()); accepted as a parameter so
-- tests can produce deterministic output.
function M.build(repo, version, now)
  now = now or os.time()
  return {
    repo = repo,
    version = version,
    installed_at = os.date("!%Y-%m-%dT%H:%M:%SZ", now),
  }
end

-- encode: a json.encode-compatible function (injected so this is testable
-- without the host "json" module).
function M.write(path, receipt, encode)
  local file, open_err = io.open(path, "w")
  if not file then
    error("Failed to open " .. path .. " for writing: " .. tostring(open_err))
  end
  file:write(encode(receipt))
  file:close()
end

return M
