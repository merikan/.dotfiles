-- line/block comments
-- https://github.com/numToStr/Comment.nvim

local M = { 
  "numToStr/Comment.nvim"
  }


function M.config()

  require("Comment").setup()
  local comment_ft = require "Comment.ft"
  comment_ft.set("lua", { "--%s", "--[[%s]]" })

end

return M
