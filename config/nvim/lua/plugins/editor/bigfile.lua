return {
  {
    "LunarVim/bigfile.nvim",
    event = "BufReadPre",
    opts = {
      pattern = function(bufnr, filesize_mib)
        if filesize_mib > 2 then
          return true
        end
        local file_lines = vim.fn.readfile(vim.api.nvim_buf_get_name(bufnr))
        if #file_lines > 5000 then
          return true
        end
        for _, line in ipairs(file_lines) do
          if #line > 1000 then
            return true
          end
        end
      end,
    },
  },
}
