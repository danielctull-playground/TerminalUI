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

    let canvas = TestCanvas(width: 5, height: 3)
    canvas.render {
      AnyView(Text("Hello"))
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 2): Pixel("H"),
      Position(x: 2, y: 2): Pixel("e"),
      Position(x: 3, y: 2): Pixel("l"),
      Position(x: 4, y: 2): Pixel("l"),
      Position(x: 5, y: 2): Pixel("o"),
    ])
  }

  @Suite("Preference Values", .tags(.preferenceValues))
  struct PreferenceValues {

    @Test func `default value`() {

      var output = ""

      TestCanvas(width: 3, height: 3).render {
        AnyView(Text("Hello"))
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == PreferenceKey.A.defaultValue)
    }

    @Test func `modified value`() {

      var output = ""

      TestCanvas(width: 3, height: 3).render {
        AnyView(Text("Hello"))
          .preference(key: PreferenceKey.A.self, value: "new")
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == "new")
    }
  }
}
