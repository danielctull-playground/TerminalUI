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

    let manager = graph[inputs.environment].focusManager

    let id = manager.add { key in
      graph[view].text.wrappedValue.append(key.character)
    }

    return ViewOutputs(
      preferenceValues: graph.constant(.empty),
      displayItems: graph.rule { graph in

        var text = graph[view].text.wrappedValue
        if manager.isFocused(id) {
          text.append("_") // Cursor
        }
        let environment = inputs.graph[inputs.environment]

        return [
          DisplayItem { _ in
            Size(width: text.count, height: 1)
          } render: { rect in
            for (character, x) in zip(text, rect.origin.x...) {
              let pixel = Pixel(
                character,
                foreground: environment.foregroundColor,
                background: environment.backgroundColor,
                bold: environment.bold,
                italic: environment.italic,
                underline: environment.underline,
                blinking: environment.blinking,
                inverse: environment.inverse,
                hidden: environment.hidden,
                strikethrough: environment.strikethrough
              )
              inputs.canvas.draw(pixel, at: Position(x: x, y: rect.origin.y))
            }
          }
        ]
      }
    )
  }
}
