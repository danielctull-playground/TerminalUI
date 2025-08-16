@testable import TerminalUI
import TerminalUITesting
import Testing

@MainActor
@Suite("State")
struct StateTests {

  @Test("reading") func reading() {

    struct TestView: View {
      @State var value = "hello"
      var body: some View {
        Text(value)
      }
    }

    Size.window = Size(width: 5, height: 3)
    let canvas = TestCanvas(width: 5, height: 1)
    let renderer = Renderer(canvas: canvas) {
      TestView()
    }

    renderer.run()

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

    Size.window = Size(width: 5, height: 1)
    let canvas = TestCanvas(width: 5, height: 1)
    let renderer = Renderer(canvas: canvas) {
      TestView()
    }

    renderer.run()

    #expect(canvas.pixels == [
      Position(x: 2, y: 1): Pixel("n"),
      Position(x: 3, y: 1): Pixel("e"),
      Position(x: 4, y: 1): Pixel("w"),
    ])
  }

  @Test("nesting")
  func nesting() {

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

    let canvas = TestCanvas(width: 5, height: 3)
    let renderer = Renderer(canvas: canvas) {
      Outer()
    }

    renderer.run()

    #expect(canvas.pixels == [
      Position(x: 2, y: 1): Pixel("n"),
      Position(x: 3, y: 1): Pixel("e"),
      Position(x: 4, y: 1): Pixel("w"),
    ])
  }
}
