-- Lockfile suppport for mason.nvim
-- https://github.com/zapling/mason-lock.nvim
return {
  "williamboman/mason.nvim",
  dependencies = {
    "zapling/mason-lock.nvim",
    commit = "5cb1be532b12d586ee001a9a07aa900fcb090e1c",
    cmd = { "MasonLock", "MasonLockRestore" },
    opts = {},
  },
}
