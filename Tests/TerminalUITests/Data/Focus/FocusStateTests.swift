@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("FocusState")
struct FocusStateTests {

  @Suite("Bool")
  struct BoolTests {

    @Test func `follows tab focus`() {

      struct Content: View {
        @FocusState private var isFocused: Bool
        var body: some View {
          VStack(spacing: 0) {
            Text(isFocused.description)
              .focusable()
              .focused($isFocused)
          }
        }
      }

      let screen = TestScreen(width: 5, height: 1)
      let renderer = Renderer(screen: screen, content: Content())

      renderer.render(event: WindowSize(size: Size(width: 5, height: 1)))
      #expect(screen.buffer.description == "false")

      renderer.render(event: KeyPress.tab)
      #expect(screen.buffer.description == "true.")
    }

    @Test func `clears when focus moves away`() {

      struct Content: View {
        @FocusState private var isFocused: Bool
        var body: some View {
          VStack(spacing: 0) {
            Text(isFocused.description)
            Text("first")
              .focusable()
              .focused($isFocused)
            Text("second")
              .focusable()
          }
        }
      }

      let screen = TestScreen(width: 6, height: 3)
      let renderer = Renderer(screen: screen, content: Content())

      renderer.render(event: WindowSize(size: Size(width: 6, height: 3)))
      #expect(screen.buffer.description == """
        .false
        .first
        second
        """)

      renderer.render(event: KeyPress.tab)
      #expect(screen.buffer.description == """
        .true.
        .first
        second
        """)

      renderer.render(event: KeyPress.tab)

      #expect(screen.buffer.description == """
        .false
        .first
        second
        """)
    }

    @Test func `programmatically switching focus`() {

      struct Content: View {
        @Environment(\.windowSize) private var windowSize
        @FocusState private var first: Bool
        @FocusState private var second: Bool
        var body: some View {
          VStack(spacing: 0) {
            Text(first.description)
            Text("first")
              .focusable()
              .focused($first)
            Text(second.description)
            Text("second")
              .focusable()
              .focused($second)
          }
          .onChange(of: windowSize) { _, new in
            switch new.size.width {
            case 7: first = true
            case 8: second = true
            default: first = false; second = false
            }
          }
        }
      }

      let screen = TestScreen(width: 6, height: 4)
      let renderer = Renderer(screen: screen, content: Content())

      renderer.render(event: WindowSize(size: Size(width: 6, height: 4)))
      #expect(screen.buffer.description == """
        .false
        .first
        .false
        second
        """)

      renderer.render(event: WindowSize(size: Size(width: 7, height: 4)))
      #expect(screen.buffer.description == """
        .true..
        .first.
        .false.
        second.
        """)

      renderer.render(event: WindowSize(size: Size(width: 8, height: 4)))
      #expect(screen.buffer.description == """
        ..false.
        ..first.
        ..true..
        .second.
        """)

      renderer.render(event: WindowSize(size: Size(width: 6, height: 4)))
      #expect(screen.buffer.description == """
        .false
        .first
        .false
        second
        """)
    }
  }

  @Suite("Value")
  struct ValueTests {

    @Test func `follows tab focus`() {

      struct Content: View {
        @FocusState private var selection: String?
        var body: some View {
          VStack(spacing: 0) {
            Text(selection ?? "nil")
            Text("first")
              .focusable()
              .focused($selection, equals: "first")
            Text("second")
              .focusable()
              .focused($selection, equals: "second")
          }
        }
      }

      let screen = TestScreen(width: 6, height: 3)
      let renderer = Renderer(screen: screen, content: Content())

      renderer.render(event: WindowSize(size: Size(width: 6, height: 3)))
      #expect(screen.buffer.description == """
        ..nil.
        .first
        second
        """)

      renderer.render(event: KeyPress.tab)
      #expect(screen.buffer.description == """
        .first
        .first
        second
        """)

      renderer.render(event: KeyPress.tab)
      #expect(screen.buffer.description == """
        second
        .first
        second
        """)
    }

    @Test func `clears when focus moves away`() {

      struct Content: View {
        @FocusState private var selection: String?
        var body: some View {
          VStack(spacing: 0) {
            Text(selection ?? "nil")
            Text("first")
              .focusable()
              .focused($selection, equals: "first")
            Text("second")
              .focusable()
          }
        }
      }

      let screen = TestScreen(width: 6, height: 3)
      let renderer = Renderer(screen: screen, content: Content())

      renderer.render(event: WindowSize(size: Size(width: 6, height: 3)))
      #expect(screen.buffer.description == """
        ..nil.
        .first
        second
        """)

      renderer.render(event: KeyPress.tab)
      #expect(screen.buffer.description == """
        .first
        .first
        second
        """)

      renderer.render(event: KeyPress.tab)
      #expect(screen.buffer.description == """
        ..nil.
        .first
        second
        """)
    }

    @Test func `programmatically switching focus`() {

      struct Content: View {
        @Environment(\.windowSize) private var windowSize
        @FocusState private var selection: String?
        var body: some View {
          VStack(spacing: 0) {
            Text(selection ?? "nil")
            Text("first")
              .focusable()
              .focused($selection, equals: "first")
            Text("second")
              .focusable()
              .focused($selection, equals: "second")
          }
          .onChange(of: windowSize) { _, new in
            selection = switch new.size.width {
            case 6: nil
            case 7: "first"
            default: "second"
            }
          }
        }
      }

      let screen = TestScreen(width: 6, height: 3)
      let renderer = Renderer(screen: screen, content: Content())

      renderer.render(event: WindowSize(size: Size(width: 6, height: 3)))
      #expect(screen.buffer.description == """
        ..nil.
        .first
        second
        """)

      renderer.render(event: WindowSize(size: Size(width: 7, height: 3)))
      #expect(screen.buffer.description == """
        .first.
        .first.
        second.
        """)

      renderer.render(event: WindowSize(size: Size(width: 8, height: 3)))
      #expect(screen.buffer.description == """
        .second.
        ..first.
        .second.
        """)

      renderer.render(event: WindowSize(size: Size(width: 6, height: 3)))
      #expect(screen.buffer.description == """
        ..nil.
        .first
        second
        """)
    }
  }
}
