
extension View {

  public func frame(
    minWidth: Int? = nil,
    idealWidth: Int? = nil,
    maxWidth: Int? = nil,
    minHeight: Int? = nil,
    idealHeight: Int? = nil,
    maxHeight: Int? = nil,
    alignment: Alignment = .center
  ) -> some View {
    FlexibleFrame(
      minWidth: minWidth,
      idealWidth: idealWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      idealHeight: idealHeight,
      maxHeight: maxHeight,
      alignment: alignment
    ) { self }
  }
}

struct FlexibleFrame: LayoutModifier {

  let minWidth: Int?
  let idealWidth: Int?
  let maxWidth: Int?
  let minHeight: Int?
  let idealHeight: Int?
  let maxHeight: Int?
  let alignment: Alignment

  func sizeThatFits(
    proposal: ProposedViewSize,
    subview: Subview
  ) -> Size {

    let proposal = ProposedViewSize(
      width: proposal.width ?? idealWidth,
      height: proposal.height ?? idealHeight
    )

    var size = proposal.replacingUnspecifiedDimensions()
    size.clamping(\.width, from: minWidth, to: maxWidth, fallback: size.width)
    size.clamping(\.height, from: minHeight, to: maxHeight, fallback: size.height)
    let contentSize = subview.sizeThatFits(ProposedViewSize(size))

    var result = proposal.replacingUnspecifiedDimensions()
    result.clamping(\.width, from: minWidth, to: maxWidth, fallback: contentSize.width)
    result.clamping(\.height, from: minHeight, to: maxHeight, fallback: contentSize.height)
    return result

  }

  func placeSubview(
    in bounds: Rect,
    proposal: ProposedViewSize,
    subview: Subview
  ) {
    let parent = alignment.position(for: bounds.size)
    let size = subview.sizeThatFits(ProposedViewSize(bounds.size))
    let child = alignment.position(for: size)
    let position = Position(
      x: bounds.origin.x + parent.x - child.x,
      y: bounds.origin.y + parent.y - child.y)
    subview.place(at: position, proposal: ProposedViewSize(size))
  }
}

extension Size {

  mutating func clamping(
    _ property: WritableKeyPath<Size, Int>,
    from minValue: Int?,
    to maxValue: Int?,
    fallback: Int
  ) {
    switch (minValue, maxValue) {
    case (.none, .none):
      self[keyPath: property] = fallback
    case let (.some(minValue), .some(maxValue)):
      self[keyPath: property] = max(minValue, min(self[keyPath: property], maxValue))
    case let (.some(minValue), .none):
      let maxValue = max(minValue, fallback)
      self[keyPath: property] = max(minValue, min(self[keyPath: property], maxValue))
    case let (.none, .some(maxValue)):
      let minValue = min(maxValue, fallback)
      self[keyPath: property] = max(minValue, min(self[keyPath: property], maxValue))
    }
  }
}
