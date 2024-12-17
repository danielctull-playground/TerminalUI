import TerminalUI
import TerminalUITesting
import Testing

@Suite("Environment Tests")
struct EnvironmentTests {

  private let canvas = TestCanvas(width: 7, height: 1)

  @Test("default")
  func defaultValue() {

    canvas.render {
      TestView()
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): Pixel("d"),
      Position(x: 2, y: 1): Pixel("e"),
      Position(x: 3, y: 1): Pixel("f"),
      Position(x: 4, y: 1): Pixel("a"),
      Position(x: 5, y: 1): Pixel("u"),
      Position(x: 6, y: 1): Pixel("l"),
      Position(x: 7, y: 1): Pixel("t"),
    ])
  }

  @Test("modifier")
  func modifier() {

    canvas.render {
      TestView().environment(\.value, "b")
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): Pixel("b"),
    ])
  }
}

private struct TestView: View {
  @Environment(\.value) var value
  var body: some View {
    Text(value)
  }
}

private struct ValueKey: EnvironmentKey {
  static var defaultValue: String { "default" }
}

extension EnvironmentValues {
  fileprivate var value: String {
    get { self[ValueKey.self] }
    set { self[ValueKey.self] = newValue }
  }
}
