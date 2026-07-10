import AttributeGraph

/// Represents a modification to the layout of display items.
///
/// This is used for modifiers that only adjust the layout of display items,
/// rather than add or change the number of display items. This allows
/// implementing code to be more concise and readable without having to deal
/// with defining a ``makeView`` function.
///
/// Examples:
///   * ``View/frame(width:height:alignment:)``
///   * ``View/fixedSize(horizontal:vertical:)``
///   * ``View/offset(size:)``
///
/// > Note: This is different from ``Layout`` as it acts on each individual
/// display item as opposed to the entire set of items.
protocol LayoutModifier {

  typealias Subview = LayoutSubview

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

private struct LayoutModifierView<Content: View, LayoutModifier: TerminalUI.LayoutModifier>: PrimitiveView {

  private let layoutModifier: LayoutModifier
  private let content: Content

  init(layoutModifier: LayoutModifier, content: Content) {
    self.layoutModifier = layoutModifier
    self.content = content
  }

  static func makeView(
    view: Attribute<Self>,
    inputs: ViewInputs
  ) -> ViewOutputs {

    unowned let graph = inputs.graph

    let content = Content.makeView(
      view: graph.map(view) { $0.content },
      inputs: inputs
    )

    return ViewOutputs(
      preferenceValues: content.preferenceValues,
      layoutComputers: inputs.graph.rule { _ in

        let layoutModifier = graph[view].layoutModifier

        return graph[content.layoutComputers]
          .map { layoutComputer in

            let subview = LayoutModifier.Subview(layoutComputer: layoutComputer)

            return LayoutComputer { proposal in
              layoutModifier.sizeThatFits(
                proposal: proposal,
                subview: subview
              )
            } place: { frame in

              // Because a layout modifier doesn't own its own geometry,
              // placing it just places the subview.
              layoutModifier.placeSubview(
                in: frame,
                proposal: ProposedViewSize(frame.size),
                subview: subview
              )
            }
          }
      },
      displayList: content.displayList
    )
  }
}
