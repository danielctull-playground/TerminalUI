@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Offset", .tags(.modifier))
struct OffsetTests {

  private let view = Text("X")
  private let cell = Cell("X")

  @Test func `body: fatal`() async {
    await #expect(processExitsWith: .failure) {
      _ = Color.black.offset().body
    }
  }

  @Test func `x:`() {

    let screen = TestScreen(width: 5, height: 5)
    screen.render {
      view.offset(x: 2)
    }

    #expect(screen.buffer.description == """
      .....
      .....
      ....X
      .....
      .....
      """)
  }

  @Test func `y:`() {

    let screen = TestScreen(width: 5, height: 5)
    screen.render {
      view.offset(y: 2)
    }

    #expect(screen.buffer.description == """
      .....
      .....
      .....
      .....
      ..X..
      """)
  }

  @Test func `x:y:`() {

    let screen = TestScreen(width: 5, height: 5)
    screen.render {
      view.offset(x: 1, y: -2)
    }

    #expect(screen.buffer.description == """
      ...X.
      .....
      .....
      .....
      .....
      """)
  }

  @Test func `size:`() {

    let screen = TestScreen(width: 5, height: 5)
    screen.render {
      view.offset(size: Size(width: 1, height: 2))
    }

    #expect(screen.buffer.description == """
      .....
      .....
      .....
      .....
      ...X.
      """)
  }

  @Suite(.tags(.preferenceValues))
  struct `Preference Values` {

    @Test func `default value`() {

      var output = ""

      TestScreen(width: 3, height: 3).render {
        Text("x")
          .offset(x: 1, y: 2)
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == PreferenceKey.A.defaultValue)
    }

    @Test func `modified value`() {

      var output = ""

      TestScreen(width: 3, height: 3).render {
        Text("x")
          .preference(key: PreferenceKey.A.self, value: "new")
          .offset(x: 1, y: 2)
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == "new")
    }
  }
}
