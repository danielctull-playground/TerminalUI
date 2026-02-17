@testable import AttributeGraph
import Testing

@Suite("Attribute")
struct AttributeTests {

  @Test func `create`() {
    let graph = Graph()
    let attribute = graph.attribute("x") { 12 }
    #expect(attribute.wrappedValue == 12)
    #expect(attribute.name == "x")
    #expect(attribute.name.description == "x")
  }

  @Test func `update`() {
    let graph = Graph()
    let x = graph.external("x", 1)
    let y = graph.attribute("y") { x.wrappedValue * 2 }
    #expect(y.wrappedValue == 2)
    x.wrappedValue = 2
    #expect(y.wrappedValue == 4)
  }

  @Test func `dirty`() {
    let graph = Graph()
    let x = graph.external("x", 1)
    let y = graph.attribute("y") { x.wrappedValue * 2 }
    #expect(y.wrappedValue == 2)

    x.wrappedValue = 2
    #expect(y.dirty == true)
    #expect(y.wrappedValue == 4)
    #expect(y.dirty == false)
  }
}
