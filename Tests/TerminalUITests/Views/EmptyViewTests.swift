@testable import TerminalUI
import TerminalUITesting
import Testing

@MainActor
@Suite("EmptyView", .tags(.view))
struct EmptyViewTests {

  @Test("Display Items")
  func displayItems() {

    let canvas = TestCanvas(width: 3, height: 3)
    let renderer = Renderer(canvas: canvas) {
      EmptyView()
    }

    renderer.run()

    #expect(canvas.pixels.isEmpty)
  }

  @MainActor
  @Suite("Preferences", .tags(.preferences))
  struct Preferences {

    @Test("default value")
    func defaultValue() {

      var output = ""

      let renderer = Renderer(canvas: TestCanvas(width: 3, height: 3)) {
        EmptyView()
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }
      renderer.run()

      #expect(output == PreferenceKey.A.defaultValue)
    }

    @Test("modified value")
    func modifiedValue() {

      var output = ""

      let renderer = Renderer(canvas: TestCanvas(width: 3, height: 3)) {
        EmptyView()
          .preference(key: PreferenceKey.A.self, value: "new")
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }
      renderer.run()

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
