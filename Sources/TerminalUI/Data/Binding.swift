
@dynamicMemberLookup
@propertyWrapper
public struct Binding<Value> {

  private let get: () -> Value
  private let set: (Value) -> Void

  public init(
    get: @escaping () -> Value,
    set: @escaping (Value) -> Void
  ) {
    self.get = get
    self.set = set
  }

  public var wrappedValue: Value {
    get { get() }
    nonmutating set { set(newValue) }
  }

  public var projectedValue: Binding<Value> {
    self
  }

  public subscript<Subject>(
    dynamicMember keyPath: WritableKeyPath<Value, Subject>
  ) -> Binding<Subject> {
    Binding<Subject> {
      wrappedValue[keyPath: keyPath]
    } set: {
      wrappedValue[keyPath: keyPath] = $0
    }
  }
}

extension Binding {

  public init(projectedValue: Binding<Value>) {
    self = projectedValue
  }
}

extension Binding {

  public static func constant(_ value: Value) -> Binding {
    Binding { value } set: { _ in }
  }
}

// MARK: - Optional

extension Binding {

  public init<V>(_ base: Binding<V>) where Value == V? {
    self.init {
      base.wrappedValue
    } set: { optional in
      switch optional {
      case .none: return
      case .some(let value): base.wrappedValue = value
      }
    }
  }

  public init?(_ base: Binding<Value?>) {
    guard base.wrappedValue != nil else { return nil }
    self.init {
      switch base.wrappedValue {
      case .none: fatalError("Accessed binding after value became nil.")
      case .some(let value): return value
      }
    } set: {
      base.wrappedValue = $0
    }
  }
}

// MARK: - Identifiable

extension Binding: Identifiable where Value: Identifiable {

  public var id: Value.ID {
    wrappedValue.id
  }
}

// MARK: - Sequence

extension Binding: Sequence where Value: MutableCollection {
  public typealias Element = Binding<Value.Element>
  public typealias Iterator = IndexingIterator<Binding<Value>>
  public typealias SubSequence = Slice<Binding<Value>>
}

// MARK: - Collection

extension Binding: Collection where Value: MutableCollection {

  public typealias Index = Value.Index
  public typealias Indices = Value.Indices

  public var startIndex: Index {
    wrappedValue.startIndex
  }

  public var endIndex: Index {
    wrappedValue.endIndex
  }

  public var indices: Indices {
    wrappedValue.indices
  }

  public func index(after index: Index) -> Index {
    wrappedValue.index(after: index)
  }

  public func formIndex(after index: inout Index) {
    wrappedValue.formIndex(after: &index)
  }

  public subscript(position: Index) -> Element {
    Element {
      wrappedValue[position]
    } set: {
      wrappedValue[position] = $0
    }
  }
}

// MARK: - BidirectionalCollection

extension Binding: BidirectionalCollection where Value: BidirectionalCollection, Value: MutableCollection {

  public func index(before index: Index) -> Index {
    wrappedValue.index(before: index)
  }

  public func formIndex(before index: inout Index) {
    wrappedValue.formIndex(before: &index)
  }
}

// MARK: - RandomAccessCollection

extension Binding: RandomAccessCollection where Value: RandomAccessCollection, Value: MutableCollection {}
