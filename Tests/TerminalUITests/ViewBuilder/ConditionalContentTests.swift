@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("ConditionalContent", .tags(.viewBuilder))
struct ConditionalContentTests {

  @Test(.tags(.state))
  func `state inside a branch reflects a write`() {

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
      } else {
        EmptyView()
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

    @MainActor struct Not: @MainActor View {
      @State var count = Count.next
      var body: some View { Text("\(count.amount)") }
    }

    @MainActor
    struct Content: @MainActor View {
      @Environment(\.windowSize) var size
      var body: some View {
        if size.width.isMultiple(of: 3) { MultipleOfThree() } else { Not() }
      }
    }

    let canvas = TestCanvas(width: 1, height: 1)
    let renderer = Renderer(canvas: canvas, content: Content())

    renderer.render(event: WindowChange(size: Size(width: 3, height: 1)))
    #expect(canvas.pixels[Position(x: 2, y: 1)] == Pixel("0"))

    renderer.render(event: WindowChange(size: Size(width: 5, height: 1)))
    #expect(canvas.pixels[Position(x: 3, y: 1)] == Pixel("1"))

    renderer.render(event: WindowChange(size: Size(width: 7, height: 1)))
    #expect(canvas.pixels[Position(x: 4, y: 1)] == Pixel("1"))

    renderer.render(event: WindowChange(size: Size(width: 9, height: 1)))
    #expect(canvas.pixels[Position(x: 5, y: 1)] == Pixel("3"))
  }

  @MainActor
  @Test(.tags(.state))
  func `leaving the content frees its state`() {

    final class Tracked {
      nonisolated(unsafe) static var live = 0
      init() { Tracked.live += 1 }
      deinit { Tracked.live -= 1 }
    }

    struct Content: View {
      @State var tracked = Tracked()
      var body: some View { Text("x") }
    }

    struct Root: View {
      @Environment(\.windowSize) var size
      var body: some View {
        if size.width.isMultiple(of: 2) { Content() } else { EmptyView() }
      }
    }

    Tracked.live = 0
    let renderer = Renderer(canvas: TestCanvas(width: 1, height: 1), content: Root())

    renderer.render(event: WindowChange(size: Size(width: 2, height: 1)))
    #expect(Tracked.live == 1)

    renderer.render(event: WindowChange(size: Size(width: 1, height: 1)))
    #expect(Tracked.live == 0)
  }
}
