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

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): Pixel("a"),
      Position(x: 1, y: 2): Pixel("b"),
      Position(x: 1, y: 3): Pixel("c"),
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
    #expect(canvas.pixels == [
      Position(x: 1, y: 1): Pixel("a"),
      Position(x: 1, y: 2): Pixel("b"),
    ])
  }

  @Test(.tags(.state))
  func `rows maintain state across recomputes`() {

    struct WindowSizeKey: PreferenceKey {
      static var defaultValue: Size { .zero }
      static func reduce(value: inout Size, nextValue: () -> Size) {
        value = nextValue()
      }
    }

    struct Row: View {
      @Environment(\.windowSize) var windowSize
      @State private var widths = ""
      var body: some View {
        Text(widths)
          .preference(key: WindowSizeKey.self, value: windowSize)
          .onPreferenceChange(WindowSizeKey.self) { widths += String($0.width) }
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

    renderer.render(event: WindowChange(size: Size(width: 1, height: 1)))
    #expect(canvas.pixels == [
      Position(x: 1, y: 1): Pixel("1"),
    ])

    renderer.render(event: WindowChange(size: Size(width: 2, height: 1)))
    #expect(canvas.pixels == [
      Position(x: 1, y: 1): Pixel("1"),
      Position(x: 2, y: 1): Pixel("2"),
    ])

    renderer.render(event: WindowChange(size: Size(width: 3, height: 1)))
    #expect(canvas.pixels == [
      Position(x: 1, y: 1): Pixel("1"),
      Position(x: 2, y: 1): Pixel("2"),
      Position(x: 3, y: 1): Pixel("3"),
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
    #expect(canvas.pixels == [
      Position(x: 1, y: 1): Pixel("b"),
      Position(x: 1, y: 2): Pixel("a"),
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
      @Environment(\.windowSize) private var size
      let value: String
      @State private var log = ""
      var body: some View {
        Text(log)
          .preference(key: TickKey.self, value: size.width)
          .onPreferenceChange(TickKey.self) { _ in log += value }
      }
    }

    struct Content: View {
      @Environment(\.windowSize) var size
      var body: some View {
        let items = size.width == 1 ? ["a", "b"] : ["b", "a"]
        VStack(spacing: 0) {
          ForEach(items, id: \.self) { Row(value: $0) }
        }
      }
    }

    let canvas = TestCanvas(width: 2, height: 2)
    let renderer = Renderer(canvas: canvas, content: Content())

    // [a,b], each logs once
    renderer.render(event: WindowChange(size: Size(width: 1, height: 2)))
    #expect(canvas.pixels == [
      Position(x: 1, y: 1): Pixel("a"),
      Position(x: 1, y: 2): Pixel("b"),
    ])

    // reorder → [b,a], each logs again
    renderer.render(event: WindowChange(size: Size(width: 2, height: 2)))
    #expect(canvas.pixels == [
      Position(x: 1, y: 1): Pixel("b"), Position(x: 2, y: 1): Pixel("b"),
      Position(x: 1, y: 2): Pixel("a"), Position(x: 2, y: 2): Pixel("a"),
    ])
  }
}
