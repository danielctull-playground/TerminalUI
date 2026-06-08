import AttributeGraph
import Testing

@Suite("Subgraph")
struct SubgraphTests {

  @Test func `attributes are owned by the subgraph current when they are created`() {

    let graph = Graph()

    let a = graph.constant(1)
    #expect(graph.subgraph(of: a) == graph.root)

    var b: Attribute<Int>!
    let subgraph = graph.subgraph {
      b = graph.constant(2)
    }
    #expect(graph.subgraph(of: b) == subgraph)
    #expect(subgraph != graph.root)

  }

  @Test func `the current subgraph is restored after a scope`() {

    let graph = Graph()

    let subgraph = graph.subgraph {
      _ = graph.constant(1)
    }

    // Once the scope ends, new attributes belong to the root again, not the child.
    let value = graph.constant(2)
    #expect(graph.subgraph(of: value) == graph.root)
    #expect(graph.subgraph(of: value) != subgraph)
  }
}
