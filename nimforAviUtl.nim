import macros
import strutils

macro makeAviUtlfunc*(funcname, filename: untyped, body: untyped): untyped =
  # Extract the function name and validate it matches the expected funcname
  let providedFuncName = body[0][0]
  if $providedFuncName != $funcname:
    error("Function name in definition must match the first argument to makeAviUtlfunc", providedFuncName)
  
  # Convert function name and filename to strings
  let 
    funcNameStr = $funcname
    fileNameStr = $filename
  
  # Create the emit code with replaced values
  var emitCode = """
static luaL_Reg functions[] = {
    {"$1", $1},
    {nullptr, nullptr}
};

extern "C" {
    __declspec(dllexport) int luaopen_$2(lua_State* L) {
        luaL_register(L, "$2", functions);
        return 1;
    }
}
"""
  emitCode = emitCode.replace("$1", funcNameStr)
  emitCode = emitCode.replace("$2", fileNameStr)
  
  # Create the emit statement
  let emitStmt = nnkPragma.newTree(
    nnkExprColonExpr.newTree(
      newIdentNode("emit"),
      newLit(emitCode)
    )
  )
  
  # Return the function definition followed by the emit statement
  result = newStmtList(body, emitStmt)