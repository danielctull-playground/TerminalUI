
var canvas = Canvas(cursor: Cursor())


let d = Pixel(content: "d", foreground: .red, background: .yellow)
let a = Pixel(content: "a", foreground: .white, background: .magenta)
let n = Pixel(content: "n", foreground: .green, background: .yellow)
let i = Pixel(content: "i", foreground: .default, background: .default)
let e = Pixel(content: "e", foreground: .red, background: .yellow)
let l = Pixel(content: "l", foreground: .red, background: .yellow)

canvas.draw(d, at: Position(x: 1, y: 1))
canvas.draw(a, at: Position(x: 2, y: 1))
canvas.draw(n, at: Position(x: 3, y: 1))
canvas.draw(i, at: Position(x: 4, y: 1))
canvas.draw(e, at: Position(x: 5, y: 1))
canvas.draw(l, at: Position(x: 6, y: 1))
