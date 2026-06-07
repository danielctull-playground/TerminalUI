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

  @Test func `a rule computes its value from another attribute`() {
    let graph = Graph()
    let a = graph.constant(3)
    let b = graph.rule { $0[a] * 2 }
    #expect(graph[b] == 6)
  }

  @Test func `a rule computes once and serves later reads from its cache`() {

    let graph = Graph()
    let a = graph.constant(3)

    var count = 0
    let b = graph.rule { graph in
      count += 1
      return graph[a] * 2
    }

    // Lazy: defining the rule computes nothing.
    #expect(count == 0)

    // First read computes exactly once.
    #expect(graph[b] == 6)
    #expect(count == 1)

    // Second read is served from the cache, with no recompute.
    #expect(graph[b] == 6)
    #expect(count == 1)
  }
}
