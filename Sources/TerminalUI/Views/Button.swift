
public struct Button<Label> {

  @FocusState private var isFocused: Bool
  @Environment(\.focusManager) private var focusManager
  private let action: () -> Void
  private let label: Label

  public init(action: @escaping () -> Void, @ViewBuilder label: () -> Label) {
    self.action = action
    self.label = label()
  }
}

// MARK: - View

extension Button: View where Label: View {

  public var body: some View {
    HStack {
      Text("[")
      label
      Text("]")
    }
    .bold(isFocused)
    .focusable()
    .focused($isFocused)
    .onKeyPress { keyPress in
      guard keyPress == .space || keyPress == .return else { return .ignored }
      action()
      return .handled
    }
  }
}
