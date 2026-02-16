
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

  init(displayItem: DisplayItem) {
    _sizeThatFits = displayItem.size(for:)
    _place = { position, proposal in
      displayItem.render(in: Rect(
        origin: position,
        size: displayItem.size(for: proposal)
      ))
    }
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

  public func callAsFunction(
    @ViewBuilder _ content: () -> some View
  ) -> some View {
    LayoutView(layout: self, content: content())
  }
}

private struct LayoutView<Content: View, Layout: TerminalUI.Layout>: PrimitiveView {

  private let layout: Layout
  private let content: Content

  init(layout: Layout, content: Content) {
    self.layout = layout
    self.content = content
  }

  static func makeView(
    view: GraphValue<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {
    ViewOutputs(
      preferenceValues: inputs.graph.attribute("[\(Layout.self)] preference values") {
        Content.makeView(view: view.content, inputs: inputs).preferenceValues
      },
      displayItems: inputs.graph.attribute("[\(Layout.self)] display items") {
        let content = Content.makeView(view: view.content, inputs: inputs).displayItems

        let subviews = LayoutSubviews(raw: content.map(LayoutSubview.init))

        let layout = view.value.layout
        var cache = layout.makeCache(subviews: subviews)

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
    )
  }
}
