@testable import AttributeGraph
import Testing

@Suite("External")
struct ExternalTests {

  @Test func `create`() {
    let graph = Graph()
    let external = graph.external("x", 12)
    #expect(external.wrappedValue == 12)
    #expect(external.name == "x")
    #expect(external.name.description == "x")
  }

  @Test func `update`() {
    let graph = Graph()
    let x = graph.external("x", 1)
    let y = x.projectedValue
    #expect(y.wrappedValue == 1)
    x.wrappedValue = 2
    #expect(y.wrappedValue == 2)
  }

  @Test func `dirty`() {
    let graph = Graph()
    let x = graph.external("x", 1)
    let y = x.projectedValue
    #expect(y.wrappedValue == 1)

    x.wrappedValue = 2
    #expect(y.dirty == true)
    #expect(y.wrappedValue == 2)
    #expect(y.dirty == false)
  }
}
