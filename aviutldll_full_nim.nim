import luanim/luanim_full

# 処理
proc test_func(L:ref lua_State):cint {.cdecl, exportc.} =
  var num1 = lua_tonumber(L, 1)
  var num2 = lua_tonumber(L, 2)
  lua_pushinteger(L, lua_Integer(num1 + num2))
  return 1

# 残りのC++コードをemitで埋め込む
{.emit: """
static luaL_Reg functions[] = {
	{"test_func", test_func},
	{ nullptr, nullptr }
};
extern "C" {
__declspec(dllexport) int luaopen_aviutldll(lua_State* L) {
    static const luaL_Reg functions[] = {
        {"test_func", test_func},
        { nullptr, nullptr }
    };
    luaL_register(L, "aviutldll", functions);
    return 1;
}
}""".}

#[コンパイルオプション
nim cpp aviutldll.nim

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