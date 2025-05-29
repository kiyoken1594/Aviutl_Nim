#include "include/lua.hpp"

int test_func(lua_State* L){
   int num1 = lua_tonumber(L, 1);    //スタックの一番下から値を取得
   int num2 = lua_tonumber(L, 2);    //スタックの下から2番目の値を取得

   lua_pushinteger( L, num1+num2 );    //スタックに計算結果をプッシュ
   return 1;    //スタックからLuaに渡す返り値の数
}

static luaL_Reg functions[] = {
	{"test_func", test_func},
	{ nullptr, nullptr }
};

extern "C" {
	__declspec(dllexport) int luaopen_aviutl(lua_State* L) {
		luaL_register(L, "aviutl", functions);
		return 1;
	}
}

//cl aviutl.cpp /LD lua51.lib