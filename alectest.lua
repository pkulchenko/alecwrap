-- Copyright 2015 Paul Kulchenko, ZeroBrane LLC
-- test script for LuaJIT/FFI wrapper for Arcade Learning Environment (ALE)

local alecwrap = require 'alecwrap'
local ale = alecwrap.new("roms/breakout.bin")
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

local actions = ale:getMinimalActionSize()
local actionset = ale:getMinimalActionSet()
while true do
  local num = math.random(actions) -- get random action from the legal set
  local action = actionset[num-1]
  local reward = ale:act(action)
  local gameover = ale:isGameOver()
  display(ale:getScreenRGB())

  if gameover then
    io.write(("frame: %d (%d); action: %d; reward: %d; lives: %d; %s\n")
      :format(ale:getEpisodeFrameNumber(), ale:getFrameNumber(), action, reward, ale:getLives(), gameover and "done" or ""))

    local fname = ("screen%d.png"):format(ale:getFrameNumber())
    -- image:SaveFile(fname) --<-- uncomment to save png file
    -- ale:saveScreenPNG(fname) --<-- uncomment to save 2x width png file

    ale:resetGame()
    -- break --<-- uncomment to abort the script after one game
  end
end
