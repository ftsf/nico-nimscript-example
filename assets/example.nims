#import nicoscript

var x* = 64
var y* = 64

proc init*() =
  discard

proc update*(dt: float32) =
  if pbtn(pcLeft, 0):
    x -= 1
  if pbtn(pcRight, 0):
    x += 1
  if pbtn(pcUp, 0):
    y -= 1
  if pbtn(pcDown, 0):
    y += 1

proc draw*()=
  cls()
  setColor(1)
  boxfill(x-10,y-10,20,20)
  setColor(7)
  printc("test", x, y - 3)
