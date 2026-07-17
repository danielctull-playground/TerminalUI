@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("AnyView", .tags(.view))
struct AnyViewTests {

  @Test func `body: fatal`() async {
    await #expect(processExitsWith: .failure) {
      _ = AnyView(Color.black).body
    }
  }

  @Test func `Display Items`() {

    let screen = TestScreen(width: 5, height: 3)
    screen.render {
      AnyView(Text("Hello"))
    }

    #expect(screen.buffer.description == """
      .....
      Hello
      .....
      """)
  }

  @Suite(.tags(.preferenceValues))
  struct `Preference Values` {

    @Test func `default value`() {

      var output = ""

      TestScreen(width: 3, height: 3).render {
        AnyView(Text("Hello"))
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == PreferenceKey.A.defaultValue)
    }

    @Test func `modified value`() {

      var output = ""

      TestScreen(width: 3, height: 3).render {
        AnyView(Text("Hello"))
          .preference(key: PreferenceKey.A.self, value: "new")
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == "new")
    }
  }
}
