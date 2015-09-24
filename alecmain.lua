-- Copyright 2015 Paul Kulchenko, ZeroBrane LLC
-- test script for LuaJIT/FFI wrapper for Arcade Learning Environment (ALE)

return {
  run = function(rom, callback)
    local alecwrap = require 'alecwrap'
    local ale = alecwrap.new(rom)
    local width, height = ale:getScreenWidth(), ale:getScreenHeight()

    local wx = require 'wx'
    local image = wx.wxImage(width, height, true)
    local function init()
      local frame = wx.wxFrame(wx.NULL, wx.wxID_ANY, "ALE",
        wx.wxDefaultPosition, wx.wxSize(width, height),
        wx.wxFRAME_TOOL_WINDOW + wx.wxSTAY_ON_TOP
      )
      frame:SetClientSize(width, height)
      frame:Centre()

      local function OnPaint()
        local dc = wx.wxPaintDC(frame)
        dc:DrawBitmap(wx.wxBitmap(image), 0, 0, true)
        dc:delete()
      end

      frame:Connect(wx.wxEVT_ERASE_BACKGROUND, function () end)
      frame:Connect(wx.wxEVT_PAINT, OnPaint)
      frame:Show(true)
      return frame
    end
    local frame = init()
    local ffi = require 'ffi'
    local function display(screen)
      -- SetData expects a Lua string instead of cdata type, so need to convert
      image:SetData(type(screen) == 'cdata' and ffi.string(screen, width * height * 3) or screen)
      frame:Update()
      frame:Refresh()
      wx.wxSafeYield()
      -- wx.wxMilliSleep(10) --<-- uncomment to run slower
    end

    local actionset = ale:getMinimalActionSet()
    local action, reward, screen
    while true do
      if callback then
        action, screen = callback(reward, actionset, ale)
      else
        action = actionset[math.random(#actionset)]
        screen = ale:getScreenRGB()
      end
      if screen then display(screen) end
      if ale:isGameOver() and not callback then break end
      if not action then break end
      reward = ale:act(action)
    end
  end
}
