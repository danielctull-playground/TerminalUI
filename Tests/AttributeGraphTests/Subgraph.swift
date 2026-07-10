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

  @Test func `an attribute created while evaluating is part of the evaluating subgraph`() {

    let graph = Graph()

    var created: Attribute<Int>!
    var rule: Attribute<Int>!
    let subgraph = graph.subgraph {
      rule = graph.rule { graph in
        created = graph.external(of: Int.self)
        return 1
      }
    }

    // Evaluate the rule *after* the build scope has closed (current subgraph is
    // back at the root), so what the rule creates is created during evaluation.
    #expect(graph[rule] == 1)

    #expect(graph.subgraph(of: created) == subgraph)
    #expect(graph.subgraph(of: created) != graph.root)
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

  @Test func `a subgraph hands back both itself and its body's result`() {

    let graph = Graph()

    let (subgraph, attribute) = graph.subgraph {
      graph.constant(1)
    }

    #expect(graph[attribute] == 1)
    #expect(graph.subgraph(of: attribute) == subgraph)
    #expect(subgraph != graph.root)
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

  @Test func `tearing down a subgraph should remove dependencies from remaining attributes`() {

    let graph = Graph()
    let a = graph.external(of: Int.self)
    graph.setValue(of: a, to: 1)

    var b: Attribute<Int>!
    let subgraph = graph.subgraph {
      b = graph.map(a) { $0 * 2 }
    }

    #expect(graph[a] == 1)
    #expect(graph[b] == 2)
    #expect(graph.edgeCount == 1)

    graph.invalidate(subgraph)
    #expect(graph.edgeCount == 0)

    // If the edge was still in play, then this would crash:
    graph.setValue(of: a, to: 5)
    #expect(graph[a] == 5)
  }

  @Test func `tearing down a subgraph should remove edges whose endpoints are both inside it`() {

    let graph = Graph()
    let a = graph.external(of: Int.self)
    graph.setValue(of: a, to: 1)

    var d: Attribute<Int>!
    let subgraph = graph.subgraph {
      let b = graph.map(a) { $0 + 1 }
      let c = graph.map(a) { $0 + 2 }
      d = graph.rule { graph in graph[b] + graph[c] }
    }

    #expect(graph[d] == 5)
    #expect(graph.edgeCount == 4)   // a->b, a->c, b->d, c->d

    graph.invalidate(subgraph)
    #expect(graph.edgeCount == 0)
    #expect(graph.contains(subgraph) == false)

    // If any edge into the removed diamond were still in play, this would crash:
    graph.setValue(of: a, to: 9)
    #expect(graph[a] == 9)
  }

  // Attributes store their update as a closure over the body. If any of those
  // closures captured the graph, the graph would retain itself through its
  // nodes and never be freed.
  @Test func `a graph is released once nothing else references it`() {

    weak var weakGraph: Graph?

    do { // This scoping causes weakGraph to become nilled out by the end.

      let graph = Graph()
      weakGraph = graph

      let a = graph.external(of: Int.self)
      graph.setValue(of: a, to: 1)
      let b = graph.map(a) { $0 + 1 }
      let c = graph.rule { $0[b] * 2 }
      #expect(graph[c] == 4)
    }

    #expect(weakGraph == nil)
  }

  @Suite struct Invalidation {

    @Test func `invalidating outside a withUpdate pass tears down immediately`() {

      let graph = Graph()
      let child = graph.subgraph { _ = graph.constant(1) }
      #expect(graph.contains(child) == true)
      #expect(graph.attributeCount == 1)

      graph.invalidate(child)
      #expect(graph.contains(child) == false)
      #expect(graph.attributeCount == 0)
    }

    @Test func `update pass defers invalidation`() {
      
      let graph = Graph()
      let trigger = graph.external(of: Int.self)
      graph.setValue(of: trigger, to: 1) // gives the pass work to do
      
      let child = graph.subgraph { _ = graph.constant(1) }
      
      graph.withUpdate {
        
        graph.invalidate(child)
        
        // withUpdate defers invalidation, so the child isn't removed while the
        // update is still doing structural work.
        #expect(graph.contains(child) == true)
      }

      // Returning from the pass runs the deferred invalidations.
      #expect(graph.contains(child) == false)
    }

    @Test func `update pass defers invalidation for multiple invalidations`() {

      let graph = Graph()

      let trigger = graph.external(of: Int.self)
      graph.setValue(of: trigger, to: 1)

      let a = graph.subgraph { _ = graph.constant(1) }
      let b = graph.subgraph { _ = graph.constant(2) }

      graph.withUpdate {
        graph.invalidate(a)
        graph.invalidate(b)

        #expect(graph.contains(a) == true)
        #expect(graph.contains(b) == true)
      }

      #expect(graph.contains(a) == false)
      #expect(graph.contains(b) == false)
    }

    @Test func `update pass tears down an ancestor and a descendant safely`() {

      let graph = Graph()
      let trigger = graph.external(of: Int.self)
      graph.setValue(of: trigger, to: 1)

      var inner: Subgraph!
      let outer = graph.subgraph {
        inner = graph.subgraph { _ = graph.constant(1) }
      }

      // The batch invalidates both; whichever runs first removes the other as a
      // descendant, and performInvalidation's contains-check keeps that safe.
      graph.withUpdate {
        graph.invalidate(inner)
        graph.invalidate(outer)
      }

      #expect(graph.contains(outer) == false)
      #expect(graph.contains(inner) == false)
    }

    @Test func `invalidating a subgraph releases the values its attributes held`() {

      // A class so the value's lifetime can be observed through a weak reference.
      final class Box {}

      let graph = Graph()
      weak var held: Box?

      let subgraph = graph.subgraph {
        let attribute = graph.external(of: Box.self)
        let box = Box()
        held = box
        graph.setValue(of: attribute, to: box)
      }

      // The graph keeps the value alive.
      #expect(held != nil)

      graph.invalidate(subgraph)
      #expect(held == nil)
    }

    @Test func `invalidating a subgraph releases the values held by its descendants`() {

      final class Box {}

      let graph = Graph()
      weak var outer: Box?
      weak var inner: Box?

      let subgraph = graph.subgraph {
        let a = graph.external(of: Box.self)
        let box = Box()
        outer = box
        graph.setValue(of: a, to: box)

        _ = graph.subgraph {
          let b = graph.external(of: Box.self)
          let box = Box()
          inner = box
          graph.setValue(of: b, to: box)
        }
      }

      #expect(outer != nil)
      #expect(inner != nil)

      graph.invalidate(subgraph)
      #expect(outer == nil)
      #expect(inner == nil)
    }

    @Test func `invalidating frees attributes created while evaluating`() {

      let graph = Graph()

      var rule: Attribute<Int>!
      let subgraph = graph.subgraph {
        rule = graph.rule { graph in
          _ = graph.external(of: Int.self)
          return 1
        }
      }

      _ = graph[rule] // creates the external during evaluation
      #expect(graph.attributeCount == 2) // the rule and the external

      graph.invalidate(subgraph)
      #expect(graph.attributeCount == 0) // both freed
    }

    @Test func `change-detection does not re-evaluate an invalidated subgraph`() {

      let graph = Graph()

      let mode = graph.external(of: Bool.self)
      graph.setValue(of: mode, to: true)   // does the parent read the child?

      let input = graph.external(of: Int.self)
      graph.setValue(of: input, to: 1)

      // `child` lives in its own subgraph and is only valid while input == 1
      // (models a ForEach row / Optional `.some` branch about to be removed).
      var child: Attribute<Int>!
      let sub = graph.subgraph {
        child = graph.rule { graph in
          precondition(graph[input] == 1, "dead read")
          return graph[input]
        }
      }

      // The parent reads the child only while `mode` is true.
      let parent = graph.rule { graph in
        graph[mode] ? graph[child] : -1
      }

      // Establishes dependencies: mode->parent, child->parent, input->child.
      #expect(graph[parent] == 1)

      // The pass that removes `child`: stop reading it (mode false), change
      // `input` so a stale re-evaluation of the child would trap, and invalidate
      // its subgraph.
      graph.setValue(of: mode, to: false)
      graph.setValue(of: input, to: 2)

      graph.withUpdate {

        // Invalidation is deferred to the end of the pass, so `child` still
        // exists here. Reading `parent` change-checks its inputs — and today
        // that re-evaluates the doomed `child` against the new `input`, trapping
        // in the precondition (a "dead read").
        graph.invalidate(sub)
        #expect(graph[parent] == -1)
      }

      // Once the pass ends the doomed subgraph is gone; nothing leaked.
      #expect(graph.contains(sub) == false)
      #expect(graph.attributeCount == 3) // mode, input, parent
    }
  }
}
