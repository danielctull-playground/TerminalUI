@testable import AttributeGraph
import Testing

@Suite("Input")
struct InputTests {

  @Test func `create`() {
    let graph = Graph()
    let input = graph.input("x", 12)
    #expect(input.wrappedValue == 12)
    #expect(input.name == "x")
    #expect(input.name.description == "x")
  }

  @Test func `update`() {
    let graph = Graph()
    let x = graph.input("x", 1)
    let y = x.projectedValue
    #expect(y.wrappedValue == 1)
    x.wrappedValue = 2
    #expect(y.wrappedValue == 2)
  }

  @Test func `dirty`() {
    let graph = Graph()
    let x = graph.input("x", 1)
    let y = x.projectedValue
    #expect(y.wrappedValue == 1)

    x.wrappedValue = 2
    #expect(y.dirty == true)
    #expect(y.wrappedValue == 2)
    #expect(y.dirty == false)
  }
}
