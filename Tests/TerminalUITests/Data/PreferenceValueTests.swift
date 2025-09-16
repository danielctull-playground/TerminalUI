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

@Suite("Preference")
struct PreferenceTests {

  private let canvas = TestCanvas(width: 7, height: 1)

  @Suite("Reader")
  struct Reader {

    private let canvas = TestCanvas(width: 7, height: 1)

    @Test func `defaultValue`() {

      struct TestView: View {
        let action: (String) -> Void
        var body: some View {
          Text("x")
            .onPreferenceChange(A.self, perform: action)
        }
      }

      var output = ""

      canvas.render {
        TestView { output = $0 }
      }

      #expect(output == A.defaultValue)
    }
  }

  @Suite("Writer")
  struct Writer {

    private let canvas = TestCanvas(width: 7, height: 1)

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

      canvas.render {
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

      canvas.render {
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

      canvas.render {
        TestView { output = $0 }
      }

      #expect(output == "b")
    }
  }

  @Suite("Accumulated")
  struct Accumulated {

    private let canvas = TestCanvas(width: 7, height: 1)

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

      canvas.render {
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

      canvas.render {
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

      canvas.render {
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

      canvas.render {
        TestView { output = $0 }
      }

      #expect(output == "12")
    }
  }
}
