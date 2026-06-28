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
}
