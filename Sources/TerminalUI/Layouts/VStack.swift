
public struct VStack {

  @Mutable private var sizes: [Size] = []

  private let alignment: HorizontalAlignment
  private let _spacing: Int?
  private let content: [any View]

  public init(
    alignment: HorizontalAlignment = .center,
    spacing: Int? = nil,
    content: [any View]
  ) {
    self.alignment = alignment
    self._spacing = spacing
    self.content = content
  }
}

extension VStack {
  fileprivate var spacing: Int { _spacing ?? 0 }
}

extension VStack: Builtin, View {

  func size(
    for proposal: ProposedViewSize,
    inputs: ViewInputs
  ) -> Size {

    let flexibilities = content.map { child in
      let min = ProposedViewSize(width: proposal.width, height: 0)
      let max = ProposedViewSize(width: proposal.width, height: .max)
      let smallest = child._size(for: min)
      let largest = child._size(for: max)
      return largest.height - smallest.height
    }

    let children = zip(flexibilities, zip(content.indices, content))
      .sorted(by: \.0)
      .map(\.1)

    sizes = Array(repeating: .zero, count: children.count)
    let totalSpacing = spacing * (content.count - 1)
    var remainingChildren = children.count
    var remainingHeight = proposal.replacingUnspecifiedDimensions().height - totalSpacing

    for (index, child) in children {

      let proposal = ProposedViewSize(
        width: proposal.width,
        height: remainingHeight / remainingChildren)

      let size = child._size(for: proposal, inputs: inputs)

      sizes[index] = size
      remainingChildren -= 1
      remainingHeight -= size.height
    }

    let width = sizes.map(\.width).max() ?? 0
    let height = sizes.map(\.height).reduce(0, +) + totalSpacing
    return Size(width: width, height: height)
  }

  func render(
    in canvas: any Canvas,
    bounds: Rect,
    inputs: ViewInputs
  ) {
    var offset = bounds.minY
    for (child, childSize) in zip(content, sizes) {
      let bounds = Rect(
        x: bounds.minX + alignment.value(in: bounds.size) - alignment.value(in: childSize),
        y: offset,
        width: childSize.width,
        height: childSize.height)
      child._render(in: canvas, bounds: bounds, inputs: inputs)
      offset += childSize.height + spacing
    }
  }
}
