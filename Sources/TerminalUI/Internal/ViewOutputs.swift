import AttributeGraph

// MARK: - ViewOutputs

struct ViewOutputs {
  @Attribute var layoutComputer: LayoutComputer
  @Attribute var displayList: DisplayList
}

// MARK: - LayoutComputer

struct LayoutComputer {

  private let _sizeThatFits: (ProposedViewSize) -> Size
  private let _childGeometries: (Rect) -> [Rect]

  init(
    sizeThatFits: @escaping (ProposedViewSize) -> Size,
    childGeometries: @escaping (Rect) -> [Rect]
  ) {
    _sizeThatFits = sizeThatFits
    _childGeometries = childGeometries
  }

  func sizeThatFits(_ proposal: ProposedViewSize) -> Size {
    _sizeThatFits(proposal)
  }

  func childGeometries(in bounds: Rect) -> [Rect] {
    _childGeometries(bounds)
  }
}

// MARK: - DisplayList

struct DisplayList {

  let items: [Item]

  struct Item {
    let name: String
    let render: (any Canvas) -> Void
  }
}
