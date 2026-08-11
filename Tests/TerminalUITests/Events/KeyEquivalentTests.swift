import AsyncAlgorithms
import AttributeGraph
@testable import TerminalUI
import Testing

@Suite("KeyEquivalent")
struct KeyEquivalentTests {

  @Test func `init(_ character:)`() {
    let key = KeyEquivalent("e")
    #expect(key.character == "e")
  }

  @Test func `ExpressibleByUnicodeScalarLiteral conformance`() {
    let key: KeyEquivalent = "r"
    #expect(key.character == "r")
  }
}
