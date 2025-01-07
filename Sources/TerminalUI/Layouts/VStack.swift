
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
    for proposal: ProposedSize,
    environment: EnvironmentValues
  ) -> Size {

    let flexibilities = content.map { child in
      let min = ProposedSize(width: proposal.width, height: 0)
      let max = ProposedSize(width: proposal.width, height: .max)
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
    var remainingHeight = proposal.height - totalSpacing

    for (index, child) in children {

      let proposal = ProposedSize(
        width: proposal.width,
        height: remainingHeight / remainingChildren)

      let size = child._size(for: proposal, environment: environment)

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
    size: Size,
    environment: EnvironmentValues
  ) {
    var offset = 0
    for (child, childSize) in zip(content, sizes) {
      let x = alignment.value(in: size) - alignment.value(in: childSize)
      let canvas = canvas.translateBy(x: x, y: offset)
      child._render(in: canvas, size: childSize, environment: environment)
      offset += childSize.height + spacing
    }
  }
}
