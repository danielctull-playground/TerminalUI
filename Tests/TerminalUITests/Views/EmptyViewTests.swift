@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("EmptyView", .tags(.view))
struct EmptyViewTests {

  @Test func `body: fatal`() async {
    await #expect(processExitsWith: .failure) {
      _ = EmptyView().body
    }
  }

  @Test func `Display Items`() {

    let screen = TestScreen(width: 3, height: 3)
    screen.render {
      EmptyView()
    }

    #expect(screen.buffer.description == """
      ...
      ...
      ...
      """)
  }

  @Suite(.tags(.preferenceValues))
  struct `Preference Values` {

    @Test func `default value`() {

      var output = ""

      TestScreen(width: 3, height: 3).render {
        EmptyView()
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == PreferenceKey.A.defaultValue)
    }

    @Test func `modified value`() {

      var output = ""

      TestScreen(width: 3, height: 3).render {
        EmptyView()
          .preference(key: PreferenceKey.A.self, value: "new")
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == "new")
    }
  }

//  @Test("makeView")
//  func makeView() {
//    let inputs = ViewInputs(screen: TextStreamScreen(output: .memory))
//    let items = EmptyView().makeView(inputs: inputs).displayItems
//    #expect(items.isEmpty)
//  }
}
