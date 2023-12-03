-- edit markdown tables using treesitter
-- https://github.com/kiran94/edit-markdown-table.nvim
return {
    'kiran94/edit-markdown-table.nvim',
    config = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "EditMarkdownTable",
}
