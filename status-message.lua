-- local drawing = hs.drawing
-- local geometry = hs.geometry
-- local screen = require "hs.screen"
-- local styledtext = require "hs.styledtext"

local statusmessage = {}
statusmessage.new = function(messageText)
  local buildParts = function(messageText)
    local frame = hs.screen.primaryScreen():frame()

    local styledTextAttributes = {
      font = {name = "Monaco", size = 24},
      color = {hex = "#ebddb2"}
    }

    local styledText = hs.styledtext.new("🔨 " .. messageText, styledTextAttributes)

    local styledTextSize = hs.drawing.getTextDrawingSize(styledText)
    local textRect = {
      x = frame.w - styledTextSize.w - 40,
      y = frame.h - styledTextSize.h,
      w = styledTextSize.w + 40,
      h = styledTextSize.h + 40
    }
    local text = hs.drawing.text(textRect, styledText):setAlpha(0.8)

    local background =
      hs.drawing.rectangle(
      {
        x = frame.w - styledTextSize.w - 45,
        y = frame.h - styledTextSize.h - 3,
        w = styledTextSize.w + 15,
        h = styledTextSize.h + 6
      }
    )
    background:setRoundedRectRadii(10, 10)
    background:setFillColor({red = 0, green = 0, blue = 0, alpha = 0.6})

    return background, text
  end

  return {
    _buildParts = buildParts,
    show = function(self)
      self:hide()

      self.background, self.text = self._buildParts(messageText)
      self.background:show()
      self.text:show()
    end,
    hide = function(self)
      if self.background then
        self.background:delete()
        self.background = nil
      end
      if self.text then
        self.text:delete()
        self.text = nil
      end
    end,
    notify = function(self, seconds)
      seconds = seconds or 1
      self:show()
      hs.timer.delayed.new(
        seconds,
        function()
          self:hide()
        end
      ):start()
    end
  }
end

return statusmessage
