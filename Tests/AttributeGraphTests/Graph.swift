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

  @Test func `an external has its value supplied from outside`() {
    let graph = Graph()
    let value = graph.external(of: String.self)

    graph.setValue(of: value, to: "a")
    #expect(graph[value] == "a")

    graph.setValue(of: value, to: "b")
    #expect(graph[value] == "b")
  }

  @Test func `an external must have its value set before access`() async {
    await #expect(processExitsWith: .failure) {
      let graph = Graph()
      let value = graph.external(of: String.self)
      _ = graph[value]
    }
  }

  @Test func `setting an external updates the attributes computed from it`() {
    let graph = Graph()
    let a = graph.external(of: Int.self)
    let b = graph.rule { $0[a] * 2 }

    graph.setValue(of: a, to: 5)
    #expect(graph[b] == 10)

    graph.setValue(of: a, to: 7)
    #expect(graph[b] == 14)
  }

  @Test func `a computed attribute recomputes only after its input changes`() {

    let graph = Graph()
    let a = graph.external(of: Int.self)

    var count = 0
    let b = graph.rule { graph in
      count += 1
      return graph[a] * 2
    }

    graph.setValue(of: a, to: 5)

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
    let a = graph.external(of: Int.self)

    var count = 0
    let b = graph.rule { graph in
      count += 1
      return graph[a] * 2
    }

    graph.setValue(of: a, to: 5)

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

  @Test func `an unchanged recomputation stops propagating to its dependents`() {

    let graph = Graph()
    let value = graph.external(of: Int.self)
    let isPositive = graph.rule { $0[value] > 0 }
    var computes = 0
    let label = graph.rule { graph in
      computes += 1
      return graph[isPositive] ? "positive" : "not positive"
    }

    graph.setValue(of: value, to: 5)

    #expect(graph[label] == "positive")
    #expect(computes == 1)

    // isPositive is reconsidered because value changes but because its value
    // didn't change, label should not recompute.
    graph.setValue(of: value, to: 10)
    #expect(graph[label] == "positive")
    #expect(computes == 1)

    graph.setValue(of: value, to: -3)
    #expect(graph[label] == "not positive")
    #expect(computes == 2)

    graph.setValue(of: value, to: -5)
    #expect(graph[label] == "not positive")
    #expect(computes == 2)
  }

  @Test func `map transforms one attribute into another`() {

    let graph = Graph()
    let a = graph.external(of: Int.self)
    let b = graph.map(a) { $0 * 2 }

    graph.setValue(of: a, to: 2)
    #expect(graph[b] == 4)

    graph.setValue(of: a, to: 5)
    #expect(graph[b] == 10)
  }

  @Test func `recomputing prunes edges to inputs no longer read`() {

    let graph = Graph()
    let useA = graph.external(of: Bool.self)
    let a = graph.external(of: Int.self)
    let b = graph.external(of: Int.self)

    graph.setValue(of: useA, to: true)
    graph.setValue(of: a, to: 1)
    graph.setValue(of: b, to: 2)

    var computations = 0
    let picked = graph.rule { graph in
      computations += 1
      return graph[useA] ? graph[a] : graph[b]
    }

    // Reads toggle and a, so two edges feed picked.
    #expect(graph[picked] == 1)
    #expect(computations == 1)
    #expect(graph.edgeCount == 2)

    // Switching to b, the edge from a must be pruned.
    graph.setValue(of: useA, to: false)
    #expect(graph[picked] == 2)
    #expect(computations == 2)
    #expect(graph.edgeCount == 2)

    // a is no longer used, so changing it must not mark picked as dirty.
    graph.setValue(of: a, to: 100)
    #expect(graph[picked] == 2)
    #expect(computations == 2)

    // b is used, so this causes a computation.
    graph.setValue(of: b, to: 3)
    #expect(graph[picked] == 3)
    #expect(computations == 3)
  }

  @Suite struct Updates {

    @Test func `writing an external value marks the graph as needing an update`() {
      let graph = Graph()
      #expect(graph.needsUpdate == false)
      let a = graph.external(of: Int.self)
      #expect(graph.needsUpdate == false)
      graph.setValue(of: a, to: 1)
      #expect(graph.needsUpdate == true)
    }

    @Test func `a constant doesn't mark the graph as needing an update`() {
      let graph = Graph()
      _ = graph.constant(1)
      #expect(graph.needsUpdate == false)
    }

    @Test func `a rule doesn't mark the graph as needing an update`() {
      let graph = Graph()
      let a = graph.constant(1)
      _ = graph.rule { $0[a] * 2 }
      #expect(graph.needsUpdate == false)
    }

    @Test func `a map doesn't mark the graph as needing an update`() {
      let graph = Graph()
      let a = graph.constant(1)
      _ = graph.map(a) { $0 * 2 }
      #expect(graph.needsUpdate == false)
    }

    @Test func `the update pass settles the graph after a burst of writes`() {
      let graph = Graph()
      let a = graph.external(of: Int.self)
      graph.setValue(of: a, to: 1)
      graph.setValue(of: a, to: 2)
      #expect(graph.needsUpdate == true)

      // However many writes happened, a single update resolves them.
      graph.update()
      #expect(graph.needsUpdate == false)
    }

    @Test func `writing an equal value after resolving needs no update`() {
      let graph = Graph()
      let a = graph.external(of: Int.self)

      graph.setValue(of: a, to: 1)
      #expect(graph.needsUpdate == true)

      graph.update()
      #expect(graph.needsUpdate == false)

      graph.setValue(of: a, to: 1)
      #expect(graph.needsUpdate == false)

      graph.setValue(of: a, to: 2)
      #expect(graph.needsUpdate == true)
    }
  }
}
