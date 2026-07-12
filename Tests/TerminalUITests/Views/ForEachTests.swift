@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("ForEach", .tags(.view))
struct ForEachTests {

  @Test func `renders each element in order`() {

    let canvas = TestCanvas(width: 1, height: 3)
    canvas.render {
      VStack(spacing: 0) {
        ForEach(["a", "b", "c"], id: \.self) { letter in
          Text(letter)
        }
      }
    }

    #expect(canvas.cells == [
      Position(x: 1, y: 1): Cell("a"),
      Position(x: 1, y: 2): Cell("b"),
      Position(x: 1, y: 3): Cell("c"),
    ])
  }

  @Test(.tags(.state))
  func `growing the data shows the new element`() {

    struct ArrayPreferenceKey<Value>: PreferenceKey {
      static var defaultValue: [Value] { [] }
      static func reduce(value: inout [Value], nextValue: () -> [Value]) {
        value.append(contentsOf: nextValue())
      }
    }

    struct Content: View {
      @State private var items = ["a"]
      var body: some View {
        VStack(spacing: 0) {
          ForEach(items, id: \.self, content: Text.init)
        }
        .preference(key: ArrayPreferenceKey.self, value: ["a", "b"])
        .onPreferenceChange(ArrayPreferenceKey<String>.self) { value in
          items = value
        }
      }
    }

    let canvas = TestCanvas(width: 1, height: 2)
    canvas.render { Content() }
    #expect(canvas.cells == [
      Position(x: 1, y: 1): Cell("a"),
      Position(x: 1, y: 2): Cell("b"),
    ])
  }

  @Test(.tags(.state))
  func `rows maintain state across recomputes`() {

    struct WindowSizeKey: PreferenceKey {
      static var defaultValue: WindowSize { .zero }
      static func reduce(value: inout WindowSize, nextValue: () -> WindowSize) {
        value = nextValue()
      }
    }

    struct Row: View {
      @Environment(\.windowSize) var windowSize
      @State private var widths = ""
      var body: some View {
        Text(widths)
          .preference(key: WindowSizeKey.self, value: windowSize)
          .onPreferenceChange(WindowSizeKey.self) { widths += String($0.size.width) }
      }
    }

    struct Content: View {
      var body: some View {
        VStack(spacing: 0) {
          ForEach([0], id: \.self) { _ in Row() }
        }
      }
    }

    let canvas = TestCanvas(width: 3, height: 1)
    let renderer = Renderer(canvas: canvas, content: Content())

    renderer.render(event: WindowSize(size: Size(width: 1, height: 1)))
    #expect(canvas.cells == [
      Position(x: 1, y: 1): Cell("1"),
    ])

    renderer.render(event: WindowSize(size: Size(width: 2, height: 1)))
    #expect(canvas.cells == [
      Position(x: 1, y: 1): Cell("1"),
      Position(x: 2, y: 1): Cell("2"),
    ])

    renderer.render(event: WindowSize(size: Size(width: 3, height: 1)))
    #expect(canvas.cells == [
      Position(x: 1, y: 1): Cell("1"),
      Position(x: 2, y: 1): Cell("2"),
      Position(x: 3, y: 1): Cell("3"),
    ])
  }

  @Test func `reordering the data reorders the content`() {

    struct Content: View {
      @State private var items = ["a", "b"]
      var body: some View {
        VStack(spacing: 0) {
          ForEach(items, id: \.self) { Text($0) }
        }
        .preference(key: PreferenceKey.A.self, value: "trigger")
        .onPreferenceChange(PreferenceKey.A.self) { _ in
          items = items.reversed()
        }
      }
    }

    let canvas = TestCanvas(width: 1, height: 2)

    canvas.render { Content() }
    #expect(canvas.cells == [
      Position(x: 1, y: 1): Cell("b"),
      Position(x: 1, y: 2): Cell("a"),
    ])
  }

  @Test(.tags(.state))
  func `state stays with its item across a reorder`() {

    struct TickKey: PreferenceKey {
      static var defaultValue: Int { 0 }
      static func reduce(value: inout Int, nextValue: () -> Int) { value = nextValue() }
    }

    // Each row appends its own value every frame. A row that keeps identity
    // accumulates ("aa"); a rebuilt row resets ("a"). So a doubled string
    // proves BOTH that the reorder happened AND that state survived it.
    struct Row: View {
      @Environment(\.windowSize) private var windowSize
      let value: String
      @State private var log = ""
      var body: some View {
        Text(log)
          .preference(key: TickKey.self, value: windowSize.size.width)
          .onPreferenceChange(TickKey.self) { _ in log += value }
      }
    }

    struct Content: View {
      @Environment(\.windowSize) var windowSize
      var body: some View {
        let items = windowSize.size.width == 1 ? ["a", "b"] : ["b", "a"]
        VStack(spacing: 0) {
          ForEach(items, id: \.self) { Row(value: $0) }
        }
      }
    }

    let canvas = TestCanvas(width: 2, height: 2)
    let renderer = Renderer(canvas: canvas, content: Content())

    // [a,b], each logs once
    renderer.render(event: WindowSize(size: Size(width: 1, height: 2)))
    #expect(canvas.cells == [
      Position(x: 1, y: 1): Cell("a"),
      Position(x: 1, y: 2): Cell("b"),
    ])

    // reorder → [b,a], each logs again
    renderer.render(event: WindowSize(size: Size(width: 2, height: 2)))
    #expect(canvas.cells == [
      Position(x: 1, y: 1): Cell("b"), Position(x: 2, y: 1): Cell("b"),
      Position(x: 1, y: 2): Cell("a"), Position(x: 2, y: 2): Cell("a"),
    ])
  }

  @Test(.tags(.state))
  func `leaving the content frees its state`() {

    final class Tracked {
      nonisolated(unsafe) static var live = 0
      init() { Tracked.live += 1 }
      deinit { Tracked.live -= 1 }
    }

    struct Row: View {
      @State var tracked = Tracked()
      let value: Int
      var body: some View { Text("\(value)") }
    }

    struct Content: View {
      @Environment(\.windowSize) var windowSize
      var body: some View {
        VStack(spacing: 0) {
          ForEach(1...windowSize.size.height, id: \.self) { Row(value: $0) }
        }
      }
    }

    let renderer = Renderer(canvas: TestCanvas(width: 1, height: 1), content: Content())
    #expect(Tracked.live == 0)

    // Initial render yields 1 Tracked instance.
    renderer.render(event: WindowSize(size: Size(width: 2, height: 1)))
    #expect(Tracked.live == 1)

    // A re-render yields 2 instances. This matches SwiftUI's behaviour.
    renderer.render(event: WindowSize(size: Size(width: 1, height: 1)))
    #expect(Tracked.live == 2)

    // Adding an item in ForEach adds one.
    renderer.render(event: WindowSize(size: Size(width: 1, height: 2)))
    #expect(Tracked.live == 3)

    // A re-render yields 4 Tracked instances (2 for each).
    // This again matches SwiftUI's behaviour.
    renderer.render(event: WindowSize(size: Size(width: 2, height: 2)))
    #expect(Tracked.live == 4)

    // Removing one brings the live count back to 2.
    renderer.render(event: WindowSize(size: Size(width: 1, height: 1)))
    #expect(Tracked.live == 2)

    // A re-render remains at 2.
    renderer.render(event: WindowSize(size: Size(width: 2, height: 1)))
    #expect(Tracked.live == 2)
  }
}
