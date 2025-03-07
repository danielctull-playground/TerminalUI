@testable import AttributeGraph
import Testing

@Suite("Input")
struct InputTests {

  @Test("create")
  func create() {
    let graph = Graph()
    let input = graph.input("x", 12)
    #expect(input.wrappedValue == 12)
    #expect(input.name == "x")
    #expect(input.name.description == "x")
  }

  @Test("update")
  func update() {
    let graph = Graph()
    let x = graph.input("x", 1)
    let y = graph.attribute(x)
    #expect(y.wrappedValue == 1)
    x.wrappedValue = 2
    #expect(y.wrappedValue == 2)
  }

  @Test("dirty")
  func dirty() {
    let graph = Graph()
    let x = graph.input("x", 1)
    let y = graph.attribute(x)
    #expect(y.wrappedValue == 1)

    x.wrappedValue = 2
    #expect(y.dirty == true)
    #expect(y.wrappedValue == 2)
    #expect(y.dirty == false)
  }
}
