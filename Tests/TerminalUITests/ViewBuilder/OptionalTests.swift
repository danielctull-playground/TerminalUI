@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Optional", .tags(.viewBuilder))
struct OptionalTests {

  @Test("body: fatal")
  func body() async {
    await #expect(processExitsWith: .failure) {
      _ = Optional<EmptyView>.none.body
      _ = Optional<EmptyView>.some(EmptyView()).body
    }
  }

  @Test("Preference Values", arguments: [
    (false, PreferenceKey.A.defaultValue),
    (true, "new value"),
  ])
  func preferenceValues(value: Bool, expected: String) {

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
}
