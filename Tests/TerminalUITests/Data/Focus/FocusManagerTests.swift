import AttributeGraph
@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("FocusManager")
struct FocusManagerTests {

  private let graph = Graph()

  @Test func `focus manager needs to be set up at launch`() async {
    await #expect(processExitsWith: .failure) {
      _ = EnvironmentValues().focusManager
    }
  }

  @Test func `root handles when there's no other focus ids`() {

    var root: [KeyPress] = []
    let manager = FocusManager(graph: graph) {
      root.append($0)
      return .handled
    }

    manager.handle(KeyPress("Y"))
    #expect(root == [KeyPress("Y")])

    manager.handle(KeyPress("N"))
    #expect(root == [KeyPress("Y"), KeyPress("N")])
  }

  @Test func `handled focused key does not reach the root handler`() {

    var root: [KeyPress] = []
    let manager = FocusManager(graph: graph) {
      root.append($0)
      return .handled
    }

    var a: [KeyPress] = []
    _ = manager.add {
      a.append($0)
      return .handled
    }

    manager.handle(.tab)

    manager.handle(KeyPress("x"))
    #expect(root == [])
    #expect(a == [KeyPress("x")])
  }

  @Test func `ignored focused key reaches the root handler`() {

    var root: [KeyPress] = []
    let manager = FocusManager(graph: graph) {
      root.append($0)
      return .handled
    }

    _ = manager.add { _ in .ignored }

    manager.handle(.tab)
    manager.handle(KeyPress("x"))
    #expect(root == [KeyPress("x")])
  }

  @Test func `first non-root handler is activated`() {

    var root: [KeyPress] = []
    let manager = FocusManager(graph: graph) {
      root.append($0)
      return .handled
    }

    var a: [KeyPress] = []
    let aid = manager.add {
      a.append($0)
      return .handled
    }

    #expect(!manager.isFocused(aid))

    manager.handle(.tab)
    #expect(manager.isFocused(aid))

    manager.handle(KeyPress("1"))
    #expect(root == [])
    #expect(a == [KeyPress("1")])

    manager.handle(KeyPress("2"))
    #expect(root == [])
    #expect(a == [KeyPress("1"), KeyPress("2")])
  }

  @Test func `subsequent handlers are not activated`() {

    var root: [KeyPress] = []
    let manager = FocusManager(graph: graph) {
      root.append($0)
      return .handled
    }

    var a: [KeyPress] = []
    let aid = manager.add {
      a.append($0)
      return .handled
    }

    var b: [KeyPress] = []
    let bid = manager.add {
      b.append($0)
      return .handled
    }

    #expect(!manager.isFocused(aid))
    #expect(!manager.isFocused(bid))

    manager.handle(.tab)
    #expect(manager.isFocused(aid))
    #expect(!manager.isFocused(bid))

    manager.handle(KeyPress("1"))
    #expect(root == [])
    #expect(a == [KeyPress("1")])
    #expect(b == [])

    #expect(manager.isFocused(aid))
    #expect(!manager.isFocused(bid))

    manager.handle(KeyPress("2"))
    #expect(root == [])
    #expect(a == [KeyPress("1"), KeyPress("2")])
    #expect(b == [])
  }

  @Test func `tab toggles through non-root focus ids`() {

    var root: [KeyPress] = []
    let manager = FocusManager(graph: graph) {
      root.append($0)
      return .handled
    }

    var a: [KeyPress] = []
    let aid = manager.add {
      a.append($0)
      return .handled
    }

    var b: [KeyPress] = []
    let bid = manager.add {
      b.append($0)
      return .handled
    }

    #expect(!manager.isFocused(aid))
    #expect(!manager.isFocused(bid))

    manager.handle(.tab)
    #expect(manager.isFocused(aid))
    #expect(!manager.isFocused(bid))

    manager.handle(KeyPress("1"))
    #expect(root == [])
    #expect(a == [KeyPress("1")])
    #expect(b == [])

    manager.handle(.tab)
    #expect(!manager.isFocused(aid))
    #expect(manager.isFocused(bid))

    manager.handle(KeyPress("2"))
    #expect(root == [])
    #expect(a == [KeyPress("1")])
    #expect(b == [KeyPress("2")])

    manager.handle(.tab)
    #expect(manager.isFocused(aid))
    #expect(!manager.isFocused(bid))

    manager.handle(KeyPress("3"))
    #expect(root == [])
    #expect(a == [KeyPress("1"), KeyPress("3")])
    #expect(b == [KeyPress("2")])
  }

  @Test func `removing the current focus id moves to next focus`() {

    var root: [KeyPress] = []
    let manager = FocusManager(graph: graph) {
      root.append($0)
      return .handled
    }

    var a: [KeyPress] = []
    let aid = manager.add {
      a.append($0)
      return .handled
    }

    var b: [KeyPress] = []
    let bid = manager.add {
      b.append($0)
      return .handled
    }

    #expect(!manager.isFocused(aid))
    #expect(!manager.isFocused(bid))

    manager.handle(.tab)
    #expect(manager.isFocused(aid))
    #expect(!manager.isFocused(bid))

    manager.handle(KeyPress("1"))
    #expect(root == [])
    #expect(a == [KeyPress("1")])
    #expect(b == [])

    manager.remove(id: aid)
    #expect(!manager.isFocused(aid))
    #expect(manager.isFocused(bid))

    manager.handle(KeyPress("2"))
    #expect(root == [])
    #expect(a == [KeyPress("1")])
    #expect(b == [KeyPress("2")])
  }

  @Test func `removing non-current focus id doesn't move to next focus`() {

    var root: [KeyPress] = []
    let manager = FocusManager(graph: graph) {
      root.append($0)
      return .handled
    }

    var a: [KeyPress] = []
    let aid = manager.add {
      a.append($0)
      return .handled
    }

    var b: [KeyPress] = []
    let bid = manager.add {
      b.append($0)
      return .handled
    }

    var c: [KeyPress] = []
    let cid = manager.add {
      c.append($0)
      return .handled
    }

    #expect(!manager.isFocused(aid))
    #expect(!manager.isFocused(bid))
    #expect(!manager.isFocused(cid))

    manager.handle(.tab)
    #expect(manager.isFocused(aid))
    #expect(!manager.isFocused(bid))
    #expect(!manager.isFocused(bid))
    #expect(!manager.isFocused(cid))

    manager.handle(KeyPress("1"))
    #expect(root == [])
    #expect(a == [KeyPress("1")])
    #expect(b == [])
    #expect(c == [])

    manager.remove(id: bid)
    #expect(manager.isFocused(aid))
    #expect(!manager.isFocused(bid))
    #expect(!manager.isFocused(cid))

    manager.handle(KeyPress("2"))
    #expect(root == [])
    #expect(a == [KeyPress("1"), KeyPress("2")])
    #expect(b == [])
    #expect(c == [])
  }

  @Test func `removing all active focus id moves focus to root`() {

    var root: [KeyPress] = []
    let manager = FocusManager(graph: graph) {
      root.append($0)
      return .handled
    }

    var a: [KeyPress] = []
    let aid = manager.add {
      a.append($0)
      return .handled
    }

    var b: [KeyPress] = []
    let bid = manager.add {
      b.append($0)
      return .handled
    }

    #expect(!manager.isFocused(aid))
    #expect(!manager.isFocused(bid))

    manager.handle(.tab)
    #expect(manager.isFocused(aid))
    #expect(!manager.isFocused(bid))

    manager.handle(KeyPress("1"))
    #expect(root == [])
    #expect(a == [KeyPress("1")])
    #expect(b == [])

    manager.remove(id: aid)
    #expect(!manager.isFocused(aid))
    #expect(manager.isFocused(bid))

    manager.handle(KeyPress("2"))
    #expect(root == [])
    #expect(a == [KeyPress("1")])
    #expect(b == [KeyPress("2")])

    manager.remove(id: bid)
    #expect(!manager.isFocused(aid))
    #expect(!manager.isFocused(bid))

    manager.handle(KeyPress("3"))
    #expect(root == [KeyPress("3")])
    #expect(a == [KeyPress("1")])
    #expect(b == [KeyPress("2")])
  }

  @Test func `registering a focus ID does not activate the first ID`() {
    let manager = FocusManager(graph: graph)
    let id = FocusID.next
    manager.register(id)
    #expect(!manager.isFocused(id))
  }

  @Test func `registering an ID twice appends only one ID to the tab order`() {

    let manager = FocusManager(graph: graph)
    let a = FocusID.next
    let b = FocusID.next

    manager.register(a)

    manager.handle(.tab)
    #expect(manager.isFocused(a))

    manager.register(a)
    manager.register(b)

    manager.handle(.tab)
    #expect(manager.isFocused(b))

    manager.handle(.tab)
    #expect(manager.isFocused(a))
  }

  @Test func `setHandler installs a handler for a registered focus ID`() {

    let manager = FocusManager(graph: graph)
    let id = FocusID.next
    var received: [KeyPress] = []

    manager.register(id)
    manager.setHandler(
      { keyPress in
        received.append(keyPress)
        return .handled
      },
      for: id
    )

    manager.handle(.tab)
    manager.handle(KeyPress("x"))

    #expect(received == [KeyPress("x")])
  }

  @Test func `setHandler does not activate an unregistered focus ID`() {

    let manager = FocusManager(graph: graph)
    let registeredID = FocusID.next
    let unregisteredID = FocusID.next

    manager.register(registeredID)
    #expect(!manager.isFocused(registeredID))
    #expect(!manager.isFocused(unregisteredID))

    manager.handle(.tab)
    #expect(manager.isFocused(registeredID))
    #expect(!manager.isFocused(unregisteredID))

    manager.setHandler({ _ in .handled }, for: unregisteredID)
    #expect(manager.isFocused(registeredID))
    #expect(!manager.isFocused(unregisteredID))

    manager.handle(.tab)
    #expect(manager.isFocused(registeredID))
    #expect(!manager.isFocused(unregisteredID))
  }

  @Test func `focus activates a registered focus ID`() {
    let manager = FocusManager(graph: graph)
    let id = FocusID.next

    manager.register(id)
    #expect(!manager.isFocused(id))

    manager.focus(id)
    #expect(manager.isFocused(id))
  }

  @Test func `focus does not activate an unregistered focus ID`() {
    let manager = FocusManager(graph: graph)
    let id = FocusID.next
    manager.focus(id)
    #expect(!manager.isFocused(id))
  }

  @Test func `focus of unregistered id does not alter focus`() {
    let manager = FocusManager(graph: graph)
    let a = FocusID.next
    let b = FocusID.next

    manager.register(a)
    manager.focus(a)
    #expect(manager.isFocused(a))

    manager.focus(b)
    #expect(manager.isFocused(a))
    #expect(!manager.isFocused(b))
  }
}
