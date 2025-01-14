import AttributeGraph
import Testing

@Suite("Graph")
struct GraphTests {

  @Test("rule")
  func rule() {
    let graph = Graph()
    let attribute = graph.rule("value") { 12 }
    #expect(attribute.value == 12)
    #expect(attribute.name == "value")
    #expect(attribute.name.description == "value")
  }
}
