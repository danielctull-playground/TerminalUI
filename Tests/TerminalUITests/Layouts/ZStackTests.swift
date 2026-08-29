import TerminalUI
import TerminalUITesting
import Testing

@Suite("ZStack", .tags(.view, .layout))
struct ZStackTests {

  @Test func `body: fatal`() async {
    await #expect(processExitsWith: .failure) {
      _ = ZStack {}.body
    }
  }

  @Test func `empty`() {

    let screen = TestScreen(width: 3, height: 3)

    screen.render {
      ZStack {}
    }

    #expect(screen.buffer.description == """
      ...
      ...
      ...
      """)
  }

  @Test func `single stack`() {

    let screen = TestScreen(width: 3, height: 3)

    screen.render {
      ZStack {
        Text("1")
        Text("2")
        Text("3")
      }
    }

    #expect(screen.buffer.description == """
      ...
      .3.
      ...
      """)
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

    screen.render {
      ZStack(alignment: alignment) {
        Color.green.frame(width: 5, height: 5)
        Color.red.frame(width: 3, height: 3)
        Color.yellow.frame(width: 1, height: 1)
      }
    }

    #expect(screen.buffer.description == expected)
  }
}
