
struct DisplayList: Equatable {
  let items: [Item]
}

extension DisplayList: ExpressibleByArrayLiteral {
  init(arrayLiteral elements: Item...) {
    self.init(items: elements)
  }
}

// MARK: - DisplayList.Item

extension DisplayList {

  struct Item: Equatable {
    let position: Position
    let pixel: Pixel
  }
}
