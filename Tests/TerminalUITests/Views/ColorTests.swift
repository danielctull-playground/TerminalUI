import TerminalUI
import TerminalUITesting
import Testing

@Suite("Color", .tags(.view))
struct ColorTests {

  private let canvas = TestCanvas(width: 3, height: 3)

  @Test("Color displays correctly")
  func display() {

    canvas.render {
      Color.red
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): Pixel(" ", background: .red),
      Position(x: 2, y: 1): Pixel(" ", background: .red),
      Position(x: 3, y: 1): Pixel(" ", background: .red),
      Position(x: 1, y: 2): Pixel(" ", background: .red),
      Position(x: 2, y: 2): Pixel(" ", background: .red),
      Position(x: 3, y: 2): Pixel(" ", background: .red),
      Position(x: 1, y: 3): Pixel(" ", background: .red),
      Position(x: 2, y: 3): Pixel(" ", background: .red),
      Position(x: 3, y: 3): Pixel(" ", background: .red),
    ])
  }

  @Test("size", arguments: Color.testCases)
  func size(color: Color) {
    let width = Horizontal(Int.random(in: 0...1_000_000_000))
    let height = Vertical(Int.random(in: 0...1_000_000_000))
    let proposed = ProposedSize(width: width, height: height)
    let size = color._size(for: proposed)
    #expect(size.width == width)
    #expect(size.height == height)
  }
}

extension Color {
  fileprivate static var testCases: [Color] {
    [
      .black,
      .red,
      .green,
      .yellow,
      .blue,
      .magenta,
      .cyan,
      .white,
      .default,
    ]
  }
}
