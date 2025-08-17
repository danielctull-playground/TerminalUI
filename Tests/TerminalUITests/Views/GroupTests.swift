@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Group", .tags(.view))
struct GroupTests {

  private var canvas = TestCanvas(width: 10, height: 10)

  @Test func test() {

    canvas.render {
      Group {
        Text("a")
        Text("b")
      }
      .padding(1)
    }

    #expect(canvas.pixels == [
      Position(x: 6, y: 4): Pixel("a"),
      Position(x: 6, y: 7): Pixel("b"),
    ])
  }

  @Suite("Preference Values", .tags(.preferenceValues))
  struct PreferenceValues {

    @Test("default value")
    func defaultValue() {

      var output = ""

      TestCanvas(width: 3, height: 3).render {
        Group {}
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == PreferenceKey.A.defaultValue)
    }

    @Test("modified lhs value")
    func modifiedLHSValue() {

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

    @Test("modified rhs value")
    func modifiedRHSValue() {

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

    @Test("modified both values")
    func modifiedBothValues() {

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
