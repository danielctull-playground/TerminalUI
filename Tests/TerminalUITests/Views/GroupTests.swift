@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Group", .tags(.view))
struct GroupTests {

  @Test func test() {

    let screen = TestScreen(width: 5, height: 6)

    screen.render {
      Group {
        Text("a")
        Text("b")
      }
      .padding(1)
    }

    #expect(screen.buffer.description == """
      .....
      ..a..
      .....
      .....
      ..b..
      .....
      """)
  }

  @Suite(.tags(.preferenceValues))
  struct `Preference Values` {

    @Test func `default value`() {

      var output = ""

      TestScreen(width: 3, height: 3).render {
        Group {}
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == PreferenceKey.A.defaultValue)
    }

    @Test func `modified lhs value`() {

      var output = ""

      TestScreen(width: 3, height: 3).render {
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

      TestScreen(width: 3, height: 3).render {
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

      TestScreen(width: 3, height: 3).render {
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
