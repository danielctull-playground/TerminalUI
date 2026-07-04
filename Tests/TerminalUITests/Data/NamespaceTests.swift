import TerminalUI
import TerminalUITesting
import Testing

@Suite("Namespace")
struct NamespaceTests {

  @Test func `namespaces in one view should be distinct`() {

    struct Content: View {
      @Namespace private var a
      @Namespace private var b
      var body: some View {
        Text(a == b ? "S" : "D") // Same / Different
      }
    }

    let canvas = TestCanvas(width: 1, height: 1)
    canvas.render {
      Content()
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): Pixel("D")
    ])
  }

  @Test func `namespaces in sibling views are independent`() {

    struct NamespaceKey: PreferenceKey {
      static var defaultValue: [Namespace.ID] { [] }
      static func reduce(value: inout [Namespace.ID], nextValue: () -> [Namespace.ID]) {
        value.append(contentsOf: nextValue())
      }
    }

    struct Row: View {
      @Namespace private var a
      var body: some View {
        Color.white
          .frame(width: 0, height: 0)
          .preference(key: NamespaceKey.self, value: [a])
      }
    }

    struct Content: View {
      @State private var value = ""
      var body: some View {
        Group {
          Text(value)
          Row()
          Row()
        }
        .onPreferenceChange(NamespaceKey.self) {
          // If all namespaces are different the count won't change.
          value = (Set($0).count == $0.count) ? "D" : "S"
        }
      }
    }

    let canvas = TestCanvas(width: 1, height: 1)
    canvas.render {
      Content()
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): Pixel("D")
    ])
  }
}
