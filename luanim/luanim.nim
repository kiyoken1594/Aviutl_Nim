{.push header:"include/lua.hpp".}

when not defined(lua_h):
  {.emit: """
    #define lua_h
  """.}

{.emit: """
#include <stdarg.h>
#include <stddef.h>
#include "include/luaconf.h"
""".}

#define
const
  LUA_VERSION*:cstring = "Lua 5.1"
  LUA_RELEASE*:cstring = "Lua 5.1.4"
  LUA_VERSION_NUM*:cint = 501
  LUA_COPYRIGHT*:cstring = "Copyright (C) 1994-2008 Lua.org, PUC-Rio"
  LUA_AUTHORS*:cstring = "R. Ierusalimschy, L. H. de Figueiredo & W. Celes"

  #mark for precompiled code (`<esc>Lua')
  LUA_SIGNATURE*:cstring = "\x1BLua"

  # option for multiple returns in `lua_pcall' and `lua_call'
  LUA_MULTRET*:cint = -1

  #pseudo-indices
  LUA_REGISTRYINDEX*:cint = -10000
  LUA_ENVIRONINDEX*:cint = -10001
  LUA_GLOBALSINDEX*:cint = -10002

  #thread status; 0 is OK
  LUA_YIELD*:cint = 1
  LUA_ERRRUN*:cint = 2
  LUA_ERRSYNTAX*:cint = 3
  LUA_ERRMEM*:cint = 4
  LUA_ERRERR*:cint = 5

  #basic types
  LUA_TNONE*:cint = -1
  LUA_TNIL*:cint = 0
  LUA_TBOOLEAN*:cint = 1
  LUA_TLIGHTUSERDATA*:cint = 2
  LUA_TNUMBER*:cint = 3
  LUA_TSTRING*:cint = 4
  LUA_TTABLE*:cint = 5
  LUA_TFUNCTION*:cint = 6
  LUA_TUSERDATA*:cint = 7
  LUA_TTHREAD*:cint = 8
  #minimum Lua stack available to a C function
  LUA_MINSTACK*:cint = 20

#pseudo-indices
template lua_upvalueindex*(i:cint):cint =
  LUA_GLOBALSINDEX - i

#generic extra include file
when defined(LUA_USER_H):
  {.emit: """
    #include LUA_USER_H
  """.}

#type of lua
type
  #type of numbers in Lua
  lua_Number* = cdouble
  LUA_NUMBER* = lua_Number
  #type for integer functions
  lua_Integer* = cint
  LUA_INTEGER* = lua_Integer

  lua_State* {.importc.}= object
  lua_CFunction* = proc (L:ptr lua_State):cint

  #functions that read/write blocks when loading/dumping Lua chunks
  lua_Reader* = proc (L:ptr lua_State, ud:pointer, sz:ptr cuint):cstring
  lua_Writer* = proc (L:ptr lua_State, p:pointer, sz: cuint, ud:pointer):cint


  #prototype for memory-allocation functions
  lua_Alloc* = proc (ud:pointer, `ptr`:pointer, osize: cuint, nsize: cuint):pointer


#import api
#state manipulation
proc lua_newstate*(f:lua_Alloc, ud:pointer):ptr lua_State
proc lua_close*(L:ptr lua_State):void
proc lua_newthread*(L:ptr lua_State):ptr lua_State
proc lua_atpanic*(L:ptr lua_State,panicf:lua_CFunction):lua_CFunction

#basic stack manipulation
proc lua_gettop*(L:ptr lua_State):cint
proc lua_settop*(L:ptr lua_State, idx:cint):void
proc lua_pushvalue*(L:ptr lua_State, idx:cint):void
proc lua_remove*(L:ptr lua_State, idx:cint):void
proc lua_insert*(L:ptr lua_State, idx:cint):void
proc lua_replace*(L:ptr lua_State, idx:cint):void
proc lua_checkstack*(L:ptr lua_State, sz:cint):cint
proc lua_xmove*(`from`:ptr lua_State, to:ptr lua_State, n:cint):void

proc lua_tonumber*(L:ptr lua_State, idx:cint):lua_Number
proc lua_pushinteger*(L:ptr lua_State, n:lua_Integer):void

{.pop.}

#[
lua 5.1
https://www.lua.org/home.html
]#