@testable import TerminalUI
import Testing

extension View {

  package func expect(_ expected: [Position: Pixel]) {
    var pixels: [Position: Pixel] = [:]
    let canvas = Canvas { pixels[$1] = $0 }
    update(canvas: canvas)
    #expect(pixels == expected)
  }
}
