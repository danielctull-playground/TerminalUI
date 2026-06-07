import AttributeGraph
import Testing

@Suite("Graph")
struct GraphTests {

  @Test func `a constant attribute reads back its value`() {
    let graph = Graph()
    let constant = graph.constant(42)
    #expect(graph[constant] == 42)
  }

  @Test func `constants in the same graph are independent`() {
    let graph = Graph()
    let a = graph.constant("a")
    let b = graph.constant("b")
    #expect(graph[a] == "a")
    #expect(graph[b] == "b")
  }
}
