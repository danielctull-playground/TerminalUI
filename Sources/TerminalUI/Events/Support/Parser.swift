
struct OutOfBounds: Error {}

struct Parser<Collection: RandomAccessCollection> {

  private let collection: Collection
  var index: Collection.Index

  init(_ collection: Collection) {
    self.collection = collection
    self.index = collection.startIndex
  }

  var isFinished: Bool {
    index == collection.endIndex
  }

  func peek() -> Collection.Element? {
    guard index < collection.endIndex else { return nil }
    return collection[index]
  }

  @discardableResult
  mutating func advance() throws -> Collection.Element {
    guard index < collection.endIndex else { throw OutOfBounds() }
    defer { index = collection.index(after: index) }
    return collection[index]
  }

  var remaining: Collection.SubSequence? {
    guard index < collection.endIndex else { return nil }
    return collection[index...]
  }
}
