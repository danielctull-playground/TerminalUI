
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
    for proposal: ProposedViewSize,
    inputs: ViewInputs
  ) -> Size {

    let flexibilities = content.map { child in
      let min = ProposedViewSize(width: 0, height: proposal.height)
      let max = ProposedViewSize(width: .max, height: proposal.height)
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
    var remainingWidth = proposal.replacingUnspecifiedDimensions().width - totalSpacing

    for (index, child) in children {

      let proposal = ProposedViewSize(
        width: remainingWidth / remainingChildren,
        height: proposal.height)

      let size = child._size(for: proposal, inputs: inputs)

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
    bounds: Rect,
    inputs: ViewInputs
  ) {
    var offset = bounds.minX
    for (child, childSize) in zip(content, sizes) {
      let bounds = Rect(
        x: offset,
        y: bounds.minY + alignment.value(in: bounds.size) - alignment.value(in: childSize),
        width: childSize.width,
        height: childSize.height)
      child._render(in: canvas, bounds: bounds, inputs: inputs)
      offset += childSize.width + spacing
    }
  }
}
