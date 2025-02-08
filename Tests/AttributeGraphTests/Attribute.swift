@testable import AttributeGraph
import Testing

@Suite("Attribute")
struct AttributeTests {

  @Test("create")
  func create() {
    let graph = Graph()
    let attribute = graph.attribute("x") { 12 }
    #expect(attribute.value == 12)
    #expect(attribute.name == "x")
    #expect(attribute.name.description == "x")
  }

  @Test("update")
  func update() {
    let graph = Graph()
    let x = graph.input("x", 1)
    let y = graph.attribute("y") { x.value * 2 }
    #expect(y.value == 2)
    x.value = 2
    #expect(y.value == 4)
  }

  @Test("dirty")
  func dirty() {
    let graph = Graph()
    let x = graph.input("x", 1)
    let y = graph.attribute("y") { x.value * 2 }
    #expect(y.value == 2)

    x.value = 2
    #expect(y.dirty == true)
    #expect(y.value == 4)
    #expect(y.dirty == false)
  }
}
