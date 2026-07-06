import AsyncAlgorithms
import AttributeGraph
@testable import TerminalUI
import Testing

@Suite("KeyPress")
struct KeyPressTests {

  // MARK: - keyPressEvents (Byte -> KeyPress conversion)

  @Test func `a byte becomes a key press`() async throws {
    let events: [any Event] = [Byte(0x68), Byte(0x69)]   // "h", "i"
    var iterator = events.async.keyPressEvents.makeAsyncIterator()
    #expect(try await iterator.next() as? KeyPress == KeyPress("h"))
    #expect(try await iterator.next() as? KeyPress == KeyPress("i"))
  }

  @Test func `non-byte events pass through unchanged`() async throws {
    let size = Size(width: 3, height: 4)
    let events: [any Event] = [CSI(command: "a"), WindowChange(size: size)]
    var iterator = events.async.keyPressEvents.makeAsyncIterator()
    #expect(try await iterator.next() as? CSI == CSI(command: "a"))
    #expect(try await iterator.next() as? WindowChange == WindowChange(size: size))
  }

  @Test func `only bytes are converted in a mixed stream`() async throws {
    let events: [any Event] = [Byte(0x68), CSI(command: "a"), Byte(0x69)]
    var iterator = events.async.keyPressEvents.makeAsyncIterator()
    #expect(try await iterator.next() as? KeyPress == KeyPress("h"))
    #expect(try await iterator.next() as? CSI == CSI(command: "a"))
    #expect(try await iterator.next() as? KeyPress == KeyPress("i"))
  }

  @Test(.disabled("multi-byte UTF-8 not yet decoded"))
  func `a multi-byte UTF-8 character becomes one key press`() async throws {
    let events: [any Event] = [Byte(0xC3), Byte(0xA9)]
    var iterator = events.async.keyPressEvents.makeAsyncIterator()
    #expect(try await iterator.next() as? KeyPress == KeyPress(character: "é"))
    #expect(try await iterator.next() == nil)
  }

  // MARK: - updateEnvironment routes to the focus manager

  @Test func `updateEnvironment delivers the key to the focus manager`() {
    let graph = Graph()
    var received: [KeyPress] = []
    let manager = FocusManager(graph: graph) { received.append($0) }

    var environment = EnvironmentValues()
    environment.focusManager = manager

    KeyPress("h").updateEnvironment(&environment)
    KeyPress("i").updateEnvironment(&environment)

    #expect(received == ["h", "i"])
  }
}
