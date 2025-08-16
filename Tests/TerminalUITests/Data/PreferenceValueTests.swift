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

  private let canvas = TestCanvas(width: 7, height: 1)

  @MainActor
  @Suite("Reader")
  struct Reader {

    private let canvas = TestCanvas(width: 7, height: 1)

    @Test("defaultValue")
    func defaultValue() {

      struct TestView: View {
        let action: (String) -> Void
        var body: some View {
          Text("x")
            .onPreferenceChange(A.self, perform: action)
        }
      }

      var output = ""

      let renderer = Renderer(
        canvas: canvas,
        content: TestView { output = $0 }
      )
      renderer.render()

      #expect(output == A.defaultValue)
    }
  }


  @MainActor
  @Suite("Writer")
  struct Writer {

    private let canvas = TestCanvas(width: 7, height: 1)

    @Test("same preference")
    func samePreference() {

      struct TestView: View {
        let action: (String) -> Void
        var body: some View {
          Text("x")
            .preference(key: A.self, value: "new")
            .onPreferenceChange(A.self, perform: action)
        }
      }

      var output = ""

      let renderer = Renderer(
        canvas: canvas,
        content: TestView { output = $0 }
      )
      renderer.render()

      #expect(output == "new")
    }

    @Test("incorrect order")
    func incorrectOrder() {

      struct TestView: View {
        let action: (String) -> Void
        var body: some View {
          Text("x")
            .onPreferenceChange(A.self, perform: action)
            .preference(key: A.self, value: "new")
        }
      }

      var output = ""

      let renderer = Renderer(
        canvas: canvas,
        content: TestView { output = $0 }
      )
      renderer.render()

      #expect(output == A.defaultValue)
    }

    @Test("different preference")
    func differentPreference() {

      struct TestView: View {
        let action: (String) -> Void
        var body: some View {
          Text("x")
            .preference(key: A.self, value: "new")
            .onPreferenceChange(B.self, perform: action)
        }
      }

      var output = ""

      let renderer = Renderer(
        canvas: canvas,
        content: TestView { output = $0 }
      )
      renderer.render()

      #expect(output == "b")
    }
  }

  @MainActor
  @Suite("Accumulated")
  struct Accumulated {

    private let canvas = TestCanvas(width: 7, height: 1)

    @Test("write neither")
    func writeNeither() {

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

      let renderer = Renderer(
        canvas: canvas,
        content: TestView { output = $0 }
      )
      renderer.render()

      #expect(output == A.defaultValue)
    }

    @Test("write lhs")
    func writeLHS() {

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

      let renderer = Renderer(
        canvas: canvas,
        content: TestView { output = $0 }
      )
      renderer.render()

      #expect(output == "lhs")
    }

    @Test("write rhs")
    func writeRHS() {

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

      let renderer = Renderer(
        canvas: canvas,
        content: TestView { output = $0 }
      )
      renderer.render()

      #expect(output == "rhs")
    }

    @Test("write both")
    func writeBoth() {

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

      let renderer = Renderer(
        canvas: canvas,
        content: TestView { output = $0 }
      )
      renderer.render()

      #expect(output == "12")
    }
  }
}
