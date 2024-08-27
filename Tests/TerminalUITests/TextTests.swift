@testable import TerminalUI
import Testing

@Suite
struct TextTests {

  @Test("Text displays correctly")
  func displays() {

    var pixels: [Position: Pixel] = [:]
    let canvas = Canvas { pixels[$1] = $0 }

    Text("Hello").update(canvas: canvas)

    #expect(pixels == [
      Position(x: 1, y: 0): Pixel("H"),
      Position(x: 2, y: 0): Pixel("e"),
      Position(x: 3, y: 0): Pixel("l"),
      Position(x: 4, y: 0): Pixel("l"),
      Position(x: 5, y: 0): Pixel("o"),
    ])
  }

  @Test("foregroundColor")
  func foregroundColor() {

    var pixels: [Position: Pixel] = [:]
    let canvas = Canvas { pixels[$1] = $0 }

    Text("x")
      .foregroundColor(.blue)
      .update(canvas: canvas)

    #expect(pixels == [
      Position(x: 1, y: 0): Pixel("x", foreground: .blue),
    ])
  }

  @Test("backgroundColor")
  func backgroundColor() {

    var pixels: [Position: Pixel] = [:]
    let canvas = Canvas { pixels[$1] = $0 }

    Text("x")
      .backgroundColor(.blue)
      .update(canvas: canvas)

    #expect(pixels == [
      Position(x: 1, y: 0): Pixel("x", background: .blue),
    ])
  }
}
