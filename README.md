# Project Description

A LuaJIT/FFI wrapper for the [Arcade Learning Environment](http://www.arcadelearningenvironment.org/).

There is another Lua wrapper ([alewrap](https://github.com/fidlej/alewrap)), but it requires a separate build step with its own dynamic library and has a slightly different API.

## Usage

```lua
local alecwrap = require 'alecwrap'
local ale = alecwrap.new("roms/breakout.bin")
local reward = ale:act(ale:getLegalActionSet()[0])
print(reward, ale:getFrameNumber(), ale:isGameOver(), "\n")
```

## Installation

* Download or clone [ALE repository](https://github.com/mgbellemare/Arcade-Learning-Environment) and build ALE using the following commands (if you are building on Windows using mingw, add `-G "MSYS Makefiles"` to the cmake command):

```
cmake -E make_directory build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make
``` 

* Copy `build/libale_c` dynamic library to your project directory (`libale_c.dll` v0.5.0 compiled for 32bit Windows is already included).
* Copy `alecwrap.lua` file to your project directory or make it available to your script so that it's loaded with `require` command.

## Running example script using ZeroBrane Studio

* Download and install [ZeroBrane Studio](http://studio.zerobrane.com/).
* Launch ZeroBrane Studio and load the example by using the following command:

```
zbstudio alecwrap-directory alectest.lua
```

* Run the example using `Project | Run` menu command.

## Author

Paul Kulchenko (paul@kulchenko.com)

## License

See LICENSE file.

The license doesn't apply to ROM files (in the `roms` directory), which are only included for educational purposes.
