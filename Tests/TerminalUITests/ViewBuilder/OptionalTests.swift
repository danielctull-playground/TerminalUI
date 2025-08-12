@testable import TerminalUI
import TerminalUITesting
import Testing

@MainActor
@Suite("Optional", .tags(.viewBuilder))
struct OptionalTests {

  @Test("Preference Values", arguments: [
    (false, PreferenceKey.A.defaultValue),
    (true, "new value"),
  ])
  func preferenceValues(value: Bool, expected: String) {

    var output = ""

    let renderer = Renderer(canvas: TestCanvas(width: 3, height: 3)) {
      Group {
        if value {
          Text("x")
            .preference(key: PreferenceKey.A.self, value: "new value")
        }
      }
      .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
    }

    renderer.run()

    #expect(output == expected)
  }
}
