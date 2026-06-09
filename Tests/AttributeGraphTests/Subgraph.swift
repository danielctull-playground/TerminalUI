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

  @Test func `first subgraph is a child of the root subgraph`() {
    let graph = Graph()
    let child = graph.subgraph {}
    #expect(graph.parent(of: child) == graph.root)
    #expect(graph.children(of: graph.root) == [child])
    #expect(graph.parent(of: graph.root) == nil)
  }

  @Test func `a subgraph is a child of the subgraph it is created within`() {

    let graph = Graph()
    var inner: Subgraph!
    let outer = graph.subgraph {
      inner = graph.subgraph {}
    }

    #expect(graph.parent(of: graph.root) == nil)
    #expect(graph.parent(of: outer) == graph.root)
    #expect(graph.parent(of: inner) == outer)

    #expect(graph.children(of: graph.root) == [outer])
    #expect(graph.children(of: outer) == [inner])
    #expect(graph.children(of: inner) == [])
  }

  @Test func `invalidating a subgraph removes all its attributes`() {

    let graph = Graph()
    _ = graph.constant("a")
    let child = graph.subgraph {
      _ = graph.constant("")
    }

    #expect(graph.contains(child))
    #expect(graph.attributeCount == 2)

    graph.invalidate(child)
    #expect(graph.attributeCount == 1)
  }

  @Test func `invalidating a subgraph tears down its descendants`() {

    let graph = Graph()
    var inner: Subgraph!
    let outer = graph.subgraph {
      inner = graph.subgraph {
        _ = graph.constant(1)
      }
      _ = graph.constant(2)
    }

    #expect(graph.attributeCount == 2)
    #expect(graph.contains(graph.root) == true)
    #expect(graph.contains(outer) == true)
    #expect(graph.contains(inner) == true)
    #expect(graph.children(of: graph.root) == [outer])
    #expect(graph.children(of: outer) == [inner])

    graph.invalidate(outer)

    #expect(graph.attributeCount == 0)
    #expect(graph.contains(graph.root) == true)
    #expect(graph.contains(outer) == false)
    #expect(graph.contains(inner) == false)
    #expect(graph.children(of: graph.root) == [])
  }
}
