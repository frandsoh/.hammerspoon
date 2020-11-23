local log = hs.logger.new("init.lua", "debug")

-- Use Control+` to reload Hammerspoon config
-- hs.hotkey.bind(
--   {"ctrl"},
--   "`",
--   nil,
--   function()
--     hs.reload()
--   end
-- )

keyUpDown = function(modifiers, key)
  -- Un-comment & reload config to log each keystroke that we're triggering
  log.d("Sending keystroke:", hs.inspect(modifiers), key)

  hs.eventtap.keyStroke(modifiers, key, 0)
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

-- require("control-escape")
-- require("delete-words")
-- require("hyper")
-- require("markdown")
require("microphone")
-- require('keyboard.panes')
require("windows")

caffeine = hs.menubar.new()
function setCaffeineDisplay(state)
  if state then
    caffeine:setTitle("AWAKE")
  else
    caffeine:setTitle("SLEEPY")
  end
end

function caffeineClicked()
  setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
end

if caffeine then
  caffeine:setClickCallback(caffeineClicked)
  setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
end

-- https://www.hammerspoon.org/docs/hs.console.html#darkMode
hs.console.darkMode(true)
if hs.console.darkMode() then
  hs.console.outputBackgroundColor {white = 0}
  hs.console.consoleCommandColor {white = 1}
  hs.console.alpha(.9)
end

hs.notify.new({title = "Hammerspoon", informativeText = "Ready to rock 🤘"}):send()
