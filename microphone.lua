-- local hs = hs
local message = require("status-message")

local messageMuting = message.new("Microphone is muted 🎤")
local messageHot = message.new("Microphone is hot 🎤")
local lastMods = {}
local recentlyClicked = false
local secondClick = false

local displayStatus = function()
  -- Check if the active mic is muted
  if hs.audiodevice.defaultInputDevice():muted() then
    messageMuting:notify()
  else
    messageHot:notify()
  end
end
-- displayStatus()

local toggle = function(device)
  if device:muted() then
    device:setMuted(false)
  else
    device:setMuted(true)
  end
end

local fnKeyHandler = function()
  recentlyClicked = false
end

local controlKeyTimer = hs.timer.delayed.new(0.3, fnKeyHandler)

local fnHandler = function(event)
  local device = hs.audiodevice.defaultInputDevice()
  local newMods = event:getFlags()

  -- fn keyDown
  if newMods["fn"] == true then
    -- fn keyUp
    toggle(device)
    if recentlyClicked == true then
      displayStatus()
      secondClick = true
    end
    recentlyClicked = true
    controlKeyTimer:start()
  elseif lastMods["fn"] == true and newMods["fn"] == nil then
    if secondClick then
      secondClick = false
    else
      toggle(device)
    end
  end

  lastMods = newMods
end

fnKey = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, fnHandler)
fnKey:start()
