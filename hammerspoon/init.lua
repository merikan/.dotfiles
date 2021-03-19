--- ==============================================================================  ---
--- Configuration
--- ==============================================================================  ---
-- load local file
localfile = hs.configdir .. "/init.local.lua"
if hs.fs.attributes(localfile) then
  dofile(localfile)
end

hs.logger.defaultLogLevel="info"
hs.window.animationDuration = 0

hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.use_syncinstall = true
Install=spoon.SpoonInstall


-- key mappings
local hyper = { "ctrl", "alt", "cmd" }
local shift_hyper = { "shift", "ctrl", "alt", "cmd" }

-- show hotkeys
hs.hotkey.showHotkeys(hyper,"s")
-- toggle console
hs.hotkey.bindSpec({ hyper, "y" }, hs.toggleConsole)
-- reload config
hs.hotkey.bindSpec({ hyper, "r" }, hs.reload)

local function moveWindowToDisplay(d)
  return function()
    local displays = hs.screen.allScreens()
    local win = hs.window.focusedWindow()
    win:moveToScreen(displays[d], false, true)
  end
end

hs.hotkey.bind({"ctrl", "alt", "cmd"}, "1", moveWindowToDisplay(1))
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "2", moveWindowToDisplay(2))
hs.hotkey.bind({"ctrl", "alt", "cmd"}, "3", moveWindowToDisplay(3))

--- ==============================================================================  ---
--- Spoons
--- ==============================================================================  ---
hs.loadSpoon("SpoonInstall")
Install = spoon.SpoonInstall -- abbreviation for easier use
Install.use_syncinstall = true -- use sync notifications
-- my personal spoon repository
spoon.SpoonInstall.repos.merikan = {
  url = "https://github.com/merikan/Spoons",
  desc = "my personal spoon repository",
}


-- http://www.hammerspoon.org/Spoons/ReloadConfiguration.html
Install:andUse("ReloadConfiguration", {
  start = true,
  hotkeys = {
    reloadConfiguration = { hyper, "r" }
  },
})

-- http://www.hammerspoon.org/Spoons/WindowGrid.html
Install:andUse("WindowGrid", {
                  disabled = true,
                  start = true,
                  config = {gridGeometries = { { "6x4" } } },
                  hotkeys = {show_grid = { hyper, "g" } },
})

-- -- http://www.hammerspoon.org/Spoons/WindowHalfsAndThirds.html
-- Install:andUse("WindowHalfsAndThirds", 
-- {
--                   disabled = true,
--                   hotkeys = 'default'
-- })

-- http://www.hammerspoon.org/Spoons/MiroWindowsManager.html
Install:andUse("MiroWindowsManager",
                {
                  hotkeys = {
                    left =       { hyper, "h" },
                    down =       { hyper, "j" },
                    up =         { hyper, "k" },
                    right =      { hyper, "l" },
                    fullscreen = { hyper, "u" }
                  }
                }
)




hs.notify.show("Hammerspoon", "Configuration (re)loaded", '')
