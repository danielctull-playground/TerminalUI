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

  @Test func `an input reads back its value`() {
    let graph = Graph()
    let a = graph.input(5)
    #expect(graph[a] == 5)
  }

  @Test func `setting an input updates the attributes computed from it`() {
    let graph = Graph()
    let a = graph.input(5)
    let b = graph.rule { $0[a] * 2 }
    #expect(graph[b] == 10)
    graph.setValue(of: a, to: 7)
    #expect(graph[b] == 14)
  }

  @Test func `a computed attribute recomputes only after its input changes`() {

    let graph = Graph()
    let a = graph.input(5)

    var count = 0
    let b = graph.rule { graph in
      count += 1
      return graph[a] * 2
    }

    // Lazy before any read.
    #expect(count == 0)

    // First read computes once.
    #expect(graph[b] == 10)
    #expect(count == 1)

    // Reading again with nothing changed is served from the cache.
    #expect(graph[b] == 10)
    #expect(count == 1)

    // Changing the input invalidates but does not eagerly recompute.
    graph.setValue(of: a, to: 7)
    #expect(count == 1)

    // The next read recomputes against the new input.
    #expect(graph[b] == 14)
    #expect(count == 2)
  }

  @Test func `setting an input to an equal value invalidates nothing`() {

    let graph = Graph()
    let a = graph.input(5)

    var count = 0
    let b = graph.rule { graph in
      count += 1
      return graph[a] * 2
    }

    #expect(graph[b] == 10)
    #expect(count == 1)

    // Setting the same value changes nothing: no invalidation, no recompute.
    graph.setValue(of: a, to: 5)
    #expect(graph[b] == 10)
    #expect(count == 1)

    // A genuinely different value does invalidate and recompute.
    graph.setValue(of: a, to: 7)
    #expect(graph[b] == 14)
    #expect(count == 2)
  }
}
