
public struct HStack {

  @Mutable private var sizes: [Size] = []

  private let alignment: VerticalAlignment
  private let _spacing: Int?
  private let content: [any View]

  public init(
    alignment: VerticalAlignment = .center,
    spacing: Int? = nil,
    content: [any View]
  ) {
    self.alignment = alignment
    self._spacing = spacing
    self.content = content
  }
}

extension HStack {
  fileprivate var spacing: Int { _spacing ?? 0 }
}

extension HStack: Builtin, View {

  func size(
    for proposal: ProposedSize,
    environment: EnvironmentValues
  ) -> Size {

    let flexibilities = content.map { child in
      let min = ProposedSize(width: 0, height: proposal.height)
      let max = ProposedSize(width: .max, height: proposal.height)
      let smallest = child._size(for: min)
      let largest = child._size(for: max)
      return largest.width - smallest.width
    }

    let children = zip(flexibilities, zip(content.indices, content))
      .sorted(by: \.0)
      .map(\.1)

    sizes = Array(repeating: .zero, count: children.count)
    let totalSpacing = spacing * (content.count - 1)
    var remainingChildren = children.count
    var remainingWidth = proposal.width - totalSpacing

    for (index, child) in children {

      let proposal = ProposedSize(
        width: remainingWidth / remainingChildren,
        height: proposal.height)

      let size = child._size(for: proposal, environment: environment)

      sizes[index] = size
      remainingChildren -= 1
      remainingWidth -= size.width
    }

    let width = sizes.map(\.width).reduce(0, +) + totalSpacing
    let height = sizes.map(\.height).max() ?? 0
    return Size(width: width, height: height)
  }

  func render(
    in canvas: any Canvas,
    size: Size,
    environment: EnvironmentValues
  ) {
    var offset = 0
    for (child, childSize) in zip(content, sizes) {
      let y = alignment.value(in: size) - alignment.value(in: childSize)
      let canvas = canvas.translateBy(x: offset, y: y)
      child._render(in: canvas, size: childSize, environment: environment)
      offset += childSize.width + spacing
    }
  }
}

extension Sequence {
  fileprivate func sorted<Value: Comparable>(
    by keyPath: KeyPath<Element, Value>
  ) -> [Element] {
    sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
  }
}

extension Size {
  fileprivate static var zero: Size { Size(width: 0, height: 0) }
}
