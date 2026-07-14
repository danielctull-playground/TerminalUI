@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("DynamicProperty")
struct DynamicPropertyTests {

  @Test(.tags(.state))
  func `dynamic property wrappers should allow use of state`() {

    @propertyWrapper
    struct StateDynamicProperty: DynamicProperty {
      @State private var value = ""
      var wrappedValue: String {
        get { value }
        nonmutating set { value = newValue }
      }
    }

    struct Content: View {
      @StateDynamicProperty var value
      var body: some View {
        Text(value)
          .preference(key: PreferenceKey.A.self, value: "new")
          .onPreferenceChange(PreferenceKey.A.self) { value = $0 }
      }
    }

    let screen = TestScreen(width: 3, height: 1)
    screen.render { Content() }

    #expect(screen.cells == [
      Position(x: 1, y: 1): Cell("n"),
      Position(x: 2, y: 1): Cell("e"),
      Position(x: 3, y: 1): Cell("w"),
    ])
  }

  @Test(.tags(.environment))
  func `dynamic property wrappers should allow use of environment`() {

    @propertyWrapper
    struct EnvironmentDynamicProperty: DynamicProperty {
      @Environment(\.windowSize) private var windowSize
      var wrappedValue: String {
        String(describing: windowSize.size.width)
      }
    }

    struct Content: View {
      @EnvironmentDynamicProperty var value
      var body: some View {
        Text(value)
      }
    }

    let screen = TestScreen(width: 3, height: 1)
    let renderer = Renderer(screen: screen, content: Content())

    renderer.render(event: WindowSize(size: Size(width: 1, height: 1)))
    #expect(screen.cells == [
      Position(x: 1, y: 1): Cell("1")
    ])

    renderer.render(event: WindowSize(size: Size(width: 3, height: 1)))
    #expect(screen.cells == [
      Position(x: 2, y: 1): Cell("3")
    ])
  }
}
