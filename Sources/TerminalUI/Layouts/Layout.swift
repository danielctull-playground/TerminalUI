import AttributeGraph

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

  private let layoutComputer: LayoutComputer
  @Mutable private(set) var displayList = DisplayList(items: [])

  init(layoutComputer: LayoutComputer) {
    self.layoutComputer = layoutComputer
  }

  public func sizeThatFits(_ proposal: ProposedViewSize) -> Size {
    layoutComputer.size(for: proposal)
  }

  public func place(at position: Position, proposal: ProposedViewSize) {
    let frame = Rect(origin: position, size: layoutComputer.size(for: proposal))
    displayList = layoutComputer.render(in: frame)
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
    view: Attribute<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {

    let content = Content.makeView(
      view: inputs.graph.map(view) { $0.content },
      inputs: inputs
    )

    return ViewOutputs(
      preferenceValues: content.preferenceValues,
      layoutComputers: inputs.graph.rule { graph in

        let subviews = LayoutSubviews(
          raw: graph[content.layoutComputers].map(LayoutSubview.init)
        )

        let layout = graph[view].layout
        var cache = layout.makeCache(subviews: subviews)

        let item = LayoutComputer { proposal in
          layout.sizeThatFits(
            proposal: proposal,
            subviews: subviews,
            cache: &cache)
        } render: { bounds in
          layout.placeSubviews(
            in: bounds,
            proposal: ProposedViewSize(bounds.size),
            subviews: subviews,
            cache: &cache
          )

          return DisplayList(items: subviews.flatMap(\.displayList.items))
        }

        return [item]
      }
    )
  }
}
