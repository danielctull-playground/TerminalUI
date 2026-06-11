
protocol ArenaID: Hashable {
  var rawValue: Int { get }
  init(rawValue: Int)
}

struct Arena<ID: ArenaID, Value> {
  private var _values: [ID: Value] = [:]
  private var next = ID(rawValue: 0)
}

extension Arena {

  subscript(id: ID) -> Value {
    get {
      // Asking for an invalid id is a developer error.
      _values[id]!
    }
    set {
      _values[id] = newValue
    }
  }

  mutating func insert(_ value: Value) -> ID {
    defer { next = ID(rawValue: next.rawValue + 1) }
    _values[next] = value
    return next
  }

  mutating func remove(_ id: ID) {
    _values[id] = nil
  }

  func contains(_ id: ID) -> Bool {
    _values[id] != nil
  }

  var count: Int {
    _values.count
  }

  var values: some Collection<Value> {
    _values.values
  }
}
