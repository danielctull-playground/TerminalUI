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

  init(layoutComputer: LayoutComputer) {
    self.layoutComputer = layoutComputer
  }

  public func sizeThatFits(_ proposal: ProposedViewSize) -> Size {
    layoutComputer.size(for: proposal)
  }

  public func place(at position: Position, proposal: ProposedViewSize) {
    let frame = Rect(origin: position, size: layoutComputer.size(for: proposal))
    guard frame.size.width > 0, frame.size.height > 0 else { return }
    layoutComputer.place(in: frame)
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

    unowned let graph = inputs.graph

    let geometry = graph.external(of: ViewGeometry.self)
    graph.setValue(of: geometry, to: .zero)

    let content = Content.makeView(
      view: graph.map(view) { $0.content },
      inputs: inputs
    )

    return ViewOutputs(
      preferenceValues: content.preferenceValues,
      layoutComputers: inputs.graph.rule { _ in

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
        } place: { frame in
          graph.setValue(of: geometry, to: ViewGeometry(frame: frame))

        }

        return [item]
      },
      displayList: inputs.graph.rule { _ in

        let frame = graph[geometry].frame
        guard frame.size.width > 0, frame.size.height > 0 else { return .empty }

        let subviews = LayoutSubviews(
          raw: graph[content.layoutComputers].map(LayoutSubview.init)
        )

        let layout = graph[view].layout
        var cache = layout.makeCache(subviews: subviews)

        // Fill the cache before placing, the layout contract.
        _ = layout.sizeThatFits(
          proposal: ProposedViewSize(frame.size),
          subviews: subviews,
          cache: &cache
        )

        // Placing the subviews writes each child's geometry external. Reading
        // `content.displayList` then recomputes.
        layout.placeSubviews(
          in: frame,
          proposal: ProposedViewSize(frame.size),
          subviews: subviews,
          cache: &cache
        )

        return graph[content.displayList]
      }
    )
  }
}
