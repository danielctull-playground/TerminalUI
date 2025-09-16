import TerminalUI
import Testing

@Suite("Pixel")
struct PixelTests {

  @Test func `CustomStringConvertible`() {
    #expect(Pixel("a").description == #"Pixel("a")"#)
    #expect(Pixel("z").description == #"Pixel("z")"#)
  }
}
