import TerminalUI
import Testing

@Suite("Pixel")
struct PixelTests {

  @Test("CustomStringConvertible")
  func customStringConvertible() {
    #expect(Pixel("a").description == #"Pixel("a")"#)
    #expect(Pixel("z").description == #"Pixel("z")"#)
  }
}
