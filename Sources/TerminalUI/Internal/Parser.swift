
struct Parser<Collection: RandomAccessCollection> {

  private let collection: Collection
  private var index: Collection.Index

  init(_ collection: Collection) {
    self.collection = collection
    self.index = collection.startIndex
  }

  func peek() -> Collection.Element? {
    guard index < collection.endIndex else { return nil }
    return collection[index]
  }

  @discardableResult
  mutating func advance() -> Collection.Element? {
    guard index < collection.endIndex else { return nil }
    defer { index = collection.index(after: index) }
    return collection[index]
  }

  var remaining: Collection.SubSequence? {
    guard index < collection.endIndex else { return nil }
    return collection[index...]
  }
}
