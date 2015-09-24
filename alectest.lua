-- Copyright 2015 Paul Kulchenko, ZeroBrane LLC
-- test script for LuaJIT/FFI wrapper for Arcade Learning Environment (ALE)

local alec = require "alecmain"

local ffi = require "ffi"
local screenold
local function showdiff(reward, screenrgb, ale)
    local screennew = ale:getScreen()
    local width, height = ale:getScreenWidth(), ale:getScreenHeight()
    if reward then
      for y = 0, height-1 do
        for x = 0, width-1 do
          local index = y * width + x
          if screenold[index] == screennew[index] then
            screenrgb[index*3 + 0] = 255
            screenrgb[index*3 + 1] = 255
            screenrgb[index*3 + 2] = 255
          end
        end
      end
    else -- first iteration; do the initialization
      screenold = ffi.new("unsigned char[?]", width * height)
    end
    ffi.copy(screenold, screennew, width * height)
end

alec.run("roms/breakout.bin", function(reward, actionset, ale)
    local screenrgb = ale:getScreenRGB()

    -- showdiff(reward, screenrgb, ale) --<-- uncomment to show frame diff

    -- get random action from the legal set
    local action = actionset[math.random(#actionset)]
    if ale:isGameOver() then
      io.write(("frame: %d (%d); action: %d; reward: %d; lives: %d\n")
        :format(ale:getEpisodeFrameNumber(), ale:getFrameNumber(), action, reward, ale:getLives()))

      local fname = ("screen%d.png"):format(ale:getFrameNumber())
      -- ale:saveScreenPNG(fname) --<-- uncomment to save 2x width png file

      ale:resetGame()
      -- return --<-- uncomment this line to exit after one game
    end

    return actionset[math.random(#actionset)], screenrgb
  end)
