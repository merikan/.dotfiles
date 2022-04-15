local ts_utils = require "nvim-treesitter.ts_utils"

local M = {}

function M.buf_autocmd_document_highlight()
    vim.api.nvim_exec(
    [[
      augroup lsp_document_highlight
          autocmd! * <buffer>
          autocmd CursorHold,CursorHoldI <buffer> call v:lua.my_document_highlight()
          autocmd CursorMoved,CursorMovedI <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
        false
    )
end

function _G.my_document_highlight()
    local node = ts_utils.get_node_at_cursor()
    while node ~= nil do
        local node_type = node:type()
        if
            node_type == "string"
            or node_type == "string_fragment"
            or node_type == "template_string"
            or node_type == "document" -- for inline gql`` strings
        then
            -- who wants to highlight a string? i don't. yuck
            return
        end
        node = node:parent()
    end
    vim.lsp.buf.document_highlight()
end

_G.lsp_popup_opts = {
    show_header = false,
}

-- @param bufnr (number)
function M.buf_set_keymaps(bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    local opts = { noremap = true, silent = true }
    -- See `:help vim.lsp.*` for documentation on any of the below functions

    -- Code actions
    buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
    buf_set_keymap("n", "<leader>ga", "<cmd>lua require'user.plugins.telescope.lsp'.code_actions()<CR>", opts)
    buf_set_keymap("v", "<leader>ga", "<cmd><C-U>lua require'plugins.telescope.lsp'.range_code_actions()<CR>", opts)
    buf_set_keymap('n', '<leader>F', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    buf_set_keymap('v', '<leader>F', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

    -- Movement
    buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    buf_set_keymap("n", "gd", "<cmd>lua require'user.plugins.telescope.lsp'.definitions()<CR>", opts)
    buf_set_keymap("n", "gr", "<cmd>lua require'user.plugins.telescope.lsp'.references()<CR>", opts)
    buf_set_keymap("n", "gI", "<cmd>lua require'user.plugins.telescope.lsp'.implementations()<CR>", opts)
    buf_set_keymap("n", "<leader>s", "<cmd>lua require'plugins.telescope.lsp'.document_symbols()<CR>", opts)

    -- Docs
    buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    buf_set_keymap("n", "<C-t>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    buf_set_keymap("i", "<C-t>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)

    -- Diagnostics
    buf_set_keymap("n", "<leader>d", "<cmd>Telescope diagnostics bufnr=0<cr>", opts)
    buf_set_keymap("n", "<leader>dl", "<cmd>lua require'plugins.lsp.diagnostics'.show_line_diagnostics()<CR>", opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap("n", "[e", "<cmd>lua require'plugins.lsp.diagnostics'.goto_prev({ severity_limit = 'Error' })<CR>", opts)
    buf_set_keymap("v", "[e", "<cmd>lua require'plugins.lsp.diagnostics'.goto_prev({ severity_limit = 'Error' })<CR>", opts)
    buf_set_keymap("n", "]e", "<cmd>lua require'plugins.lsp.diagnostics'.goto_next({ severity_limit = 'Error' })<CR>", opts)
    buf_set_keymap("v", "]e", "<cmd>lua require'plugins.lsp.diagnostics'.goto_next({ severity_limit = 'Error' })<CR>", opts)
    buf_set_keymap("n", "[E", "<cmd>lua require'plugins.lsp.diagnostics'.goto_prev()<CR>", opts)
    buf_set_keymap("v", "[E", "<cmd>lua require'plugins.lsp.diagnostics'.goto_prev()<CR>", opts)
    buf_set_keymap("n", "]E", "<cmd>lua require'plugins.lsp.diagnostics'.goto_next()<CR>", opts)
    buf_set_keymap("v", "]E", "<cmd>lua require'plugins.lsp.diagnostics'.goto_next()<CR>", opts)
end

return M
