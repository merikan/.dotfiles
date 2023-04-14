-- colorscheme to use
-- local colorscheme = "base16-gruvbox-dark-medium"
local colorscheme = "darcula"

-- set colorscheme
vim.api.nvim_cmd({cmd='colorscheme', args={colorscheme}}, {})

-- load custom settings for selected color scheme if available
local scheme = prequire("user.colorscheme." .. colorscheme)
if scheme then
  scheme.setup()
end

