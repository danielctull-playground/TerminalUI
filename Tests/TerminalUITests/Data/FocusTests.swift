import AttributeGraph
@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("FocusManager")
struct FocusManagerTests {

  @Test func `root handles when there's no other focus ids`() {

    let graph = Graph()
    var root: [KeyPress] = []
    let manager = FocusManager(graph: graph) { root.append($0) }

    manager.handle("Y")
    #expect(root == ["Y"])

    manager.handle("N")
    #expect(root == ["Y", "N"])
  }

  @Test func `first non-root handler is activated`() {

    let graph = Graph()
    var root: [KeyPress] = []
    let manager = FocusManager(graph: graph) { root.append($0) }

    var a: [KeyPress] = []
    let aid = manager.add { a.append($0) }

    #expect(manager.isFocused(aid))

    manager.handle("1")
    #expect(root == [])
    #expect(a == ["1"])

    manager.handle("2")
    #expect(root == [])
    #expect(a == ["1", "2"])
  }

  @Test func `subsequent handlers are not activated`() {

    let graph = Graph()
    var root: [KeyPress] = []
    let manager = FocusManager(graph: graph) { root.append($0) }

    var a: [KeyPress] = []
    let aid = manager.add { a.append($0) }

    var b: [KeyPress] = []
    let bid = manager.add { b.append($0) }

    #expect(manager.isFocused(aid))
    #expect(!manager.isFocused(bid))

    manager.handle("1")
    #expect(root == [])
    #expect(a == ["1"])
    #expect(b == [])

    #expect(manager.isFocused(aid))
    #expect(!manager.isFocused(bid))

    manager.handle("2")
    #expect(root == [])
    #expect(a == ["1", "2"])
    #expect(b == [])
  }

  @Test func `tab toggles through non-root focus ids`() {

    let graph = Graph()
    var root: [KeyPress] = []
    let manager = FocusManager(graph: graph) { root.append($0) }

    var a: [KeyPress] = []
    let aid = manager.add { a.append($0) }

    var b: [KeyPress] = []
    let bid = manager.add { b.append($0) }

    #expect(manager.isFocused(aid))
    #expect(!manager.isFocused(bid))

    manager.handle("1")
    #expect(root == [])
    #expect(a == ["1"])
    #expect(b == [])

    manager.handle(.tab)
    #expect(!manager.isFocused(aid))
    #expect(manager.isFocused(bid))

    manager.handle("2")
    #expect(root == [])
    #expect(a == ["1"])
    #expect(b == ["2"])

    manager.handle(.tab)
    #expect(manager.isFocused(aid))
    #expect(!manager.isFocused(bid))

    manager.handle("3")
    #expect(root == [])
    #expect(a == ["1", "3"])
    #expect(b == ["2"])
  }

  @Test func `removing the current focus id moves to next focus`() {

    let graph = Graph()
    var root: [KeyPress] = []
    let manager = FocusManager(graph: graph) { root.append($0) }

    var a: [KeyPress] = []
    let aid = manager.add { a.append($0) }

    var b: [KeyPress] = []
    let bid = manager.add { b.append($0) }

    #expect(manager.isFocused(aid))
    #expect(!manager.isFocused(bid))

    manager.handle("1")
    #expect(root == [])
    #expect(a == ["1"])
    #expect(b == [])

    manager.remove(id: aid)
    #expect(!manager.isFocused(aid))
    #expect(manager.isFocused(bid))

    manager.handle("2")
    #expect(root == [])
    #expect(a == ["1"])
    #expect(b == ["2"])
  }

  @Test func `removing non-current focus id doesn't move to next focus`() {

    let graph = Graph()
    var root: [KeyPress] = []
    let manager = FocusManager(graph: graph) { root.append($0) }

    var a: [KeyPress] = []
    let aid = manager.add { a.append($0) }

    var b: [KeyPress] = []
    let bid = manager.add { b.append($0) }

    var c: [KeyPress] = []
    let cid = manager.add { c.append($0) }

    #expect(manager.isFocused(aid))
    #expect(!manager.isFocused(bid))
    #expect(!manager.isFocused(cid))

    manager.handle("1")
    #expect(root == [])
    #expect(a == ["1"])
    #expect(b == [])
    #expect(c == [])

    manager.remove(id: bid)
    #expect(manager.isFocused(aid))
    #expect(!manager.isFocused(bid))
    #expect(!manager.isFocused(cid))

    manager.handle("2")
    #expect(root == [])
    #expect(a == ["1", "2"])
    #expect(b == [])
    #expect(c == [])
  }

  @Test func `removing all active focus id moves focus to root`() {

    let graph = Graph()
    var root: [KeyPress] = []
    let manager = FocusManager(graph: graph) { root.append($0) }

    var a: [KeyPress] = []
    let aid = manager.add { a.append($0) }

    var b: [KeyPress] = []
    let bid = manager.add { b.append($0) }

    #expect(manager.isFocused(aid))
    #expect(!manager.isFocused(bid))

    manager.handle("1")
    #expect(root == [])
    #expect(a == ["1"])
    #expect(b == [])

    manager.remove(id: aid)
    #expect(!manager.isFocused(aid))
    #expect(manager.isFocused(bid))

    manager.handle("2")
    #expect(root == [])
    #expect(a == ["1"])
    #expect(b == ["2"])

    manager.remove(id: bid)
    #expect(!manager.isFocused(aid))
    #expect(!manager.isFocused(bid))

    manager.handle("3")
    #expect(root == ["3"])
    #expect(a == ["1"])
    #expect(b == ["2"])
  }
}
