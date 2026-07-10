
struct LayoutComputer {

  private let size: (ProposedViewSize) -> Size

  init(
    size: @escaping (ProposedViewSize) -> Size
  ) {
    self.size = size
  }

  func size(for proposal: ProposedViewSize) -> Size {
    size(proposal)
  }
}
