
public struct TextField {

  @FocusState private var isFocused: Bool
  @Environment(\.focusManager) private var focusManager
  private let text: Binding<String>

  public init(text: Binding<String>) {
    self.text = text
  }
}

extension TextField: View {

  public var body: some View {
    HStack {

      Text(text.wrappedValue)

      Cursor()
        .hidden(!isFocused)
    }
    .focusable()
    .focused($isFocused)
    .onKeyPress { keyPress in
      text.wrappedValue.append(keyPress.characters)
      return .handled
    }
  }
}
