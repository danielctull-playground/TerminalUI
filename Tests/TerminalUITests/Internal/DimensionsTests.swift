@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Dimensions") struct DimensionTests {

  @Suite("Horizontal") struct HorizontalTests {

    @Test("ExpressibleByIntegerLiteral")
    func expressibleByIntegerLiteral() {
      let horizontal: Horizontal = 3
      #expect(horizontal.description == "3")
    }

    @Test("init(some BinaryInteger)")
    func initBinaryInteger() {
      let value: Int = Int.random(in: 0..<10000)
      #expect(Horizontal(value).description == value.description)
    }
  }

  @Suite("Vertical") struct VerticalTests {

    @Test("ExpressibleByIntegerLiteral")
    func expressibleByIntegerLiteral() {
      let vertical: Vertical = 3
      #expect(vertical.description == "3")
    }

    @Test("init(some BinaryInteger)")
    func initBinaryInteger() {
      let value: Int = Int.random(in: 0..<10000)
      #expect(Vertical(value).description == value.description)
    }
  }
}
