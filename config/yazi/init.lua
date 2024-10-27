
-- Plugins
require("zoxide"):setup({
	update_db = true,
})

require("session"):setup({
	sync_yanked = true,
})

require("git"):setup()
