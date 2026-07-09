
struct DisplayList: Equatable {
  let items: [Item]
}

// MARK: - DisplayList.Item

extension DisplayList {

  /// A single positioned piece of content.
  struct Item: Equatable {

    /// The cell bounds this content occupies, in absolute screen coordinates.
    var frame: Rect

    /// What to draw within `frame`.
    var content: Content
  }
}

// MARK: - DisplayList.Item.Content

extension DisplayList.Item {

  enum Content: Equatable {

    /// A string drawn into `frame` with a resolved `Style`.
    case text(String, Style)

    /// Fill every cell of `frame` with a resolved `Style`.
    case fill(Style)
  }
}
