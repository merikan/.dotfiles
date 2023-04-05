local M = {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects", -- Text objects
		"windwp/nvim-ts-autotag", -- Closing < tags
		"JoosepAlviste/nvim-ts-context-commentstring", -- context-aware commenting
		"nvim-treesitter/playground",
	},
}

function M.config()
	require("nvim-treesitter.configs").setup({
		-- A list of parser names, or "all"
		ensure_installed = { "c", "lua", "rust" },
		-- ensure_installed = "all",

		-- Install parsers synchronously (only applied to `ensure_installed`)
		sync_install = false,

		-- Automatically install missing parsers when entering buffer
		auto_install = true,

		-- List of parsers to ignore installing (for "all")
		ignore_install = { "phpdoc" },

		---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
		-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
		textobjects = {
			move = {
				enable = true,
				set_jumps = true,
				goto_next_start = {
					["]m"] = "@function.outer",
					["]]"] = "@parameter.inner",
				},
				goto_previous_start = {
					["[M"] = "@function.outer",
					["[["] = "@parameter.inner",
				},
				goto_next_end = {
					["]M"] = "@function.outer",
					["]["] = "@class.outer",
				},
				goto_previous_end = {
					["[M"] = "@function.outer",
					["[]"] = "@class.outer",
				},
			},
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
					["iq"] = "@parameter.inner",
					["aq"] = "@parameter.outer",
				},
			},
		},

		highlight = {
			-- `false` will disable the whole extension
			enable = true,

			-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
			-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
			-- the name of the parser)
			-- list of language that will be disabled
			-- disable = { "c" },

			-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
			-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
			-- Using this option may slow down your editor, and you may see some duplicate highlights.
			-- Instead of true it can also be a list of languages
			additional_vim_regex_highlighting = false,
		},
		playground = {
			enable = false,
			disable = {},
			updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
			persist_queries = false, -- Whether the query persists across vim sessions
			keybindings = {
				toggle_query_editor = "o",
				toggle_hl_groups = "i",
				toggle_injected_languages = "t",
				toggle_anonymous_nodes = "a",
				toggle_language_display = "I",
				focus_language = "f",
				unfocus_language = "F",
				update = "R",
				goto_node = "<cr>",
				show_help = "?",
			},
		},
		indent = {
			enable = true,
		},
		autotag = {
			enable = true,
		},

		-- matchup = {
		--   enable = true, -- mandatory, false will disable the whole extension
		--   disable = { "c", "ruby" }, -- optional, list of language that will be disabled
		--   -- [options]
		-- },

		context_commentstring = {
			enable = true,
			enable_autocmd = false,
			javascript = {
				__default = "// %s",
				jsx_element = "{/* %s */}",
				jsx_fragment = "{/* %s */}",
				jsx_attribute = "// %s",
				comment = "// %s",
			},
		},
	})
end

return M

