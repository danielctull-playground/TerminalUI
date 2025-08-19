
protocol LayoutModifier {

  typealias Subview = LayoutModifierSubview

  func sizeThatFits(
    proposal: ProposedViewSize,
    subview: Subview
  ) -> Size

  func placeSubview(
    in bounds: Rect,
    proposal: ProposedViewSize,
    subview: Subview
  )
}

// MARK: - LayoutModifierView

extension LayoutModifier {

  func callAsFunction(
    @ViewBuilder _ content: () -> some View
  ) -> some View {
    LayoutModifierView(layoutModifier: self, content: content())
  }
}

private struct LayoutModifierView<Content: View, LayoutModifier: TerminalUI.LayoutModifier>: View {

  private let layoutModifier: LayoutModifier
  private let content: Content

  init(layoutModifier: LayoutModifier, content: Content) {
    self.layoutModifier = layoutModifier
    self.content = content
  }

  var body: some View {
    fatalError("Body should never be called.")
  }

  static func makeView(inputs: ViewInputs<Self>) -> ViewOutputs {
    ViewOutputs(
      preferenceValues: inputs.graph.attribute("[\(LayoutModifier.self)] preference values") {
        Content.makeView(inputs: inputs.mapNode(\.content)).preferenceValues
      },
      displayItems: inputs.graph.attribute("[\(LayoutModifier.self)] display items") {

        let layoutModifier = inputs.node.layoutModifier

        return Content
          .makeView(inputs: inputs.mapNode(\.content))
          .displayItems
          .map { item in

            let subview = LayoutModifier.Subview(displayItem: item)

            return DisplayItem { proposal in
              layoutModifier.sizeThatFits(
                proposal: proposal,
                subview: subview)
            } render: { bounds in
              layoutModifier.placeSubview(
                in: bounds,
                proposal: ProposedViewSize(bounds.size),
                subview: subview)
            }
          }
      }
    )
  }
}

// MARK: - LayoutModifierSubview

public struct LayoutModifierSubview {

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
