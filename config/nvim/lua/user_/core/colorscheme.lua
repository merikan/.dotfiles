-- colorscheme to use
-- local colorscheme = "base16-gruvbox-dark-medium"
local colorscheme = "darcula"

-- load custom settings for selected color scheme if available
local scheme = prequire("user.colorschemes." .. colorscheme)
if scheme then
  scheme.setup()
end

-- set colorscheme
vim.api.nvim_cmd({cmd='colorscheme', args={colorscheme}}, {})

