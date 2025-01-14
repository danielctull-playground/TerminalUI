import TerminalUI
import Testing

@Suite("AttributeGraph")
struct AttributeGraphTests {

  @Test("rule")
  func rule() {
    let graph = AttributeGraph()
    let node = graph.rule("value") { 12 }
    #expect(node.value == 12)
    #expect(node.name == "value")
    #expect(node.name.description == "value")
  }
}
