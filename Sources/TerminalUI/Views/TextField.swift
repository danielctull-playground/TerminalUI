import AttributeGraph

public struct TextField {

  private let text: Binding<String>

  public init(text: Binding<String>) {
    self.text = text
  }
}

extension TextField: PrimitiveView {

  public static func makeView(
    view: Attribute<TextField>,
    inputs: ViewInputs
  ) -> ViewOutputs {

    unowned let graph = inputs.graph
    let geometry = graph.external(of: ViewGeometry.self)
    let manager = graph[inputs.environment].focusManager

    let id = manager.add { key in
      graph[view].text.wrappedValue.append(key.character)
    }

    return ViewOutputs(
      preferenceValues: graph.constant(.empty),
      layoutComputers: graph.rule { _ in

        var text = graph[view].text.wrappedValue
        if manager.isFocused(id) {
          text.append("_") // Cursor
        }
        let environment = graph[inputs.environment]

        return [
          LayoutComputer { _ in
            Size(width: text.count, height: 1)
          } place: { frame in
            graph.setValue(of: geometry, to: ViewGeometry(frame: frame))
          } render: {
            DisplayList(items: [
              DisplayList.Item(
                frame: graph[geometry].frame,
                content: .text(text, environment.style)
              )
            ])
          }
        ]
      }
    )
  }
}
