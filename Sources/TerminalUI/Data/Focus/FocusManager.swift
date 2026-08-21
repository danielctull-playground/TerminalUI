import AttributeGraph

// MARK: - FocusManager

final class FocusManager {

  unowned let graph: Graph
  private let root: FocusID
  private var current: Attribute<FocusID>
  private var handlers: [FocusID: (KeyPress) -> KeyPress.Result]
  private var order: [FocusID]

  init(
    graph: Graph,
    unhandled handler: @escaping (KeyPress) -> KeyPress.Result = { _ in .ignored }
  ) {
    self.graph = graph
    current = graph.external(of: FocusID.self)
    root = FocusID.next
    handlers = [root: handler]
    order = []
    graph.setValue(of: current, to: root)
  }

  func isFocused(_ id: FocusID) -> Bool {
    graph[current] == id
  }

  func handle(_ keyPress: KeyPress) {
    if keyPress == .tab {
      _ = next()
      return
    }
    let id = graph[current]
    let result = handlers[id]?(keyPress) ?? .ignored

    if result == .ignored, id != root {
      _ = handlers[root]?(keyPress)
    }
  }

  func register(_ id: FocusID) {
    guard !order.contains(id) else { return }
    order.append(id)
  }

  func add(handler: @escaping (KeyPress) -> KeyPress.Result) -> FocusID {
    let id = FocusID.next
    register(id)
    setHandler(handler, for: id)
    return id
  }

  func setHandler(
    _ handler: @escaping (KeyPress) -> KeyPress.Result,
    for id: FocusID
  ) {
    handlers[id] = handler
  }

  func remove(id: FocusID) {
    if isFocused(id), !next() {
      graph.setValue(of: current, to: root)
    }
    handlers.removeValue(forKey: id)
    order.removeAll { $0 == id }
  }

  func focus(_ id: FocusID) {
    guard order.contains(id) else { return }
    graph.setValue(of: current, to: id)
  }

  private func next() -> Bool {

    if graph[current] == root, let first = order.first {
      graph.setValue(of: current, to: first)
      return true
    }

    guard order.count > 1 else { return false }
    let previous = order.firstIndex(of: graph[current])!
    var next = order.index(after: previous)
    if next == order.endIndex {
      next = order.startIndex
    }
    graph.setValue(of: current, to: order[next])
    return true
  }
}

// MARK: - EnvironmentKey

private struct FocusManagerKey: EnvironmentKey {
  static var defaultValue: FocusManager {
    fatalError("Focus manager needs to be set on launch")
  }
}

extension EnvironmentValues {
  var focusManager: FocusManager {
    get { self[FocusManagerKey.self] }
    set { self[FocusManagerKey.self] = newValue }
  }
}
