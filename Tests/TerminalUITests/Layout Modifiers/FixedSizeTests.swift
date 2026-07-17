@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("FixedSize", .tags(.modifier))
struct FixedSizeTests {

  private let view = Color.blue
  private let cell = Cell(" ", background: .blue)

  @Test func `body: fatal`() async {
    await #expect(processExitsWith: .failure) {
      _ = Color.black.fixedSize().body
    }
  }

  @Test func `horizontal`() {

    let screen = TestScreen(width: 1, height: 1)
    screen.render {
      view.fixedSize(horizontal: true, vertical: false)
    }

    // The default length for a nil length in a proposed size is 10.
    #expect(screen.buffer.description == """
      ▨▨▨▨▨▨▨▨▨▨
      """)
  }

  @Test func `vertical`() {

    let screen = TestScreen(width: 1, height: 1)
    screen.render {
      view.fixedSize(horizontal: false, vertical: true)
    }

    // The default length for a nil length in a proposed size is 10.
    #expect(screen.buffer.description == """
      ▨
      ▨
      ▨
      ▨
      ▨
      ▨
      ▨
      ▨
      ▨
      ▨
      """)
  }

  @Test func `both`() {

    let screen = TestScreen(width: 1, height: 1)
    screen.render {
      view.fixedSize(horizontal: true, vertical: true)
    }

    // The default length for a nil length in a proposed size is 10.
    #expect(screen.buffer.description == """
      ▨▨▨▨▨▨▨▨▨▨
      ▨▨▨▨▨▨▨▨▨▨
      ▨▨▨▨▨▨▨▨▨▨
      ▨▨▨▨▨▨▨▨▨▨
      ▨▨▨▨▨▨▨▨▨▨
      ▨▨▨▨▨▨▨▨▨▨
      ▨▨▨▨▨▨▨▨▨▨
      ▨▨▨▨▨▨▨▨▨▨
      ▨▨▨▨▨▨▨▨▨▨
      ▨▨▨▨▨▨▨▨▨▨
      """)
  }

  @Suite(.tags(.preferenceValues))
  struct `Preference Values` {

    @Test func `default value`() {

      var output = ""

      TestScreen(width: 3, height: 3).render {
        Text("x")
          .fixedSize(horizontal: true, vertical: false)
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == PreferenceKey.A.defaultValue)
    }

    @Test func `modified value`() {

      var output = ""

      TestScreen(width: 3, height: 3).render {
        Text("x")
          .preference(key: PreferenceKey.A.self, value: "new")
          .fixedSize(horizontal: true, vertical: false)
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == "new")
    }
  }
}
