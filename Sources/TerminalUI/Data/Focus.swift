import AttributeGraph

// MARK: - FocusManager

final class FocusManager {

  unowned let graph: Graph
  private let root: FocusID
  private var current: Attribute<FocusID>
  private var handlers: [FocusID: (Character) -> Void]
  private var order: [FocusID]

  init(graph: Graph, unhandled handler: @escaping (Character) -> Void) {
    self.graph = graph
    current = graph.external(of: FocusID.self)
    root = FocusID.next
    handlers = [root: handler]
    order = []
    graph.setValue(of: current, to: root)
  }

  func handle(_ value: Character) {
    let id = graph[current]
    let handler = handlers[id]!
    handler(value)
  }

  func add(handler: @escaping (Character) -> Void) -> FocusID {
    let id = FocusID.next
    handlers[id] = handler
    order.append(id)

    if graph[current] == root {
      graph.setValue(of: current, to: id)
    }

    return id
  }

  func remove(id: FocusID) {
    if graph[current] == id, !_next() {
      graph.setValue(of: current, to: root)
    }
    handlers.removeValue(forKey: id)
    order.removeAll { $0 == id }
  }

  func next() {
    _ = _next()
  }

  private func _next() -> Bool {
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

// MARK: - FocusID

struct FocusID: Equatable, Hashable {
  private let rawValue: Int
}

extension FocusID {
  nonisolated(unsafe) private static var counter = 0
  fileprivate static var next: Self {
    defer { counter += 1 }
    return FocusID(rawValue: counter)
  }
}

extension FocusID: CustomStringConvertible {
  public var description: String {
    String(describing: rawValue)
  }
}
