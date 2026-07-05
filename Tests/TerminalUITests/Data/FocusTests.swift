import AttributeGraph
@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("FocusManager")
struct FocusManagerTests {

  @Test func `root handles when there's no other focus ids`() {

    let graph = Graph()
    var root: [Character] = []
    let manager = FocusManager(graph: graph) { root.append($0) }

    manager.handle("Y")
    #expect(root == ["Y"])

    manager.handle("N")
    #expect(root == ["Y", "N"])
  }

  @Test func `first non-root handler is activated`() {

    let graph = Graph()
    var root: [Character] = []
    let manager = FocusManager(graph: graph) { root.append($0) }

    var a: [Character] = []
    _ = manager.add { a.append($0) }

    manager.handle("1")
    #expect(root == [])
    #expect(a == ["1"])

    manager.handle("2")
    #expect(root == [])
    #expect(a == ["1", "2"])
  }

  @Test func `subsequent handlers are not activated`() {

    let graph = Graph()
    var root: [Character] = []
    let manager = FocusManager(graph: graph) { root.append($0) }

    var a: [Character] = []
    _ = manager.add { a.append($0) }

    var b: [Character] = []
    _ = manager.add { b.append($0) }

    manager.handle("1")
    #expect(root == [])
    #expect(a == ["1"])
    #expect(b == [])

    manager.handle("2")
    #expect(root == [])
    #expect(a == ["1", "2"])
    #expect(b == [])
  }

  @Test func `next toggles through non-root focus ids`() {

    let graph = Graph()
    var root: [Character] = []
    let manager = FocusManager(graph: graph) { root.append($0) }

    var a: [Character] = []
    _ = manager.add { a.append($0) }

    var b: [Character] = []
    _ = manager.add { b.append($0) }

    manager.handle("1")
    #expect(root == [])
    #expect(a == ["1"])
    #expect(b == [])

    manager.next()
    manager.handle("2")
    #expect(root == [])
    #expect(a == ["1"])
    #expect(b == ["2"])

    manager.next()
    manager.handle("3")
    #expect(root == [])
    #expect(a == ["1", "3"])
    #expect(b == ["2"])
  }

  @Test func `removing the current focus id moves to next focus`() {

    let graph = Graph()
    var root: [Character] = []
    let manager = FocusManager(graph: graph) { root.append($0) }

    var a: [Character] = []
    let aid = manager.add { a.append($0) }

    var b: [Character] = []
    _ = manager.add { b.append($0) }

    manager.handle("1")
    #expect(root == [])
    #expect(a == ["1"])
    #expect(b == [])

    manager.remove(id: aid)
    manager.handle("2")
    #expect(root == [])
    #expect(a == ["1"])
    #expect(b == ["2"])
  }

  @Test func `removing non-current focus id doesn't move to next focus`() {

    let graph = Graph()
    var root: [Character] = []
    let manager = FocusManager(graph: graph) { root.append($0) }

    var a: [Character] = []
    _ = manager.add { a.append($0) }

    var b: [Character] = []
    let bid = manager.add { b.append($0) }

    var c: [Character] = []
    _ = manager.add { c.append($0) }

    manager.handle("1")
    #expect(root == [])
    #expect(a == ["1"])
    #expect(b == [])
    #expect(c == [])

    manager.remove(id: bid)
    manager.handle("2")
    #expect(root == [])
    #expect(a == ["1", "2"])
    #expect(b == [])
    #expect(c == [])
  }

  @Test func `removing all active focus id moves focus to root`() {

    let graph = Graph()
    var root: [Character] = []
    let manager = FocusManager(graph: graph) { root.append($0) }

    var a: [Character] = []
    let aid = manager.add { a.append($0) }

    var b: [Character] = []
    let bid = manager.add { b.append($0) }

    manager.handle("1")
    #expect(root == [])
    #expect(a == ["1"])
    #expect(b == [])

    manager.remove(id: aid)
    manager.handle("2")
    #expect(root == [])
    #expect(a == ["1"])
    #expect(b == ["2"])

    manager.remove(id: bid)
    manager.handle("3")
    #expect(root == ["3"])
    #expect(a == ["1"])
    #expect(b == ["2"])
  }
}
