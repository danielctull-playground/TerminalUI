import TerminalUI
import Testing

@Suite("KeyEquivalent")
struct KeyEquivalentTests {

  @Test func character() {
    #expect(KeyEquivalent("a").character == "a")
    #expect(KeyEquivalent.space.character == " ")
  }

  @Test func expressibleByExtendedGraphemeClusterLiteral() {
    let key: KeyEquivalent = "d"
    #expect(key == KeyEquivalent("d"))
  }

  @Test(arguments: [
    (KeyEquivalent.upArrow, 0xF700 as UInt32),
    (KeyEquivalent.downArrow, 0xF701 as UInt32),
    (KeyEquivalent.leftArrow, 0xF702 as UInt32),
    (KeyEquivalent.rightArrow, 0xF703 as UInt32),
    (KeyEquivalent.escape, 0x001B as UInt32),
    (KeyEquivalent.delete, 0x0008 as UInt32),
    (KeyEquivalent.deleteForward, 0xF728 as UInt32),
    (KeyEquivalent.home, 0xF729 as UInt32),
    (KeyEquivalent.end, 0xF72B as UInt32),
    (KeyEquivalent.pageUp, 0xF72C as UInt32),
    (KeyEquivalent.pageDown, 0xF72D as UInt32),
    (KeyEquivalent.clear, 0xF739 as UInt32),
    (KeyEquivalent.tab, 0x0009 as UInt32),
    (KeyEquivalent.space, 0x0020 as UInt32),
    (KeyEquivalent.return, 0x000D as UInt32),
  ])
  func `defined keys`(key: KeyEquivalent, value: UInt32) throws {
    let scalars = key.character.unicodeScalars
    #expect(scalars.count == 1)
    let scalar = try #require(scalars.first)
    #expect(scalar.value == value)
  }
}
