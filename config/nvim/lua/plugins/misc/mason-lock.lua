-- Lockfile suppport for mason.nvim
-- https://github.com/zapling/mason-lock.nvim
return {
  "williamboman/mason.nvim",
  dependencies = {
    "zapling/mason-lock.nvim",
    cmd = { "MasonLock", "MasonLockRestore" },
    opts = {},
  },
}
