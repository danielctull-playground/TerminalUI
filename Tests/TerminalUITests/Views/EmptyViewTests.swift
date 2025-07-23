@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("EmptyView", .tags(.view))
struct EmptyViewTests {

  @Test("displayItems")
  func displayItems() {
    let inputs = ViewInputs(canvas: TextStreamCanvas(output: .memory))
    let items = EmptyView().displayItems(inputs: inputs)
    #expect(items.isEmpty)
  }
}
