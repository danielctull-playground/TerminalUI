@testable import TerminalUI
import TerminalUITesting
import Testing

@MainActor
@Suite("State")
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

  @Test("reading") func reading() {

    let canvas = TestCanvas(width: 5, height: 3)
    canvas.render {
      TestView()
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 2): Pixel("h"),
      Position(x: 2, y: 2): Pixel("e"),
      Position(x: 3, y: 2): Pixel("l"),
      Position(x: 4, y: 2): Pixel("l"),
      Position(x: 5, y: 2): Pixel("o"),
    ])
  }

  @Test("writing") func writing() {

    struct TestView: View {
      @State var value = "hello"
      var body: some View {
        Text(value)
          .preference(key: PreferenceKey.A.self, value: "new")
          .onPreferenceChange(PreferenceKey.A.self) { value = $0 }
      }
    }

    let canvas = TestCanvas(width: 5, height: 1)
    canvas.render {
      TestView()
    }

    #expect(canvas.pixels == [
      Position(x: 2, y: 1): Pixel("n"),
      Position(x: 3, y: 1): Pixel("e"),
      Position(x: 4, y: 1): Pixel("w"),
    ])
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

    let canvas = TestCanvas(width: 5, height: 1)
    canvas.render {
      Outer()
    }

    #expect(canvas.pixels == [
      Position(x: 2, y: 1): Pixel("n"),
      Position(x: 3, y: 1): Pixel("e"),
      Position(x: 4, y: 1): Pixel("w"),
    ])
  }

  @Test("binding") func binding() {

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

    let canvas = TestCanvas(width: 5, height: 1)
    canvas.render {
      Outer()
    }

    #expect(canvas.pixels == [
      Position(x: 2, y: 1): Pixel("n"),
      Position(x: 3, y: 1): Pixel("e"),
      Position(x: 4, y: 1): Pixel("w"),
    ])
  }
}

private struct TestView: View {
  @State var value = "hello"
  var body: some View {
    Text(value)
  }
}
