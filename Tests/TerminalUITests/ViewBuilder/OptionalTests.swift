@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Optional", .tags(.viewBuilder))
struct OptionalTests {

  @Test func `none body: fatal`() async {
    await #expect(processExitsWith: .failure) {
      _ = Optional<EmptyView>.none.body
    }
  }

  @Test func `some body: fatal`() async {
    await #expect(processExitsWith: .failure) {
      _ = Optional<EmptyView>.some(EmptyView()).body
    }
  }

  @Test(arguments: [
    (false, PreferenceKey.A.defaultValue),
    (true, "new value"),
  ])
  func `Preference Values`(value: Bool, expected: String) {

    var output = ""

    TestCanvas(width: 3, height: 3).render {
      Group {
        if value {
          Text("x")
            .preference(key: PreferenceKey.A.self, value: "new value")
        }
      }
      .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
    }

    #expect(output == expected)
  }

  @Test(.tags(.state))
  func `state inside the content reflects a write`() {

    struct Stateful: View {
      @State var value = "old"
      var body: some View {
        Text(value)
          .preference(key: PreferenceKey.A.self, value: "new")
          .onPreferenceChange(PreferenceKey.A.self) { value = $0 }
      }
    }

    let canvas = TestCanvas(width: 3, height: 1)
    canvas.render {
      if true {
        Stateful()
      }
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): Pixel("n"),
      Position(x: 2, y: 1): Pixel("e"),
      Position(x: 3, y: 1): Pixel("w"),
    ])
  }

  @MainActor
  @Test(.tags(.state))
  func `state inside a branch is lost when changing branch`() {

    @MainActor struct Count {
      let amount: Int
      private static var _next = Count(amount: 0)
      static var next: Count {
        defer { _next = Count(amount: _next.amount + 1) }
        return _next
      }
    }

    @MainActor struct MultipleOfThree: @MainActor View {
      @State var count = Count.next
      var body: some View { Text("\(count.amount)") }
    }

    @MainActor
    struct Content: @MainActor View {
      @Environment(\.windowSize) var size
      var body: some View {
        if size.width.isMultiple(of: 3) { MultipleOfThree() }
      }
    }

    let canvas = TestCanvas(width: 1, height: 1)
    let renderer = Renderer(canvas: canvas, content: Content())

    renderer.render(event: WindowChange(size: Size(width: 3, height: 1)))
    #expect(canvas.pixels[Position(x: 2, y: 1)] == Pixel("0"))

    renderer.render(event: WindowChange(size: Size(width: 5, height: 1)))
    #expect(canvas.pixels[Position(x: 3, y: 1)] == nil)

    renderer.render(event: WindowChange(size: Size(width: 7, height: 1)))
    #expect(canvas.pixels[Position(x: 4, y: 1)] == nil)

    renderer.render(event: WindowChange(size: Size(width: 9, height: 1)))
    #expect(canvas.pixels[Position(x: 5, y: 1)] == Pixel("1"))

    renderer.render(event: WindowChange(size: Size(width: 15, height: 1)))
    #expect(canvas.pixels[Position(x: 8, y: 1)] == Pixel("1"))
  }
}
