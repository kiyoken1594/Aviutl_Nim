# ==========================================
# Lua C API Bindings for Nim (FFI)
# For Lua 5.1: lua.h, lauxlib.h, lualib.h, luaconf.h
# All definitions are grouped and commented by original C header file.
# Using `ptr` as pointer type for FFI, and escape variable named `ptr` with backticks.
# ==========================================

{.push header:"include/lua.hpp".}

when not defined(lua_h):
  {.emit: "#define lua_h".}
when not defined(lualib_h):
  {.emit: "#define lualib_h".}
when not defined(lauxlib_h):
  {.emit: "#define lauxlib_h".}
when not defined(luaconf_h):
  {.emit: "#define luaconf_h".}

{.emit: """
#include <stdarg.h>
#include <stddef.h>
#include "include/luaconf.h"
#include "include/lauxlib.h"
#include "include/lualib.h"
""" .}

# ==========================================
# == SECTION: luaconf.h (Configuration Macros)
# ==========================================
const
  LUAL_BUFFERSIZE* = 1024

# ==========================================
# == SECTION: lua.h (Core API)
# ==========================================

const
  LUA_VERSION* = "Lua 5.1"
  LUA_RELEASE* = "Lua 5.1.4"
  LUA_VERSION_NUM* = 501
  LUA_COPYRIGHT* = "Copyright (C) 1994-2008 Lua.org, PUC-Rio"
  LUA_AUTHORS* = "R. Ierusalimschy, L. H. de Figueiredo & W. Celes"
  LUA_SIGNATURE* = "\x1BLua"
  LUA_MULTRET* = -1
  LUA_REGISTRYINDEX* = -10000
  LUA_ENVIRONINDEX* = -10001
  LUA_GLOBALSINDEX* = -10002
  LUA_YIELD* = 1
  LUA_ERRRUN* = 2
  LUA_ERRSYNTAX* = 3
  LUA_ERRMEM* = 4
  LUA_ERRERR* = 5
  LUA_TNONE* = -1
  LUA_TNIL* = 0
  LUA_TBOOLEAN* = 1
  LUA_TLIGHTUSERDATA* = 2
  LUA_TNUMBER* = 3
  LUA_TSTRING* = 4
  LUA_TTABLE* = 5
  LUA_TFUNCTION* = 6
  LUA_TUSERDATA* = 7
  LUA_TTHREAD* = 8
  LUA_MINSTACK* = 20
  LUA_ERRFILE* = LUA_ERRERR + 1
  LUA_NOREF* = -2
  LUA_REFNIL* = -1
  LUA_FILEHANDLE* = "FILE*"

template lua_upvalueindex*(i: cint): cint =
  LUA_GLOBALSINDEX - i

type
  lua_Number* = cdouble
  LUA_NUMBER* = lua_Number
  lua_Integer* = cint
  LUA_INTEGER* = lua_Integer
  lua_State* {.importc, incompleteStruct.} = object
  lua_Alloc* = proc (ud: pointer, `ptr`: pointer, osize: csize_t, nsize: csize_t): pointer {.cdecl.}
  lua_CFunction* = proc (L: ptr lua_State): cint {.cdecl.}
  lua_Reader* = proc (L: ptr lua_State, ud: pointer, sz: ptr csize_t): cstring  {.cdecl.}
  lua_Writer* = proc (L: ptr lua_State, p: pointer, sz: csize_t, ud: pointer): cint {.cdecl.}

proc lua_newstate*(f: lua_Alloc, ud: pointer): ptr lua_State {.importc.}
proc lua_close*(L: ptr lua_State): void {.importc.}
proc lua_newthread*(L: ptr lua_State): ptr lua_State {.importc.}
proc lua_atpanic*(L: ptr lua_State, panicf: lua_CFunction): lua_CFunction {.importc.}

proc lua_gettop*(L: ptr lua_State): cint {.importc.}
proc lua_settop*(L: ptr lua_State, idx: cint): void {.importc.}
proc lua_pushvalue*(L: ptr lua_State, idx: cint): void {.importc.}
proc lua_remove*(L: ptr lua_State, idx: cint): void {.importc.}
proc lua_insert*(L: ptr lua_State, idx: cint): void {.importc.}
proc lua_replace*(L: ptr lua_State, idx: cint): void {.importc.}
proc lua_checkstack*(L: ptr lua_State, sz: cint): cint {.importc.}
proc lua_xmove*(`from`: ptr lua_State, to: ptr lua_State, n: cint): void {.importc.}

proc lua_type*(L: ptr lua_State, idx: cint): cint {.importc.}
proc lua_typename*(L: ptr lua_State, tp: cint): cstring {.importc.}
proc lua_tonumber*(L: ptr lua_State, idx: cint): lua_Number {.importc.}
proc lua_tointeger*(L: ptr lua_State, idx: cint): lua_Integer {.importc.}
proc lua_toboolean*(L: ptr lua_State, idx: cint): cint {.importc.}
proc lua_tolstring*(L: ptr lua_State, idx: cint, len: ptr csize_t): cstring {.importc.}
proc lua_touserdata*(L: ptr lua_State, idx: cint): pointer {.importc.}
proc lua_tothread*(L: ptr lua_State, idx: cint): ptr lua_State {.importc.}
proc lua_topointer*(L: ptr lua_State, idx: cint): pointer {.importc.}

proc lua_pushnil*(L: ptr lua_State): void {.importc.}
proc lua_pushnumber*(L: ptr lua_State, n: lua_Number): void {.importc.}
proc lua_pushinteger*(L: ptr lua_State, n: lua_Integer): void {.importc.}
proc lua_pushlstring*(L: ptr lua_State, s: cstring, len: csize_t): void {.importc.}
proc lua_pushstring*(L: ptr lua_State, s: cstring): void {.importc.}
proc lua_pushcclosure*(L: ptr lua_State, fn: lua_CFunction, n: cint): void {.importc.}
proc lua_pushboolean*(L: ptr lua_State, b: cint): void {.importc.}
proc lua_pushlightuserdata*(L: ptr lua_State, p: pointer): void {.importc.}

proc lua_gettable*(L: ptr lua_State, idx: cint): void {.importc.}
proc lua_getfield*(L: ptr lua_State, idx: cint, k: cstring): void {.importc.}
proc lua_rawget*(L: ptr lua_State, idx: cint): void {.importc.}
proc lua_rawgeti*(L: ptr lua_State, idx: cint, n: cint): void {.importc.}
proc lua_createtable*(L: ptr lua_State, narr, nrec: cint): void {.importc.}
proc lua_settable*(L: ptr lua_State, idx: cint): void {.importc.}
proc lua_setfield*(L: ptr lua_State, idx: cint, k: cstring): void {.importc.}
proc lua_rawset*(L: ptr lua_State, idx: cint): void {.importc.}
proc lua_rawseti*(L: ptr lua_State, idx, n: cint): void {.importc.}
proc lua_setmetatable*(L: ptr lua_State, objindex: cint): void {.importc.}
proc lua_getmetatable*(L: ptr lua_State, objindex: cint): cint {.importc.}

proc lua_equal*(L: ptr lua_State, idx1, idx2: cint): cint {.importc.}
proc lua_rawequal*(L: ptr lua_State, idx1, idx2: cint): cint {.importc.}
proc lua_lessthan*(L: ptr lua_State, idx1, idx2: cint): cint {.importc.}

proc lua_concat*(L: ptr lua_State, n: cint): void {.importc.}
proc lua_next*(L: ptr lua_State, idx: cint): cint {.importc.}
proc lua_error*(L: ptr lua_State): cint {.importc.}

proc lua_call*(L: ptr lua_State, nargs, nresults: cint): void {.importc.}
proc lua_pcall*(L: ptr lua_State, nargs, nresults, errfunc: cint): cint {.importc.}
proc lua_cpcall*(L: ptr lua_State, `func`: lua_CFunction, ud: pointer): cint {.importc.}
proc lua_load*(L: ptr lua_State, reader: lua_Reader, dt: pointer, chunkname: cstring): cint {.importc.}
proc lua_dump*(L: ptr lua_State, writer: lua_Writer, data: pointer): cint {.importc.}

proc lua_gc*(L: ptr lua_State, what, data: cint): cint {.importc.}
proc lua_getallocf*(L: ptr lua_State, ud: ptr pointer): lua_Alloc {.importc.}
proc lua_setallocf*(L: ptr lua_State, f: lua_Alloc, ud: pointer): void {.importc.}

proc lua_yield*(L: ptr lua_State, nresults: cint): cint {.importc.}
proc lua_resume*(L: ptr lua_State, narg: cint): cint {.importc.}
proc lua_status*(L: ptr lua_State): cint {.importc.}

proc lua_ref*(L: ptr lua_State, lock: cint): cint {.importc.}
proc lua_unref*(L: ptr lua_State, `ref`: cint): void {.importc.}
proc lua_getref*(L: ptr lua_State, `ref`: cint): void {.importc.}

# --- Debug API (lua.h) ---
const
  LUA_HOOKCALL* = 0
  LUA_HOOKRET* = 1
  LUA_HOOKLINE* = 2
  LUA_HOOKCOUNT* = 3
  LUA_HOOKTAILRET* = 4
  LUA_IDSIZE* = 60

type
  lua_Debug* = object
    event*: cint
    name*: cstring
    namewhat*: cstring
    what*: cstring
    source*: cstring
    currentline*: cint
    nups*: cint
    linedefined*: cint
    lastlinedefined*: cint
    short_src*: array[LUA_IDSIZE, char]
    i_ci*: cint

  lua_Hook* = proc (L: ptr lua_State, ar: ptr lua_Debug) {.cdecl.}

proc lua_getstack*(L: ptr lua_State, level: cint, ar: ptr lua_Debug): cint {.importc.}
proc lua_getinfo*(L: ptr lua_State, what: cstring, ar: ptr lua_Debug): cint {.importc.}
proc lua_getlocal*(L: ptr lua_State, ar: ptr lua_Debug, n: cint): cstring {.importc.}
proc lua_setlocal*(L: ptr lua_State, ar: ptr lua_Debug, n: cint): cstring {.importc.}
proc lua_getupvalue*(L: ptr lua_State, funcindex, n: cint): cstring {.importc.}
proc lua_setupvalue*(L: ptr lua_State, funcindex, n: cint): cstring {.importc.}
proc lua_sethook*(L: ptr lua_State, f: lua_Hook, mask: cint, count: cint): cint {.importc.}
proc lua_gethook*(L: ptr lua_State): lua_Hook {.importc.}
proc lua_gethookmask*(L: ptr lua_State): cint {.importc.}
proc lua_gethookcount*(L: ptr lua_State): cint {.importc.}

# ==========================================
# == SECTION: lualib.h (Standard Libraries, LUALIB_API)
# ==========================================

const
  LUA_COLIBNAME* = "coroutine"
  LUA_TABLIBNAME* = "table"
  LUA_IOLIBNAME* = "io"
  LUA_OSLIBNAME* = "os"
  LUA_STRLIBNAME* = "string"
  LUA_MATHLIBNAME* = "math"
  LUA_DBLIBNAME* = "debug"
  LUA_LOADLIBNAME* = "package"

proc luaopen_base*(L: ptr lua_State): cint {.importc.}
proc luaopen_table*(L: ptr lua_State): cint {.importc.}
proc luaopen_io*(L: ptr lua_State): cint {.importc.}
proc luaopen_os*(L: ptr lua_State): cint {.importc.}
proc luaopen_string*(L: ptr lua_State): cint {.importc.}
proc luaopen_math*(L: ptr lua_State): cint {.importc.}
proc luaopen_debug*(L: ptr lua_State): cint {.importc.}
proc luaopen_package*(L: ptr lua_State): cint {.importc.}
proc luaL_openlibs*(L: ptr lua_State): void {.importc.}

# ==========================================
# == SECTION: lauxlib.h (Auxiliary Library, LUALIB_API)
# ==========================================

type
  luaL_Reg* = object
    name*: cstring
    `func`*: lua_CFunction
  luaL_Buffer* = object
    p*: cstring
    lvl*: cint
    L*: ptr lua_State
    buffer*: array[LUAL_BUFFERSIZE, char]

proc luaI_openlib*(L: ptr lua_State, libname: cstring, l: ptr luaL_Reg, nup: cint): ptr lua_State {.importc.}
proc luaL_register*(L: ptr lua_State, libname: cstring, l: ptr luaL_Reg): ptr lua_State {.importc.}
proc luaL_getmetafield*(L: ptr lua_State, obj: cint, e: cstring): cint {.importc.}
proc luaL_callmeta*(L: ptr lua_State, obj: cint, e: cstring): cint {.importc.}
proc luaL_typerror*(L: ptr lua_State, narg: cint, tname: cstring): cint {.importc.}
proc luaL_argerror*(L: ptr lua_State, numarg: cint, extramsg: cstring): cint {.importc.}
proc luaL_checklstring*(L: ptr lua_State, numArg: cint, l: ptr csize_t): cstring {.importc.}
proc luaL_optlstring*(L: ptr lua_State, numArg: cint, def: cstring, l: ptr csize_t): cstring {.importc.}
proc luaL_checknumber*(L: ptr lua_State, numArg: cint): lua_Number {.importc.}
proc luaL_optnumber*(L: ptr lua_State, nArg: cint, def: lua_Number): lua_Number {.importc.}
proc luaL_checkinteger*(L: ptr lua_State, numArg: cint): lua_Integer {.importc.}
proc luaL_optinteger*(L: ptr lua_State, nArg: cint, def: lua_Integer): lua_Integer {.importc.}
proc luaL_checkstack*(L: ptr lua_State, sz: cint, msg: cstring): void {.importc.}
proc luaL_checktype*(L: ptr lua_State, narg: cint, t: cint): void {.importc.}
proc luaL_checkany*(L: ptr lua_State, narg: cint): void {.importc.}
proc luaL_newmetatable*(L: ptr lua_State, tname: cstring): cint {.importc.}
proc luaL_checkudata*(L: ptr lua_State, ud: cint, tname: cstring): pointer {.importc.}
proc luaL_where*(L: ptr lua_State, lvl: cint): void {.importc.}
proc luaL_error*(L: ptr lua_State, fmt: cstring): cint {.varargs, importc.}
proc luaL_checkoption*(L: ptr lua_State, narg: cint, def: cstring, lst: ptr cstring): cint {.importc.}
proc luaL_ref*(L: ptr lua_State, t: cint): cint {.importc.}
proc luaL_unref*(L: ptr lua_State, t: cint, `ref`: cint): void {.importc.}
proc luaL_loadfile*(L: ptr lua_State, filename: cstring): cint {.importc.}
proc luaL_loadbuffer*(L: ptr lua_State, buff: cstring, sz: csize_t, name: cstring): cint {.importc.}
proc luaL_loadstring*(L: ptr lua_State, s: cstring): cint {.importc.}
proc luaL_newstate*(): ptr lua_State {.importc.}
proc luaL_gsub*(L: ptr lua_State, s, p, r: cstring): cstring {.importc.}
proc luaL_findtable*(L: ptr lua_State, idx: cint, fname: cstring, szhint: cint): cstring {.importc.}

proc luaL_buffinit*(L: ptr lua_State, B: ptr luaL_Buffer): void {.importc.}
proc luaL_prepbuffer*(B: ptr luaL_Buffer): cstring {.importc.}
proc luaL_addlstring*(B: ptr luaL_Buffer, s: cstring, l: csize_t): void {.importc.}
proc luaL_addstring*(B: ptr luaL_Buffer, s: cstring): void {.importc.}
proc luaL_addvalue*(B: ptr luaL_Buffer): void {.importc.}
proc luaL_pushresult*(B: ptr luaL_Buffer): void {.importc.}
proc luaL_addchar*(B: ptr luaL_Buffer, c: char) {.importc.}
proc luaL_addsize*(B: ptr luaL_Buffer, n: csize_t) {.importc.}

# --- lauxlib.h macros as Nim templates ---
template luaL_getmetatable*(L: ptr lua_State, n: cstring): cint =
  lua_getfield(L, LUA_REGISTRYINDEX, n)

template luaL_opt*(L: ptr lua_State, f: proc(L: ptr lua_State, n: cint): auto, n: cint, d: auto): auto =
  (if lua_isnoneornil(L, n): d else: f(L, n))

template luaL_checkstring*(L: ptr lua_State, n: cint): cstring =
  luaL_checklstring(L, n, nil)

template luaL_optstring*(L: ptr lua_State, n: cint, d: cstring): cstring =
  luaL_optlstring(L, n, d, nil)

template luaL_checkint*(L: ptr lua_State, n: cint): cint =
  luaL_checkinteger(L, n)

template luaL_optint*(L: ptr lua_State, n: cint, d: cint): cint =
  luaL_optinteger(L, n, d)

template luaL_checklong*(L: ptr lua_State, n: cint): clong =
  clong(luaL_checkinteger(L, n))

template luaL_optlong*(L: ptr lua_State, n: cint, d: clong): clong =
  clong(luaL_optinteger(L, n, d))

template luaL_typename*(L: ptr lua_State, i: cint): cstring =
  lua_typename(L, lua_type(L, i))

template luaL_dofile*(L: ptr lua_State, fn: cstring): cint =
  (if luaL_loadfile(L, fn) != 0: 1
   elif lua_pcall(L, 0, LUA_MULTRET, 0) != 0: 1
   else: 0)

template luaL_dostring*(L: ptr lua_State, s: cstring): cint =
  (if luaL_loadstring(L, s) != 0: 1
   elif lua_pcall(L, 0, LUA_MULTRET, 0) != 0: 1
   else: 0)

# ==========================================
# == SECTION: MACRO FUNCTION DEFINITIONS (lua.h)
# ==========================================

template lua_pop*(L: ptr lua_State, n: cint) =
  lua_settop(L, -(n)-1)

template lua_newtable*(L: ptr lua_State) =
  lua_createtable(L, 0, 0)

template lua_isfunction*(L: ptr lua_State, n: cint): bool =
  lua_type(L, n) == LUA_TFUNCTION

template lua_istable*(L: ptr lua_State, n: cint): bool =
  lua_type(L, n) == LUA_TTABLE

template lua_islightuserdata*(L: ptr lua_State, n: cint): bool =
  lua_type(L, n) == LUA_TLIGHTUSERDATA

template lua_isnil*(L: ptr lua_State, n: cint): bool =
  lua_type(L, n) == LUA_TNIL

template lua_isboolean*(L: ptr lua_State, n: cint): bool =
  lua_type(L, n) == LUA_TBOOLEAN

template lua_isthread*(L: ptr lua_State, n: cint): bool =
  lua_type(L, n) == LUA_TTHREAD

template lua_isnoneornil*(L: ptr lua_State, n: cint): bool =
  lua_type(L, n) <= 0

template lua_pushglobaltable*(L: ptr lua_State) =
  lua_rawgeti(L, LUA_GLOBALSINDEX, 0)

{.pop.}

#[
lua 5.1
https://www.lua.org/home.html
]#

# ==========================================
# END OF FILE
# ==========================================