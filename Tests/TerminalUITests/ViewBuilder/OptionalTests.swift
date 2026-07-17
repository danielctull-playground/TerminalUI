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

    TestScreen(width: 3, height: 3).render {
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

    let screen = TestScreen(width: 3, height: 1)
    screen.render {
      if true {
        Stateful()
      }
    }

    #expect(screen.buffer.description == "new")
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
      @Environment(\.windowSize) var windowSize
      var body: some View {
        if windowSize.size.width.isMultiple(of: 3) { MultipleOfThree() }
      }
    }

    let screen = TestScreen(width: 15, height: 1)
    let renderer = Renderer(screen: screen, content: Content())

    renderer.render(event: WindowSize(size: Size(width: 3, height: 1)))
    #expect(screen.buffer.description == "_0_____________")

    renderer.render(event: WindowSize(size: Size(width: 5, height: 1)))
    #expect(screen.buffer.description == "_______________")

    renderer.render(event: WindowSize(size: Size(width: 7, height: 1)))
    #expect(screen.buffer.description == "_______________")

    renderer.render(event: WindowSize(size: Size(width: 9, height: 1)))
    #expect(screen.buffer.description == "____1__________")

    renderer.render(event: WindowSize(size: Size(width: 15, height: 1)))
    #expect(screen.buffer.description == "_______1_______")
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
      @Environment(\.windowSize) var windowSize
      var body: some View {
        if windowSize.size.width.isMultiple(of: 2) { Content() }
      }
    }

    Tracked.live = 0
    let renderer = Renderer(screen: TestScreen(width: 1, height: 1), content: Root())

    renderer.render(event: WindowSize(size: Size(width: 2, height: 1)))
    #expect(Tracked.live == 1)

    renderer.render(event: WindowSize(size: Size(width: 1, height: 1)))
    #expect(Tracked.live == 0)
  }
}
