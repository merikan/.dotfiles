-- Lockfile suppport for mason.nvim
-- https://github.com/zapling/mason-lock.nvim
return {
  "mason-org/mason.nvim",
  dependencies = {
    "zapling/mason-lock.nvim",
    cmd = { "MasonLock", "MasonLockRestore" },
    opts = {},
  },
}
