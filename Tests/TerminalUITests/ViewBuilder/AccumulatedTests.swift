@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Accumulated", .tags(.viewBuilder))
struct AccumulatedTests {

  @Suite(.tags(.preferenceValues))
  struct `Preference Values` {

    @Test func `modified lhs value`() {

      var output = ""

      TestCanvas(width: 3, height: 3).render {
        Group {
          Text("x")
            .preference(key: PreferenceKey.A.self, value: "lhs")
          Text("y")
        }
        .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == "lhs")
    }

    @Test func `modified rhs value`() {

      var output = ""

      TestCanvas(width: 3, height: 3).render {
        Group {
          Text("x")
          Text("y")
            .preference(key: PreferenceKey.A.self, value: "rhs")
        }
        .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == "rhs")
    }

    @Test func `modified both values`() {

      var output = ""

      TestCanvas(width: 3, height: 3).render {
        Group {
          Text("x")
            .preference(key: PreferenceKey.A.self, value: "left")
          Text("y")
            .preference(key: PreferenceKey.A.self, value: "right")
        }
        .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == "leftright")
    }
  }
}
