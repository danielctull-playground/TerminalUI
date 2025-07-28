@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("EmptyView", .tags(.view))
struct EmptyViewTests {

  @Test("makeView")
  func makeView() {
    let inputs = ViewInputs(canvas: TextStreamCanvas(output: .memory))
    let items = EmptyView().makeView(inputs: inputs).displayItems
    #expect(items.isEmpty)
  }
}
