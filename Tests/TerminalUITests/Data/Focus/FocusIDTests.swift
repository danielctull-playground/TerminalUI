import AttributeGraph
@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("FocusID")
struct FocusIDTests {

  @Test func `conformance: CustomStringConvertible`() {
    #expect(Int(FocusID.next.description) != nil)
  }

  @Test func `preference key takes the last sibling value`() {
    var value: FocusID? = FocusID.next
    let expected = FocusID.next
    FocusIDKey.reduce(value: &value) { expected }
    #expect(value == expected)
  }
}
