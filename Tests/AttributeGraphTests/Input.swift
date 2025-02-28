@testable import AttributeGraph
import Testing

@Suite("Input")
struct InputTests {

  @Test("create")
  func create() {
    let graph = Graph()
    let input = graph.input("x", 12)
    #expect(input.value == 12)
    #expect(input.name == "x")
    #expect(input.name.description == "x")
  }

  @Test("update")
  func update() {
    let graph = Graph()
    let x = graph.input("x", 1)
    let y = graph.attribute(x)
    #expect(y.value == 1)
    x.value = 2
    #expect(y.value == 2)
  }

  @Test("dirty")
  func dirty() {
    let graph = Graph()
    let x = graph.input("x", 1)
    let y = graph.attribute(x)
    #expect(y.value == 1)

    x.value = 2
    #expect(y.dirty == true)
    #expect(y.value == 2)
    #expect(y.dirty == false)
  }
}
