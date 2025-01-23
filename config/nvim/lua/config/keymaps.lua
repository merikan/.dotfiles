-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set by LazyVim:
-- see (1) https://www.lazyvim.org/keymaps
--     (2) https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
--     (3) ~/.local/share/nvim/lazy/LazyVim/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set
local wk = require("which-key")
local lazy = require("lazy")

-- My additional keymaps

-- Previous end of word
map("n", "E", "ge", { desc = "Previous end of word" })
-- make Y behave like C and D
map("n", "Y", "y$", { desc = "Yank to end of line" })
-- paste without yank
map("v", "p", '"_dP', { desc = "Paste without yank" })
-- delete without yanking
map({ "n", "x" }, "<leader>d", '"_d', { desc = "Delete without yank" })
-- delete char without yanking
map({ "n", "v" }, "x", '"_x', { desc = "Delete char without yank" })
map({ "n", "v" }, "X", '"_X', { desc = "Delete char without yank" })
-- reselect pasted text
map("n", "gp", "[v`]", { desc = "Reselect pasted text" })

-- keep current line centered when jumping
map("n", "n", "nzzzv", { desc = "Next search result" })
map("n", "<C-d>", "<C-d>zz", { desc = "Halfpage down" })
map("n", "<C-u>", "<C-u>zz", { desc = "Halfpage up" })
-- keep cursor in position when joining
map({ "n", "v" }, "J", "mzJ`z", { desc = "Join lines and keep position" })
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

-- make gx work again
if vim.fn.has('macunix') == 1 then
  map("n", "gx", "<cmd>silent execute '!open ' . shellescape('<cWORD>')<CR>", { silent = true })
else
  map("n", "gx", "<cmd>silent execute '!xdg-open ' . shellescape('<cWORD>')<CR>", { silent = true })
end

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

-- show open buffers
-- stylua: ignore
map( "n", "<leader>bb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true initial_mode=normal<cr>", { desc = "List open buffers" })

-- Disable LazyVim bindings
map("n", "<leader>l", "<Nop>")
map("n", "<leader>L", "<Nop>")
-- Lazyvim menu
wk.add {
  -- stylua: ignore start
  { "<leader>l", group = "Lazyvim Settings" },
  { "<leader>lc", function() LazyVim.news.changelog() end, desc = "LazyVim Changelog" },
  { "<leader>lC", function() lazy.check() end, desc = "Lazy Check" },
  { "<leader>ld", function() vim.fn.system({ "open", "https://lazyvim.org" }) end,  desc = "LazyVim Docs" },
  { "<leader>ll", "<cmd>Lazy<cr>", desc = "Lazy plugins" },
  { "<leader>lL", "<cmd>LspInfo<CR>", desc = "Lsp Info" },
  { "<leader>lM", vim.cmd.messages, desc = "Display messages" },
  { "<leader>lp", "<cmd>Mason<CR>", desc = "Package Manager - [Mason]" },
  { "<leader>lr", function() vim.fn.system({ "open", "https://github.com/LazyVim/LazyVim" }) end, desc = "LazyVim Repo" },
  { "<leader>ls", function() lazy.sync() end, desc = "Lazy Sync" },
  { "<leader>lu", function() lazy.update() end, desc = "Lazy Update" },
  { "<leader>lx", "<cmd>LazyExtras<cr>", desc = "Extras" },
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
  { "<leader>c?l", linters, desc = "Linter" },
  { "<leader>c?L", "<cmd>LspInfo<CR>", desc = "Lsp Info" },
  }

--------------------------------------------------------------------------------
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

-- ====================================================
--  map     : root of all recursive mappings
--  noremap : no recursive map
--  {m}{nore}map
--
--  Mode letters:
--    n: normal only
--    v: visual and select
--    o: operator-pending
--    x: visual only
--    s: select only
--    i: insert
--    c: command-line
--    t: terminal window
--    l: insert, command-line, regexp-search (and others. Collectively called "Lang-Arg" pseudo-mode)
