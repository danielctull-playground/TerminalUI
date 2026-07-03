import TerminalUI
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
}
