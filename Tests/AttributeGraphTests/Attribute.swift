import AttributeGraph
import Testing

@Suite("Attribute")
struct AttributeTests {

  @Test("create")
  func create() {
    let graph = Graph()
    let attribute = graph.attribute("attribute", value: 12)
    #expect(attribute.value == 12)
    #expect(attribute.name == "attribute")
    #expect(attribute.name.description == "attribute")
  }
}
