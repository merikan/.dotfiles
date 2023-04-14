-- debug adapter
--
return {
  "mfussenegger/nvim-dap",                  -- DAP client implementation for Neovim
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",                   -- UI for nvim-dap
      config = function()
        local opts = { floating = { border = "rounded" } }
        local dap, dapui = require "dap", require "dapui"
        dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
        dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
        dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
        dapui.setup(opts)
      end,
    },
    { "theHamsta/nvim-dap-virtual-text" },        -- virtual text support to nvim-dap.
    { "nvim-telescope/telescope-dap.nvim" },      -- telescopte integration with nvim-dap

    --  Adapter configuration for specific languages
    { "leoluz/nvim-dap-go" },                 -- golang
    { "mfussenegger/nvim-dap-python" },       -- python
    { "jbyuki/one-small-step-for-vimkind" },  -- lua
  },
}
