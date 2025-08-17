@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("EmptyView", .tags(.view))
struct EmptyViewTests {

  @Test("Display Items")
  func displayItems() {

    let canvas = TestCanvas(width: 3, height: 3)
    canvas.render {
      EmptyView()
    }

    #expect(canvas.pixels.isEmpty)
  }

  @Suite("Preference Values", .tags(.preferenceValues))
  struct PreferenceValues {

    @Test("default value")
    func defaultValue() {

      var output = ""

      TestCanvas(width: 3, height: 3).render {
        EmptyView()
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == PreferenceKey.A.defaultValue)
    }

    @Test("modified value")
    func modifiedValue() {

      var output = ""

      TestCanvas(width: 3, height: 3).render {
        EmptyView()
          .preference(key: PreferenceKey.A.self, value: "new")
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == "new")
    }
  }

//  @Test("makeView")
//  func makeView() {
//    let inputs = ViewInputs(canvas: TextStreamCanvas(output: .memory))
//    let items = EmptyView().makeView(inputs: inputs).displayItems
//    #expect(items.isEmpty)
//  }
}
