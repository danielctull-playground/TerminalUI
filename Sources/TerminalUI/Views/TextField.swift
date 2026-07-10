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
    graph.setValue(of: geometry, to: .zero)

    let focusManager = graph[inputs.environment].focusManager
    let id = focusManager.add { key in
      graph[view].text.wrappedValue.append(key.character)
    }

    return ViewOutputs(
      preferenceValues: graph.constant(.empty),
      layoutProxies: graph.rule { _ in

        var text = graph[view].text.wrappedValue
        if focusManager.isFocused(id) {
          text.append("_") // Cursor
        }

        return [
          LayoutProxy(
            layoutComputer: LayoutComputer { _ in
              Size(width: text.count, height: 1)
            },
            place: { frame in
              graph.setValue(of: geometry, to: ViewGeometry(frame: frame))
            }
          )
        ]
      },
      displayList: graph.rule { _ in

        let frame = graph[geometry].frame
        let environment = graph[inputs.environment]

        var text = graph[view].text.wrappedValue
        if focusManager.isFocused(id) {
          text.append("_") // Cursor
        }

        return DisplayList(items: [
          DisplayList.Item(
            frame: frame,
            content: .text(text, environment.style)
          )
        ])
      }
    )
  }
}
