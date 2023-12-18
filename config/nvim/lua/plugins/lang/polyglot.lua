-- one plugin to accomodate many different filetypes
return {
    'sheerun/vim-polyglot',
    -- couldn't figure out how to work this with lazy loading option yet
    lazy = false,
    init = function()
      -- turn off sensible as I don't agree with it - https://github.com/sheerun/vim-polyglot/tree/master#default-settings
      vim.g.polyglot_disabled = { 'sensible' }
    end,
}
