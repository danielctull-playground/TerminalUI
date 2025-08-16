@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Accumulated", .tags(.viewBuilder))
struct AccumulatedTests {

  @MainActor
  @Suite("Preference Values", .tags(.preferenceValues))
  struct PreferenceValues {

    @Test("modified lhs value")
    func modifiedLHSValue() {

      var output = ""

      let renderer = Renderer(canvas: TestCanvas(width: 3, height: 3)) {
        Group {
          Text("x")
            .preference(key: PreferenceKey.A.self, value: "lhs")
          Text("y")
        }
        .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }
      renderer.render()

      #expect(output == "lhs")
    }

    @Test("modified rhs value")
    func modifiedRHSValue() {

      var output = ""

      let renderer = Renderer(canvas: TestCanvas(width: 3, height: 3)) {
        Group {
          Text("x")
          Text("y")
            .preference(key: PreferenceKey.A.self, value: "rhs")
        }
        .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }
      renderer.render()

      #expect(output == "rhs")
    }

    @Test("modified both values")
    func modifiedBothValues() {

      var output = ""

      let renderer = Renderer(canvas: TestCanvas(width: 3, height: 3)) {
        Group {
          Text("x")
            .preference(key: PreferenceKey.A.self, value: "left")
          Text("y")
            .preference(key: PreferenceKey.A.self, value: "right")
        }
        .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }
      renderer.render()

      #expect(output == "leftright")
    }
  }
}
