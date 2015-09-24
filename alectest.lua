-- Copyright 2015 Paul Kulchenko, ZeroBrane LLC
-- test script for LuaJIT/FFI wrapper for Arcade Learning Environment (ALE)

local alec = require "alecmain"
alec.run("roms/breakout.bin", function(reward, actionset, ale)
    -- get random action from the legal set
    local action = actionset[math.random(#actionset)]
    if ale:isGameOver() then
      io.write(("frame: %d (%d); action: %d; reward: %d; lives: %d\n")
        :format(ale:getEpisodeFrameNumber(), ale:getFrameNumber(), action, reward, ale:getLives()))

      local fname = ("screen%d.png"):format(ale:getFrameNumber())
      -- image:SaveFile(fname) --<-- uncomment to save png file
      -- ale:saveScreenPNG(fname) --<-- uncomment to save 2x width png file

      ale:resetGame()
      -- return --<-- uncomment this line to exit after one game
    end

    return actionset[math.random(#actionset)], ale:getScreenRGB()
  end)
