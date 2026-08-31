import TerminalUI
import TerminalUITesting
import Testing

@Suite("Background", .tags(.layout))
struct BackgroundTests {

  @Test func `body: fatal`() async {
    await #expect(processExitsWith: .failure) {
      _ = Text("")
        .background { Color.red }
        .body
    }
  }

  @Test(arguments: Array<(Alignment, String)>([
    (.topLeading, """
      ▥▧▧▤▤
      ▧▧▧▤▤
      ▧▧▧▤▤
      ▤▤▤▤▤
      ▤▤▤▤▤
      """
    ),
    (.top, """
      ▤▧▥▧▤
      ▤▧▧▧▤
      ▤▧▧▧▤
      ▤▤▤▤▤
      ▤▤▤▤▤
      """
    ),
    (.topTrailing, """
      ▤▤▧▧▥
      ▤▤▧▧▧
      ▤▤▧▧▧
      ▤▤▤▤▤
      ▤▤▤▤▤
      """
    ),
    (.leading, """
      ▤▤▤▤▤
      ▧▧▧▤▤
      ▥▧▧▤▤
      ▧▧▧▤▤
      ▤▤▤▤▤
      """
    ),
    (.center, """
      ▤▤▤▤▤
      ▤▧▧▧▤
      ▤▧▥▧▤
      ▤▧▧▧▤
      ▤▤▤▤▤
      """
    ),
    (.trailing, """
      ▤▤▤▤▤
      ▤▤▧▧▧
      ▤▤▧▧▥
      ▤▤▧▧▧
      ▤▤▤▤▤
      """
    ),
    (.bottomLeading, """
      ▤▤▤▤▤
      ▤▤▤▤▤
      ▧▧▧▤▤
      ▧▧▧▤▤
      ▥▧▧▤▤
      """
    ),
    (.bottom, """
      ▤▤▤▤▤
      ▤▤▤▤▤
      ▤▧▧▧▤
      ▤▧▧▧▤
      ▤▧▥▧▤
      """
    ),
    (.bottomTrailing, """
      ▤▤▤▤▤
      ▤▤▤▤▤
      ▤▤▧▧▧
      ▤▤▧▧▧
      ▤▤▧▧▥
      """
    ),
  ]))
  func `alignment`(alignment: Alignment, expected: String) {

    let screen = TestScreen(width: 5, height: 5)
    let green = Color.green.frame(width: 5, height: 5)
    let red = Color.red.frame(width: 3, height: 3)
    let yellow = Color.yellow.frame(width: 1, height: 1)

    do {
      screen.render {
        green
          .background(alignment: alignment) {
            yellow
            red
          }
      }

      #expect(screen.buffer.description == expected)
    }

    do {
      screen.render {
        green
          .background(alignment: alignment) { red }
          .background(alignment: alignment) { yellow }
      }

      #expect(screen.buffer.description == expected)
    }
  }
}
