import Foundation

var stdout = Output.standard

stdout.write(ControlSequence.clearScreen)
stdout.write(AlternativeBuffer.on.control)
stdout.write(CursorVisibility.off.control)

var canvas = Canvas(cursor: Cursor())

let d = Pixel("d", bold: .on)
let a = Pixel("a", italic: .on)
let n = Pixel("n", underline: .on)
let i = Pixel("i", blinking: .on)
let e = Pixel("e", inverse: .on)
let l = Pixel("l", strikethrough: .on)

canvas.draw(d, at: Position(x: 1, y: 1))
canvas.draw(a, at: Position(x: 2, y: 1))
canvas.draw(n, at: Position(x: 3, y: 1))
canvas.draw(i, at: Position(x: 4, y: 1))
canvas.draw(e, at: Position(x: 5, y: 1))
canvas.draw(l, at: Position(x: 6, y: 1))
