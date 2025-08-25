import luanim/lua
import nimforAviUtl

# Define a function that adds two numbers
makeAviUtlfunc(add_numbers, luanim_test):
  # Complete procedure definition including L parameter
  proc add_numbers(L: ptr lua_State): cint {.cdecl, exportc.} =
    let 
      num1 = lua_tonumber(L, 1)
      num2 = lua_tonumber(L, 2)
    
    lua_pushinteger(L, lua_Integer(num1 + num2))
    return 1

#[コンパイルオプション
nim cpp luanim_test.nim

nim.cfgに
#Compiler = Visual Studio(x86)
cc = vcc
cpu = "i386"
#dll option
--app: lib
--nomain
#Option for compiler
passC = "/LD"
passL = "lua51.lib"
#memory
--mm:orc
]#

#[
lua 5.1
https://www.lua.org/home.html
]#