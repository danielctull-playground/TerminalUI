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

  private let displayItem: DisplayItem

  /// Placement is recorded as a side effect of `place(at:proposal:)`, mirroring
  /// SwiftUI's public API (which returns `Void`). The recording is stored by
  /// reference so it survives the value-type copies handed out by
  /// `LayoutSubviews`, and is read back internally by the enclosing layout to
  /// assemble the display list.
  private final class Placement {
    var position: Position?
    var proposal: ProposedViewSize = .unspecified
  }
  private let placement = Placement()

  init(displayItem: DisplayItem) {
    self.displayItem = displayItem
  }

  public func sizeThatFits(_ proposal: ProposedViewSize) -> Size {
    displayItem.size(for: proposal)
  }

  public func place(
    at position: Position,
    proposal: ProposedViewSize
  ) {
    placement.position = position
    placement.proposal = proposal
  }

  /// The cells produced by rendering this subview at its recorded placement.
  /// Returns an empty list if the subview was never placed.
  func placed() -> DisplayList {
    guard let position = placement.position else { return [] }
    return displayItem.render(in: Rect(
      origin: position,
      size: displayItem.size(for: placement.proposal)
    ))
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
      view: inputs.graph.map(view, \.content),
      inputs: inputs
    )

    return ViewOutputs(
      preferenceValues: content.preferenceValues,
      displayItems: inputs.graph.rule { graph in

        let subviews = LayoutSubviews(
          raw: graph[content.displayItems].map(LayoutSubview.init)
        )

        let layout = graph[view].layout
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
          return DisplayList(items: subviews.flatMap { $0.placed().items })
        }

        return [item]
      }
    )
  }
}
