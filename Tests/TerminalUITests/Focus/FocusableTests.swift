@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Focusable")
struct FocusableTests {

  private struct FocusCheck: View {
    @Environment(\.isFocused) private var isFocused
    let name: String
    var body: some View {
      VStack(spacing: 0) {
        Text(name)
        Text(isFocused ? "true" : "false")
      }
    }
  }

  @Test func `focused when tabbed to`() {

    let screen = TestScreen(width: 5, height: 2)
    let renderer = Renderer(screen: screen) {
      FocusCheck(name: "check")
        .focusable()
    }

    renderer.render(event: WindowSize(size: Size(width: 5, height: 2)))
    #expect(screen.buffer.description == """
      check
      false
      """)

    renderer.render(event: KeyPress.tab)
    #expect(screen.buffer.description == """
      check
      true.
      """)

    renderer.render(event: KeyPress.tab)
    #expect(screen.buffer.description == """
      check
      true.
      """)
  }

  @Test func `clears when focus moves to a different element`() {

    let screen = TestScreen(width: 6, height: 4)
    let renderer = Renderer(screen: screen) {
      VStack(spacing: 0) {
        FocusCheck(name: "first")
          .focusable()
        FocusCheck(name: "second")
          .focusable()
      }
    }

    renderer.render(event: WindowSize(size: Size(width: 6, height: 4)))
    #expect(screen.buffer.description == """
      .first
      .false
      second
      .false
      """)

    renderer.render(event: KeyPress.tab)
    #expect(screen.buffer.description == """
      .first
      .true.
      second
      .false
      """)

    renderer.render(event: KeyPress.tab)
    #expect(screen.buffer.description == """
      .first
      .false
      second
      .true.
      """)

    renderer.render(event: KeyPress.tab)
    #expect(screen.buffer.description == """
      .first
      .true.
      second
      .false
      """)
  }

  @Test func `Not focusable when provided false`() {

    let screen = TestScreen(width: 6, height: 4)
    let renderer = Renderer(screen: screen) {
      VStack(spacing: 0) {
        FocusCheck(name: "first")
          .focusable()
        FocusCheck(name: "second")
          .focusable(false)
      }
    }

    renderer.render(event: WindowSize(size: Size(width: 6, height: 4)))
    #expect(screen.buffer.description == """
      .first
      .false
      second
      .false
      """)

    renderer.render(event: KeyPress.tab)
    #expect(screen.buffer.description == """
      .first
      .true.
      second
      .false
      """)

    renderer.render(event: KeyPress.tab)
    #expect(screen.buffer.description == """
      .first
      .true.
      second
      .false
      """)
  }

  @Test func `Element should lose focus when no longer focusable`() {

    struct Content: View {
      @Environment(\.windowSize) private var windowSize
      var body: some View {
        VStack(spacing: 0) {
          FocusCheck(name: "first")
            .focusable()
          FocusCheck(name: "second")
            .focusable(windowSize.size.width.isMultiple(of: 2))
        }
      }
    }

    let screen = TestScreen(width: 6, height: 4)
    let renderer = Renderer(screen: screen, content: Content())

    renderer.render(event: WindowSize(size: Size(width: 6, height: 4)))
    #expect(screen.buffer.description == """
      .first
      .false
      second
      .false
      """)

    renderer.render(event: KeyPress.tab)
    #expect(screen.buffer.description == """
      .first
      .true.
      second
      .false
      """)

    renderer.render(event: KeyPress.tab)
    #expect(screen.buffer.description == """
      .first
      .false
      second
      .true.
      """)

    renderer.render(event: WindowSize(size: Size(width: 7, height: 4)))
    #expect(screen.buffer.description == """
      .first.
      .true..
      second.
      .false.
      """)

    renderer.render(event: KeyPress.tab)
    #expect(screen.buffer.description == """
      .first.
      .true..
      second.
      .false.
      """)
  }
}
