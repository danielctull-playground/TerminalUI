
struct LayoutComputer {

  private let size: (ProposedViewSize) -> Size
  private let content: (Rect) -> DisplayList

  @Mutable private var frame: Rect? = nil

  init(
    size: @escaping (ProposedViewSize) -> Size,
    render: @escaping (Rect) -> DisplayList
  ) {
    self.size = size
    self.content = render
  }

  func size(for proposal: ProposedViewSize) -> Size {
    size(proposal)
  }

  /// Records the frame the parent placed this view in. Geometry now arrives as
  /// *stored data*, not as an argument to the render call.
  func place(in frame: Rect) {
    self.frame = frame
  }

  func render() -> DisplayList {

    guard let frame, frame.size.height > 0, frame.size.width > 0 else {
      return DisplayList(items: [])
    }

    return content(frame)
  }
}
