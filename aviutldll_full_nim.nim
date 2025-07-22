import luanim/luanim_full
import macros
import strutils

# 処理
proc test_func(L:ref lua_State):cint {.cdecl, exportc.} =
  var num1 = lua_tonumber(L, 1)
  var num2 = lua_tonumber(L, 2)
  lua_pushinteger(L, lua_Integer(num1 + num2))
  return 1
#登録
const
  functions: array[2, luaL_Reg] = [
    luaL_Reg(name: "test_func", `func`: test_func),
    luaL_Reg(name: nil, `func`: nil)
  ]

macro exportLuaFunction*(moduleName: string, functionName: string): untyped =
  let cCode = """
extern "C" {
  __declspec(dllexport) int luaopen_$1(lua_State* L) {
    static const luaL_Reg functions[] = {
      {"$2", $2},
      { nullptr, nullptr }
    };
    luaL_register(L, "$1", functions);
    return 1;
  }
}
""".replace("$1", moduleName.strVal).replace("$2", functionName.strVal)
  
  result = nnkStmtList.newTree(
    nnkPragma.newTree(
      nnkExprColonExpr.newTree(
        newIdentNode("emit"),
        newLit(cCode)
      )
    )
  )
#モジュール&関数名登録
exportLuaFunction("aviutldll_full_nim", "test_func")

#[コンパイルオプション
nim cpp aviutldll_full_nim.nim

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