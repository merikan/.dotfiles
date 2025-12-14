-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local wk = require("which-key")
local lazy = require("lazy")

-- paste without yank
map("v", "p", '"_dP', { desc = "Paste without yank" })
-- delete char without yanking
map({ "n", "v" }, "x", '"_x', { desc = "Delete char without yank" })
map({ "n", "v" }, "X", '"_X', { desc = "Delete char without yank" })
-- reselect pasted text
map("n", "gp", "[v`]", { desc = "Reselect pasted text" })
-- duplicate line(s) with Alt+d
map("i", "<A-d>", "<Esc>yypi", { desc = "Duplicate line(s)" })
map("n", "<A-d>", "<Esc>yyp", { desc = "Duplicate line(s)" })
map("v", "<A-d>", "oYPgv<Esc>gv=gv", { desc = "Duplicate line(s)" })
-- move line(s) with Alt+Shift+jk
map("n", "<A-S-j>", ":m .+1<CR>==", { desc = "Move line(s) down" })
map("n", "<A-S-k>", ":m .-2<CR>==", { desc = "Move line(s) up" })
map("i", "<A-S-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move line(s) down" })
map("i", "<A-S-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move line(s) up" })
map("v", "<A-S-j>", ":m '>+1<CR>gv=gv", { desc = "Move line(s) down" })
map("v", "<A-S-k>", ":m '<-2<CR>gv=gv", { desc = "Move line(s) up" })

-- Save without formatting
map("n", "<A-s>", "<cmd>noautocmd w<CR>", { desc = "Save without formatting" })
-- write with sudo
map("c", "w!!", "<esc>:lua require'utils'.sudo_write()<CR>", { silent = true })
-- use lazygit for git file history
-- stylua: ignore
map("n", "<leader>gf", function() Snacks.lazygit.log_file() end, { desc = "Lazygit Current File History" })

-- buffers
-- stylua: ignore
map("n", "<leader>ba", function() Snacks.bufdelete.all() end, {desc = "Delete all buffers"})

-- other
map("n", "<leader>gf", function() Snacks.lazygit.log_file() end, { desc = "Lazygit Current File History" })
--------------------------------------------------------------------------------
-- Plugins
--------------------------------------------------------------------------------
-- tmux-navigator
if vim.env.TMUX ~= nil then
  map("n", "<C-h>", ":NvimTmuxNavigateLeft<CR>", { desc = "Go to left window (tmux-aware)", remap = true })
  map("n", "<C-j>", ":NvimTmuxNavigateDown<CR>", { desc = "Go to lower window (tmux-aware)", remap = true })
  map("n", "<C-k>", ":NvimTmuxNavigateUp<CR>", { desc = "Go to upper window (tmux-aware)", remap = true })
  map("n", "<C-l>", ":NvimTmuxNavigateRight<CR>", { desc = "Go to right window (tmux-aware)", remap = true })
end

-- Lazyvim menu
wk.add {
  -- stylua: ignore start
  { "<leader>$", group = "Lazyvim Settings" },
  { "<leader>$c", function() LazyVim.news.changelog() end, desc = "LazyVim Changelog" },
  { "<leader>$C", function() lazy.check() end, desc = "Lazy Check" },
  { "<leader>$d", function() vim.fn.system({ "open", "https://lazyvim.org" }) end,  desc = "LazyVim Docs" },
  { "<leader>$l", "<cmd>Lazy<cr>", desc = "Lazy plugins" },
  { "<leader>$L", "<cmd>LspInfo<CR>", desc = "Lsp Info" },
  { "<leader>$M", vim.cmd.messages, desc = "Display messages" },
  { "<leader>$p", "<cmd>Mason<CR>", desc = "Package Manager - [Mason]" },
  { "<leader>$r", function() vim.fn.system({ "open", "https://github.com/LazyVim/LazyVim" }) end, desc = "LazyVim Repo" },
  { "<leader>$s", function() lazy.sync() end, desc = "Lazy Sync" },
  { "<leader>$u", function() lazy.update() end, desc = "Lazy Update" },
  { "<leader>$x", "<cmd>LazyExtras<cr>", desc = "Extras" },
  -- stylua: ignore end
}

-- Coding Info
local linters = function()
  local linters_attached = require("lint").linters_by_ft[vim.bo.filetype]
  local buf_linters = {}
  if not linters_attached then
    vim.notify("No linters attached", vim.log.levels.WARN, { title = "Linter" })
    return
  end
  for _, linter in pairs(linters_attached) do
    table.insert(buf_linters, linter)
  end
  local unique_client_names = table.concat(buf_linters, ", ")
  local linters = string.format("%s", unique_client_names)
  vim.notify(linters, vim.log.levels.INFO, { title = "Linter" })
end
wk.add {
  -- stylua: ignore start
  { "<leader>c?", group = "Information" },
  { "<leader>c?f", "<cmd>LazyFormatInfo<cr>", desc = "Formatting" },
  { "<leader>c?c", "<cmd>ConformInfo<cr>", desc = "Conform" },
  { "<leader>c?l", linters, desc = "Linter(s)" },
  { "<leader>c?L", "<cmd>LspInfo<CR>", desc = "Lsp Info" },
  }

-- k9s
if vim.fn.executable("k9s") == 1 then
  vim.keymap.set("n", "<leader>k9", function()
    Snacks.terminal("k9s")
  end, { desc = "K9s (kubernetes)" })
end--------------------------------------------------------------------------------
-- TUI applications
--------------------------------------------------------------------------------

-- make command+v (paste) work in Neovide
if vim.g.neovide then
  vim.g.neovide_input_use_logo = 1
  map("", "<D-v>", "+p<CR>")
  map("!", "<D-v>", "<C-R>+")
  map("t", "<D-v>", "<C-R>+")
  map("n", "N", "Nzzzv") --  previous
  map("n", "<C-u>", "<C-u>zz") -- halfpage up
  map("v", "<D-v>", "<C-R>+")
end
