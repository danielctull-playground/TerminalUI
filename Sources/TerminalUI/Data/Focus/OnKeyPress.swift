
extension View {

  public func onKeyPress(
    action: @escaping (KeyPress) -> KeyPress.Result
  ) -> some View {
    modifier(OnKeyPress(action: action))
  }
}

struct OnKeyPress<Content: View>: ViewModifier {

  @Environment(\.focusManager) private var focusManager
  let action: (KeyPress) -> KeyPress.Result

  func body(content: Content) -> some View {
    content.onPreferenceChange(FocusIDKey.self) { id in
      if let id {
        focusManager.setHandler(action, for: id)
      }
    }
  }
}
