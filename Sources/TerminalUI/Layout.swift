
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

extension Layout where Cache == () {
  func makeCache(subviews: Subviews) -> Cache { () }
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

extension Layout {

  public func callAsFunction(_ content: () -> [any View]) -> some View {
    LayoutView(layout: self, content: content())
  }
}

private struct LayoutView<Layout: TerminalUI.Layout>: Builtin, View {

  @Mutable private var cache: Layout.Cache
  private let layout: Layout
  private let content: [any View]

  init(layout: Layout, content: [any View]) {
    self.layout = layout
    self.content = content
    let subviews = LayoutSubviews(raw: content.map { _ in
      LayoutSubview { _ in .zero } place: { _, _ in }
    })
    cache = layout.makeCache(subviews: subviews)
  }

  func displayItems(inputs: ViewInputs) -> [DisplayItem] {
    let children = content.flatMap { $0.displayItems(inputs: inputs) }

    let subviews = LayoutSubviews(raw: children.map { item in
      LayoutSubview(sizeThatFits: item.size) { position, proposal in
        item.render(in: Rect(
          origin: position,
          size: item.size(for: proposal)
        ))
      }
    })


    let item = DisplayItem { proposal in
      layout.sizeThatFits(
        proposal: proposal,
        subviews: subviews,
        cache: &cache)
    } render: { bounds in
      layout.placeSubviews(
        in: bounds,
        proposal: ProposedViewSize(bounds.size),
        subviews: subviews,
        cache: &cache)
    }

    return [item]
  }
}
