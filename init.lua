local log = hs.logger.new("init.lua", "debug")

-- Use Control+` to reload Hammerspoon config
hs.hotkey.bind(
  {"ctrl", "alt"},
  "'",
  nil,
  function()
    hs.reload()
  end
)
local config_path = os.getenv("HOME") .. "/.hammerspoon/"
local function reloadConfig(files)
  local doReload = false
  for _, file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    hs.reload()
  end
end

MyWatcher = hs.pathwatcher.new(config_path, reloadConfig):start()
hs.alert.show("Hammerspoon Config loaded")

---@param modifiers table "'ctrl', 'fn', 'alt', 'cmd', 'shift'"
---@param key string
---@param delay? number time in ms
KeyUpDown = function(modifiers, key, delay)
  delay = delay or 0

  -- Un-comment & reload config to log each keystroke that we're triggering
  log.d("Sending keystroke:", hs.inspect(modifiers), key)

  hs.eventtap.keyStroke(modifiers, key, delay)
end

-- Subscribe to the necessary events on the given window filter such that the
-- given hotkey is enabled for windows that match the window filter and disabled
-- for windows that don't match the window filter.
--
-- windowFilter - An hs.window.filter object describing the windows for which
--                the hotkey should be enabled.
-- hotkey       - The hs.hotkey object to enable/disable.
--
-- Returns nothing.
enableHotkeyForWindowsMatchingFilter = function(windowFilter, hotkey)
  windowFilter:subscribe(
    hs.window.filter.windowFocused,
    function()
      hotkey:enable()
    end
  )

  windowFilter:subscribe(
    hs.window.filter.windowUnfocused,
    function()
      hotkey:disable()
    end
  )
end

Sigils = require("WindowSigils")

---Focus the window with x sigil
---@param window hs.window()
local focus_window = function(window)
  window:focus()
  -- Sigils:refresh()
end

Sigils:configure(
  {
    hotkeys = {
      enter = {{"control"}, "W"}
    },
    sigil_actions = {
      [{}] = focus_window
      --     [{"ctrl"}] = swap_window,
      --     [{"alt"}] = warp_window
    }
  }
)
Sigils:start()

require("hyper")
require("microphone")
require("windows")
-- require("caffeine")
-- require("markdown")

-- https://www.hammerspoon.org/docs/hs.console.html#darkMode
hs.console.darkMode(true)
if hs.console.darkMode() then
  hs.console.outputBackgroundColor {white = 0}
  hs.console.consoleCommandColor {white = 1}
  hs.console.alpha(.9)
end

hs.notify.new({title = "Hammerspoon", informativeText = "Ready to rock 🤘"}):send()
