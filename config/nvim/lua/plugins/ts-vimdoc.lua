local M = {
  "ibhagwan/ts-vimdoc.nvim",
  dependencies = { "nvim-treesitter" },
}

M.init = function()
  vim.api.nvim_create_user_command("DocgenREADME",
    function()
      local docgen = require("ts-vimdoc")
      local cwd = vim.loop.cwd()
      vim.notify("cwd is " .. cwd)
      local input_file = cwd .. "/README.md"
      local project_name = vim.fn.fnamemodify(cwd, ":t:r")
      if not vim.loop.fs_stat(input_file) then
        vim.notify(input_file .. " is inaccessible")
        return
      end
      if not vim.loop.fs_stat("doc") then
        vim.fn.mkdir("doc", "p")
      end
      local opts = {
        project_name = project_name,
        input_file   = input_file,
        output_file  = ("%s/doc/%s.txt"):format(cwd, project_name),
        version      = "For Neovim >= 0.8.0",
        -- handlers          = { ["html_block"] = false },
        -- header_count_lvl  = 1,
      }
      docgen.docgen(opts)
      vim.notify("Successfully generated " .. opts.output_file)
    end,
    { nargs = "*" }
  )
end

return M
