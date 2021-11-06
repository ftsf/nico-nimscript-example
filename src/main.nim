import std/[options, os, times]
import nico

import nimscripter
import nimscripter/expose
import compiler/nimeval
import compiler / options as copts

exportTo(nico,
  setColor,
  line,
  circ,
  circfill,
  rect,
  rectfill,
  box,
  boxfill,
  pset,
  pget,
  cls,
  pbtn,
  pbtnp,
  btn,
  btnp,
  sin,
  cos,
  print,
  printc,
  printr,
  spr,
)

var
  intr: Option[Interpreter]
  lastModified: Time

const
  fileName = "assets/example.nims"
  scriptProcs = implNimscriptModule(nico)
  stdlib = findNimStdlibCompileTime()

var hasError = false
var errorInfo: TLineInfo
var errorMsg: string

proc nicoErrorHook*(config: ConfigRef, info: TLineInfo, msg: string, severity: Severity) {.gcsafe.} =
  echo "error hook called"
  if severity == Error and config.error_counter >= config.error_max:
    echo "Script error: ", info, " ", msg
    hasError = true
    errorInfo = info
    errorMsg = msg
    raise (ref VMQuit)(info: info, msg: msg)

when defined(emscripten):
  proc reload*(script: cstring): cint {.exportc,cdecl.} =
    let saves =
      if intr.isSome:
        intr.get.saveState()
      else:
        @[]

    hasError = false
    intr = loadScript(NimScriptFile($script), scriptProcs, modules = ["nicoscript"], stdPath = "assets/lib", vmErrorHook = nicoErrorHook)

    if intr.isSome:
      intr.get.loadState(saves)

    #if intr.isSome:
    #  intr.get.invoke(init)

    return 0

proc gameInit() =
  when defined(emscripten):
    hasError = false
    intr = loadScript(NimScriptPath(fileName), scriptProcs, modules = ["nicoscript"], stdPath = "assets/lib", vmErrorHook = nicoErrorHook)

  if intr.isSome:
    intr.get.invoke(init)

proc gameUpdate(dt: float32) =
  when not defined(emscripten):
    if fileExists(fileName):
      if lastModified < getLastModificationTime(fileName):
        let saves =
          if intr.isSome:
            intr.get.saveState()
          else:
            @[]

        hasError = false
        intr = loadScript(NimScriptPath(fileName), scriptProcs, modules = ["nicoscript"], stdPath = stdlib, vmErrorHook = nicoErrorHook)
        lastModified = getLastModificationTime(fileName)

        if intr.isSome:
          intr.get.loadState(saves)

  if intr.isSome:
    intr.get.invoke(update, dt)

proc gameDraw() =
  if intr.isSome:
    intr.get.invoke(draw)

  if hasError:
    setColor(8)
    boxfill(0,0,screenWidth, 10)
    setColor(7)
    print($errorInfo & ": " & $errorMsg, 2, 2)

nico.init("nico","test")
nico.createWindow("nico", 128, 128, 4, false)
nico.run(gameInit, gameUpdate, gameDraw)
