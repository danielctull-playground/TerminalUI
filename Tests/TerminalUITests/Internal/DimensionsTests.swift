import TerminalUI
import TerminalUITesting
import Testing

@Suite("Dimensions") struct DimensionTests {

  @Suite("Horizontal") struct HorizontalTests {

    @Test("ExpressibleByIntegerLiteral")
    func expressibleByIntegerLiteral() {
      let horizontal: Horizontal = 3
      #expect(horizontal.description == "3")
    }

    @Test("Comparable")
    func comparable() {
      #expect(Horizontal(1) < Horizontal(2))
      #expect(Horizontal(2) > Horizontal(1))
      #expect(Horizontal(1) <= Horizontal(1))
      #expect(Horizontal(1) >= Horizontal(1))
    }

    @Test("Equatable")
    func equatable() {
      #expect(Horizontal(1) == Horizontal(1))
      #expect(Horizontal(2) != Horizontal(1))
    }

    @Test("Strideable")
    func strideable() {
      var horizontals = (Horizontal(1)...Horizontal(3)).makeIterator()
      #expect(horizontals.next() == 1)
      #expect(horizontals.next() == 2)
      #expect(horizontals.next() == 3)
      #expect(horizontals.next() == nil)
    }

    @Test("init(some BinaryInteger)")
    func initBinaryInteger() {
      let value = Int.random(in: 0..<1_000_000)
      #expect(Horizontal(value).description == value.description)
    }
  }

  @Suite("Vertical") struct VerticalTests {

    @Test("Comparable")
    func comparable() {
      #expect(Vertical(1) < Vertical(2))
      #expect(Vertical(2) > Vertical(1))
      #expect(Vertical(1) <= Vertical(1))
      #expect(Vertical(1) >= Vertical(1))
    }

    @Test("Equatable")
    func equatable() {
      #expect(Vertical(1) == Vertical(1))
      #expect(Vertical(2) != Vertical(1))
    }

    @Test("ExpressibleByIntegerLiteral")
    func expressibleByIntegerLiteral() {
      let vertical: Vertical = 3
      #expect(vertical.description == "3")
    }

    @Test("Strideable")
    func strideable() {
      var verticals = (Vertical(1)...Vertical(3)).makeIterator()
      #expect(verticals.next() == 1)
      #expect(verticals.next() == 2)
      #expect(verticals.next() == 3)
      #expect(verticals.next() == nil)
    }

    @Test("init(some BinaryInteger)")
    func initBinaryInteger() {
      let value: Int = Int.random(in: 0..<1_000_000)
      #expect(Vertical(value).description == value.description)
    }
  }
}
