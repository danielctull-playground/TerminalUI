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

    @Test("AdditiveArithmetic")
    func additiveArithmetic() {
      #expect(Horizontal(4) + Horizontal(2) == Horizontal(6))
      #expect(Horizontal(4) - Horizontal(2) == Horizontal(2))
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
    
    @Test("Strideable: advanced(by:)", arguments: [-1, 0, 1], [-1, 0, 1])
    func strideable_advancedBy(start: Int, n: Int) {
      #expect(Horizontal(start).advanced(by: n) == Horizontal(start.advanced(by: n)))
    }

    @Test("Strideable: distance(to:)", arguments: [-1, 0, 1], [-1, 0, 1])
    func strideable_distanceTo(x: Int, y: Int) {
      #expect(Horizontal(x).distance(to: Horizontal(y)) == x.distance(to: y))
    }

    @Test("init(some BinaryInteger)")
    func initBinaryInteger() {
      let value = Int.random(in: 0..<1_000_000)
      #expect(Horizontal(value).description == value.description)
    }

    @Test("negate")
    func negate() {
      let value = Int.random(in: 0..<1_000_000)
      #expect(-Horizontal(value) == Horizontal(-value))
    }
  }

  @Suite("Vertical") struct VerticalTests {

    @Test("AdditiveArithmetic")
    func additiveArithmetic() {
      #expect(Vertical(4) + Vertical(2) == Vertical(6))
      #expect(Vertical(4) - Vertical(2) == Vertical(2))
    }

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

    @Test("Strideable: advanced(by:)", arguments: [-1, 0, 1], [-1, 0, 1])
    func strideable_advancedBy(start: Int, n: Int) {
      #expect(Vertical(start).advanced(by: n) == Vertical(start.advanced(by: n)))
    }

    @Test("Strideable: distance(to:)", arguments: [-1, 0, 1], [-1, 0, 1])
    func strideable_distanceTo(x: Int, y: Int) {
      #expect(Vertical(x).distance(to: Vertical(y)) == x.distance(to: y))
    }

    @Test("init(some BinaryInteger)")
    func initBinaryInteger() {
      let value: Int = Int.random(in: 0..<1_000_000)
      #expect(Vertical(value).description == value.description)
    }

    @Test("negate")
    func negate() {
      let value = Int.random(in: 0..<1_000_000)
      #expect(-Vertical(value) == Vertical(-value))
    }
  }
}
