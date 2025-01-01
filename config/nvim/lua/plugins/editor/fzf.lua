-- override Lazyvim settings
-- https://github.com/ibhagwan/fzf-lua
return {
  "ibhagwan/fzf-lua",
  opts = {
    files = {
      formatter = "path.filename_first", -- file name first
    },
  },
}
