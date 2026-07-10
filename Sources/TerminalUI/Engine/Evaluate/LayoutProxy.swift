
struct LayoutProxy {

  private let layoutComputer: LayoutComputer
  private let place: (Rect) -> Void

  init(
    layoutComputer: LayoutComputer,
    place: @escaping (Rect) -> Void,
  ) {
    self.layoutComputer = layoutComputer
    self.place = place
  }

  func size(for proposal: ProposedViewSize) -> Size {
    layoutComputer.size(for: proposal)
  }

  func place(in frame: Rect) {
    place(frame)
  }
}
