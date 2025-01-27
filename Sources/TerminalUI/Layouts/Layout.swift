
public protocol Layout {

  typealias Subviews = LayoutSubviews

  associatedtype Cache = Void

  func makeCache(
    subviews: Subviews
  ) -> Cache

  func sizeThatFits(
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout Cache
  ) -> Size

  func placeSubviews(
    in bounds: Rect,
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout Cache
  )
}

extension Layout {

  func callAsFunction(
    _ content: [any View]
  ) -> some View {

    let subviews = content.map { view in
      LayoutSubview(
        sizeThatFits: { proposal in
          view._size(for: proposal)
        },
        place: { position, proposal in
          
        })
    }

    return LayoutView(subviews: LayoutSubviews(raw: subviews), layout: self)
  }
}

// MARK: - LayoutSubviews

public struct LayoutSubviews {
  fileprivate let raw: [LayoutSubview]
}

extension LayoutSubviews: RandomAccessCollection {
  public typealias Index = Int
  public var startIndex: Index { raw.startIndex }
  public var endIndex: Index { raw.endIndex }
  public func index(after i: Int) -> Int { raw.index(after: i) }
  public func index(before i: Int) -> Int { raw.index(before: i) }
  public subscript(position: Index) -> LayoutSubview { raw[position] }
}

// MARK: - LayoutSubview

public struct LayoutSubview {

  private let _sizeThatFits: (ProposedViewSize) -> Size
  private let _place: (Position, ProposedViewSize) -> Void

  fileprivate init(
    sizeThatFits: @escaping (ProposedViewSize) -> Size,
    place: @escaping (Position, ProposedViewSize) -> Void
  ) {
    _sizeThatFits = sizeThatFits
    _place = place
  }

  public func sizeThatFits(_ proposal: ProposedViewSize) -> Size {
    _sizeThatFits(proposal)
  }

  public func place(
    at position: Position,
    proposal: ProposedViewSize
  ) {
    _place(position, proposal)
  }
}

// MARK: - LayoutView

private struct LayoutView<Layout: TerminalUI.Layout>: Builtin, View {

  let subviews: LayoutSubviews
  let layout: Layout
  @Mutable private var cache: Layout.Cache

  init(subviews: LayoutSubviews, layout: Layout) {
    self.subviews = subviews
    self.layout = layout
    self.cache = layout.makeCache(subviews: subviews)
  }

  func size(
    for proposal: ProposedViewSize,
    environment: EnvironmentValues
  ) -> Size {
    layout.sizeThatFits(
      proposal: proposal,
      subviews: subviews,
      cache: &cache)
  }

  func render(
    in canvas: any Canvas,
    size: Size,
    environment: EnvironmentValues
  ) {

    

  }
}
