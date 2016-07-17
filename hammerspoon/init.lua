local application = require "hs.application"
local tiling = require "hs.tiling"
local hotkey = require "hs.hotkey"
local Spotify  = require "hs.spotify"

-- TODO: Move more stuff into these
-- custom scripts
local monitors = import('utils/monitors').configured_monitors

require "sizeup"
require "triggers"

-- Defines for screen watcher
local lastNumberOfScreens = #hs.screen.allScreens()

-- Defines for window grid
hs.grid.GRIDWIDTH = 4
hs.grid.GRIDHEIGHT = 4
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0

-- Defines for window maximize toggler
local frameCache = {}

local mash = {"ctrl", "cmd", "alt"}
local mash_app = {"ctrl", "cmd", "alt", "shift"}
local hsmash = {"cmd", "alt", "shift"}

-- Settings
hs.window.animationDuration = 0 -- disable animation

-- Define monitor names for layout purposes
local display_laptop = "Color LCD"
local display_monitor = "Thunderbolt Display"

-- Reload config
function reloadConfig(paths)
  hs.reload()
end

-- functions

-- position a window via layout
function positionFocusedWindow(layout)
    return function() hs.window:focusedWindow():moveToUnit(layout) end
end

-- Toggle a window between its normal size, and being maximized
function toggle_window_maximized()
  local win = hs.window.focusedWindow()
  if frameCache[win:id()] then
    win:setFrame(frameCache[win:id()])
    frameCache[win:id()] = nil
  else
    frameCache[win:id()] = win:frame()
    win:maximize()
  end
end 

-- Toggle an app between frontmost and hidden
function toggle_application(_app)
  local app = hs.application.get(_app)
  if not app then
    -- Something?
    return
  end

  local mainwin = app:mainWindow()
  if mainwin then
    if mainwin == hs.window.focusedWindow() then
      mainwin:application():hide()
    else
      mainwin:application():activate(true)
      mainwin:application():unhide()
      mainwin:focus()
    end
  end
end


-- Tiling
-- hotkey.bind(mash, "c", function() tiling.cyclelayout() end)
--hotkey.bind(mash, "j", function() tiling.cycle(1) end)
--hotkey.bind(mash, "k", function() tiling.cycle(-1) end)
-- hotkey.bind(mash, "space", function() tiling.promote() end)

-- tiling.set('layouts', {
--              'fullscreen', 'main-vertical',
--              'gp-horizontal','gp-vertical'
-- })

-- windows
-- Hotkeys to interact with the window grid
-- hotkey.bind(mash, "g", hs.grid.show)

-- hotkey.bind(mash, "h", hs.grid.pushWindowLeft)
-- hotkey.bind(mash, "l", hs.grid.pushWindowRight)
-- hotkey.bind(mash, "k", hs.grid.pushWindowUp)
-- hotkey.bind(mash, "j", hs.grid.pushWindowDown)

-- -- absolute positioning
-- -- hotkey.bind(mash, 'a', function() hs.window:focusedWindow():moveToUnit(hs.layout.left30) end)
-- hotkey.bind(mash, 'a', positionFocusedWindow(hs.layout.left30))
-- hotkey.bind(mash, 's', positionFocusedWindow(hs.layout.right70))
-- hotkey.bind(mash, 'Left', positionFocusedWindow(hs.layout.left50))
-- hotkey.bind(mash, 'Right', positionFocusedWindow(hs.layout.right50))
-- hotkey.bind(mash, 'm', toggle_window_maximized)
-- hotkey.bind(mash, 'r', function() hs.window:focusedWindow():toggleFullScreen() end)


-- Define window layouts
--   Format reminder:
--     {"App name", "Window name", "Display Name", "unitrect", "framerect", "fullframerect"},
local wff = {
  {"Emacs", nil, display_laptop, hs.layout.left50, nil, nil},
  {"Terminal", nil, display_laptop, hs.geometry.rect(0.5,0.5,0.5,0.5), nil, nil},
}

hotkey.bind(mash_app, 'y', function() hs.layout.apply(wff) end)


-- multi monitor
hotkey.bind(mash, 'N', hs.grid.pushWindowNextScreen)
hotkey.bind(mash, 'P', hs.grid.pushWindowPrevScreen)

-- launching
hotkey.bind(mash, '1', function() application.launchOrFocus('Emacs') end)
hotkey.bind(mash, '2', function() application.launchOrFocus('Chrome') end)
hotkey.bind(mash, '3', function() application.launchOrFocus('Finder') end)

-- music
hotkey.bind(mash, '9', Spotify.play)
hotkey.bind(mash, '0', Spotify.next)
hotkey.bind(mash, '-', Spotify.pause)
hotkey.bind(mash, '=', Spotify.displayCurrentTrack)

-- reload
-- hotkey.bind(hsmash, '.', hs.reload)

-- watcher
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()

hs.notify.new({
    title='Hammerspoon',
    informativeText='Config loaded!'
}):send()
