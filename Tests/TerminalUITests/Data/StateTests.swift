@testable import TerminalUI
import TerminalUITesting
import Testing

@MainActor
@Suite("State", .tags(.state))
struct StateTests {

  @Test func `read outside of body: fatal`() async {
    await #expect(processExitsWith: .failure) {
      _ = TestView().value
    }
  }

  @Test func `write outside of body: fatal`() async {
    await #expect(processExitsWith: .failure) {
      TestView().value = "nope"
    }
  }

  @Test func `reading`() {

    let screen = TestScreen(width: 5, height: 3)
    screen.render {
      TestView()
    }

    #expect(screen.buffer.description == """
      _____
      hello
      _____
      """)
  }

  @Test func `writing`() {

    struct TestView: View {
      @State var value = "hello"
      var body: some View {
        Text(value)
          .preference(key: PreferenceKey.A.self, value: "new")
          .onPreferenceChange(PreferenceKey.A.self) { value = $0 }
      }
    }

    let screen = TestScreen(width: 5, height: 1)
    screen.render {
      TestView()
    }

    #expect(screen.buffer.description == """
      _new_
      """)
  }

  @Test func `nesting`() {

    struct Inner: View {
      @State var value = "hello"
      var body: some View {
        Text(value)
          .preference(key: PreferenceKey.A.self, value: "new")
          .onPreferenceChange(PreferenceKey.A.self) {
            print("new value: ", $0)
            value = $0
          }
      }
    }

    struct Outer: View {
      var body: some View {
        Inner()
      }
    }

    let screen = TestScreen(width: 5, height: 1)
    screen.render {
      Outer()
    }

    #expect(screen.buffer.description == """
      _new_
      """)
  }

  @Test func `binding`() {

    struct Inner: View {
      @Binding var value: String
      var body: some View {
        Text(value)
      }
    }

    struct Outer: View {
      @State var value = "hello"
      var body: some View {
        Inner(value: $value)
          .preference(key: PreferenceKey.A.self, value: "new")
          .onPreferenceChange(PreferenceKey.A.self) { value = $0 }
      }
    }

    let screen = TestScreen(width: 5, height: 1)
    screen.render {
      Outer()
    }

    #expect(screen.buffer.description == """
      _new_
      """)
  }

  @Test func `sibling state is independent`() {

    struct Content: View {
      @State private var shown = "?"
      let value: String
      var body: some View {
        Text(shown)
          .preference(key: PreferenceKey.A.self, value: value)
          .onPreferenceChange(PreferenceKey.A.self) { shown = $0 }
      }
    }

    let screen = TestScreen(width: 1, height: 2)
    screen.render {
      VStack(spacing: 0) {
        Content(value: "a")
        Content(value: "b")
      }
    }

    #expect(screen.buffer.description == """
      a
      b
      """)
  }
}

private struct TestView: View {
  @State var value = "hello"
  var body: some View {
    Text(value)
  }
}
