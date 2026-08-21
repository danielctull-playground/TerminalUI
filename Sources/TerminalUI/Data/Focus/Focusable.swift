
extension View {

  public func focusable(_ isFocusable: Bool = true) -> some View {
    modifier(Focusable(isFocusable: isFocusable))
  }
}

private struct Focusable<Content: View>: ViewModifier {

  @Environment(\.focusManager) private var focusManager
  @State private var focusID: FocusID
  let isFocusable: Bool

  init(isFocusable: Bool) {
    self.isFocusable = isFocusable
    focusID = .next
  }

  func body(content: Content) -> some View {
    register(content: content)
  }

  private func register(content: Content) -> some View {

    if isFocusable {
      focusManager.register(focusID)
    }

    return content.preference(
      key: FocusIDKey.self,
      value: isFocusable ? focusID : nil
    )
  }
}
