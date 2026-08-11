@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("OnChange")
struct OnChangeTests {

  @Suite("(Value, Value) -> Void")
  struct ValuesAction {

    let screen = TestScreen(width: 3, height: 1)

    @Test func `initial = false`() {

      struct Content: View {
        @Environment(\.windowSize) private var windowSize
        let action: (WindowSize, WindowSize) -> Void
        var body: some View {
          Text("x")
            .onChange(of: windowSize, action)
        }
      }

      var count = 0
      var old: WindowSize?
      var new: WindowSize?

      let renderer = Renderer(
        screen: screen,
        content: Content { count += 1; old = $0; new = $1 }
      )

      let a = WindowSize(size: Size(width: 1, height: 1))
      let b = WindowSize(size: Size(width: 2, height: 1))
      let c = WindowSize(size: Size(width: 3, height: 1))

      renderer.render(event: a)
      #expect(count == 0)
      #expect(old == nil)
      #expect(new == nil)
      #expect(screen.buffer.description == "x..")

      renderer.render(event: b)
      #expect(count == 1)
      #expect(old == a)
      #expect(new == b)
      #expect(screen.buffer.description == ".x.")

      // The action is only sent when the value changes.
      renderer.render(event: b)
      #expect(count == 1)
      #expect(old == a)
      #expect(new == b)
      #expect(screen.buffer.description == ".x.")

      renderer.render(event: c)
      #expect(count == 2)
      #expect(old == b)
      #expect(new == c)
      #expect(screen.buffer.description == ".x.")
    }

    @Test func `initial = true`() {

      struct Content: View {
        @Environment(\.windowSize) private var windowSize
        let action: (WindowSize, WindowSize) -> Void
        var body: some View {
          Text("x")
            .onChange(of: windowSize, initial: true, action)
        }
      }

      var count = 0
      var old: WindowSize?
      var new: WindowSize?

      let renderer = Renderer(
        screen: screen,
        content: Content { count += 1; old = $0; new = $1 }
      )

      let a = WindowSize(size: Size(width: 1, height: 1))
      let b = WindowSize(size: Size(width: 2, height: 1))
      let c = WindowSize(size: Size(width: 3, height: 1))

      renderer.render(event: a)
      #expect(count == 1)
      #expect(old == a)
      #expect(new == a)
      #expect(screen.buffer.description == "x..")

      renderer.render(event: b)
      #expect(count == 2)
      #expect(old == a)
      #expect(new == b)
      #expect(screen.buffer.description == ".x.")

      // The action is only sent when the value changes.
      renderer.render(event: b)
      #expect(count == 2)
      #expect(old == a)
      #expect(new == b)
      #expect(screen.buffer.description == ".x.")

      renderer.render(event: c)
      #expect(count == 3)
      #expect(old == b)
      #expect(new == c)
      #expect(screen.buffer.description == ".x.")
    }
  }

  @Suite("() -> Void")
  struct VoidAction {

    let screen = TestScreen(width: 3, height: 1)

    @Test func `initial = false`() {

      struct Content: View {
        @Environment(\.windowSize) private var windowSize
        let action: (WindowSize) -> Void
        var body: some View {
          Text("x")
            .onChange(of: windowSize) {
              action(windowSize)
            }
        }
      }

      var count = 0
      var value: WindowSize?

      let renderer = Renderer(
        screen: screen,
        content: Content { count += 1; value = $0 }
      )

      let a = WindowSize(size: Size(width: 1, height: 1))
      let b = WindowSize(size: Size(width: 2, height: 1))
      let c = WindowSize(size: Size(width: 3, height: 1))

      renderer.render(event: a)
      #expect(count == 0)
      #expect(value == nil)
      #expect(screen.buffer.description == "x..")

      renderer.render(event: b)
      #expect(count == 1)
      #expect(value == b)
      #expect(screen.buffer.description == ".x.")

      // The action is only sent when the value changes.
      renderer.render(event: b)
      #expect(count == 1)
      #expect(value == b)
      #expect(screen.buffer.description == ".x.")

      renderer.render(event: c)
      #expect(count == 2)
      #expect(value == c)
      #expect(screen.buffer.description == ".x.")
    }

    @Test func `initial = true`() {

      struct Content: View {
        @Environment(\.windowSize) private var windowSize
        let action: (WindowSize) -> Void
        var body: some View {
          Text("x")
            .onChange(of: windowSize, initial: true) {
              action(windowSize)
            }
        }
      }

      var count = 0
      var value: WindowSize?

      let renderer = Renderer(
        screen: screen,
        content: Content { count += 1; value = $0 }
      )

      let a = WindowSize(size: Size(width: 1, height: 1))
      let b = WindowSize(size: Size(width: 2, height: 1))
      let c = WindowSize(size: Size(width: 3, height: 1))

      renderer.render(event: a)
      #expect(count == 1)
      #expect(value == a)
      #expect(screen.buffer.description == "x..")

      renderer.render(event: b)
      #expect(count == 2)
      #expect(value == b)
      #expect(screen.buffer.description == ".x.")

      // The action is only sent when the value changes.
      renderer.render(event: b)
      #expect(count == 2)
      #expect(value == b)
      #expect(screen.buffer.description == ".x.")

      renderer.render(event: c)
      #expect(count == 3)
      #expect(value == c)
      #expect(screen.buffer.description == ".x.")
    }
  }
}
