@testable import TerminalUI
import TerminalUITesting
import Testing

private struct A: PreferenceKey {
  static var defaultValue: String { "a" }
  static func reduce(value: inout String, nextValue: () -> String) {
    value.append(nextValue())
  }
}

private struct B: PreferenceKey {
  static var defaultValue: String { "b" }
  static func reduce(value: inout String, nextValue: () -> String) {
    value.append(nextValue())
  }
}

@MainActor
@Suite("Preference")
struct PreferenceTests {

  private let screen = TestScreen(width: 7, height: 1)

  @MainActor
  @Suite("Reader")
  struct ReaderTests {

    private let screen = TestScreen(width: 7, height: 1)

    @Test func `defaultValue`() {

      struct TestView: View {
        let action: (String) -> Void
        var body: some View {
          Text("x")
            .onPreferenceChange(A.self, perform: action)
        }
      }

      var output = ""

      screen.render {
        TestView { output = $0 }
      }

      #expect(output == A.defaultValue)
    }
  }

  @MainActor
  @Suite("Writer")
  struct WriterTests {

    private let screen = TestScreen(width: 7, height: 1)

    @Test func `same preference`() {

      struct TestView: View {
        let action: (String) -> Void
        var body: some View {
          Text("x")
            .preference(key: A.self, value: "new")
            .onPreferenceChange(A.self, perform: action)
        }
      }

      var output = ""

      screen.render {
        TestView { output = $0 }
      }

      #expect(output == "new")
    }

    @Test func `incorrect order`() {

      struct TestView: View {
        let action: (String) -> Void
        var body: some View {
          Text("x")
            .onPreferenceChange(A.self, perform: action)
            .preference(key: A.self, value: "new")
        }
      }

      var output = ""

      screen.render {
        TestView { output = $0 }
      }

      #expect(output == A.defaultValue)
    }

    @Test func `different preference`() {

      struct TestView: View {
        let action: (String) -> Void
        var body: some View {
          Text("x")
            .preference(key: A.self, value: "new")
            .onPreferenceChange(B.self, perform: action)
        }
      }

      var output = ""

      screen.render {
        TestView { output = $0 }
      }

      #expect(output == "b")
    }
  }

  @MainActor
  @Suite("Accumulated")
  struct AccumulatedTests {

    private let screen = TestScreen(width: 7, height: 1)

    @Test func `write neither`() {

      struct TestView: View {
        let action: (String) -> Void
        var body: some View {
          Group {
            Text("x")
            Text("y")
          }
          .onPreferenceChange(A.self, perform: action)
        }
      }

      var output = ""

      screen.render {
        TestView { output = $0 }
      }

      #expect(output == A.defaultValue)
    }

    @Test func `write lhs`() {

      struct TestView: View {
        let action: (String) -> Void
        var body: some View {
          Group {
            Text("x")
              .preference(key: A.self, value: "lhs")
            Text("y")
          }
          .onPreferenceChange(A.self, perform: action)
        }
      }

      var output = ""

      screen.render {
        TestView { output = $0 }
      }

      #expect(output == "lhs")
    }

    @Test func `write rhs`() {

      struct TestView: View {
        let action: (String) -> Void
        var body: some View {
          Group {
            Text("x")
            Text("y")
              .preference(key: A.self, value: "rhs")
          }
          .onPreferenceChange(A.self, perform: action)
        }
      }

      var output = ""

      screen.render {
        TestView { output = $0 }
      }

      #expect(output == "rhs")
    }

    @Test func `write both`() {

      struct TestView: View {
        let action: (String) -> Void
        var body: some View {
          Group {
            Text("x")
              .preference(key: A.self, value: "1")
            Text("y")
              .preference(key: A.self, value: "2")
          }
          .onPreferenceChange(A.self, perform: action)
        }
      }

      var output = ""

      screen.render {
        TestView { output = $0 }
      }

      #expect(output == "12")
    }

    @Test func `each sibling observes its own preference`() {

      var lhs = ""
      var rhs = ""

      screen.render {
        Group {
          Text("x")
            .preference(key: A.self, value: "lhs")
            .onPreferenceChange(A.self) { lhs = $0 }
          Text("y")
            .preference(key: B.self, value: "rhs")
            .onPreferenceChange(B.self) { rhs = $0 }
        }
      }

      #expect(lhs == "lhs")
      #expect(rhs == "rhs")
    }
  }
}
