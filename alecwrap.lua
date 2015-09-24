-- Copyright 2015 Paul Kulchenko, ZeroBrane LLC
-- LuaJIT/FFI wrapper for Arcade Learning Environment (ALE)

local ffi = require 'ffi'
ffi.cdef([[
  typedef struct ALEInterface ALEInterface;
  
  ALEInterface *ALE_new();
  void ALE_del(ALEInterface *ale);
  const char *getString(ALEInterface *ale, const char *key);
  int getInt(ALEInterface *ale,const char *key);
  bool getBool(ALEInterface *ale,const char *key);
  float getFloat(ALEInterface *ale,const char *key);
  void setString(ALEInterface *ale,const char *key,const char *value);
  void setInt(ALEInterface *ale,const char *key,int value);
  void setBool(ALEInterface *ale,const char *key,bool value);
  void setFloat(ALEInterface *ale,const char *key,float value);
  void loadROM(ALEInterface *ale,const char *rom_file);
  int act(ALEInterface *ale,int action);
  bool game_over(ALEInterface *ale);
  void reset_game(ALEInterface *ale);
  void getLegalActionSet(ALEInterface *ale,int *actions);
  int getLegalActionSize(ALEInterface *ale);
  void getMinimalActionSet(ALEInterface *ale,int *actions);
  int getMinimalActionSize(ALEInterface *ale);
  int getFrameNumber(ALEInterface *ale);
  int lives(ALEInterface *ale);
  int getEpisodeFrameNumber(ALEInterface *ale);
  void getScreen(ALEInterface *ale,unsigned char *screen_data);
  void getRAM(ALEInterface *ale,unsigned char *ram);
  int getRAMSize(ALEInterface *ale);
  int getScreenWidth(ALEInterface *ale);
  int getScreenHeight(ALEInterface *ale);
  void getScreenRGB(ALEInterface *ale, unsigned char *screen_data);
  void saveState(ALEInterface *ale);
  void loadState(ALEInterface *ale);
  void saveScreenPNG(ALEInterface *ale,const char *filename);
]])

local ale = ffi.load('libale_c')
local aleint = ale.ALE_new()
local M = {obj = ffi.gc(aleint, function() ale.ALE_del(aleint) end)}
function M.new(rom)
  ale.loadROM(M.obj, rom)
  return M
end
function M:getScreenWidth() return ale.getScreenWidth(self.obj) end
function M:getScreenHeight() return ale.getScreenHeight(self.obj) end
function M:getFrameNumber() return ale.getFrameNumber(self.obj) end
function M:getEpisodeFrameNumber() return ale.getEpisodeFrameNumber(self.obj) end
function M:isGameOver() return ale.game_over(self.obj) end
function M:getLives() return ale.lives(self.obj) end
function M:saveState() return ale.saveState(self.obj) end
function M:loadState() return ale.loadState(self.obj) end
function M:resetGame() return ale.reset_game(self.obj) end
function M:act(action) return ale.act(self.obj, action) end
function M:getLegalActionSize() return ale.getLegalActionSize(self.obj) end
function M:getLegalActionSet()
  local actionlist = ffi.new("int[?]", self:getLegalActionSize())
  ale.getLegalActionSet(self.obj, actionlist)
  return actionlist
end
function M:getMinimalActionSize() return ale.getMinimalActionSize(self.obj) end
function M:getMinimalActionSet()
  local actionlist = ffi.new("int[?]", self:getMinimalActionSize())
  ale.getMinimalActionSet(self.obj, actionlist)
  return actionlist
end
function M:getScreenRGB(asstring)
  if not self.screengrb then
    self.screenrgb = ffi.new("unsigned char[?]",
      self:getScreenWidth() * self:getScreenHeight() * 3)
  end
  ale.getScreenRGB(self.obj, self.screenrgb)
  return (asstring and ffi.string(self.screenrgb, 
      self:getScreenWidth() * self:getScreenHeight() * 3)
    or self.screenrgb)
end

return M
