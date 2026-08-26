
extension View {

  public func focused(
    _ condition: FocusState<Bool>.Binding
  ) -> some View {
    modifier(Focused(binding: condition, value: true))
  }

  public func focused<Value: Hashable>(
    _ binding: FocusState<Value>.Binding,
    equals value: Value
  ) -> some View {
    modifier(Focused(binding: binding, value: value))
  }
}

private struct Focused<Value: Hashable, Content: View>: ViewModifier {

  @Environment(\.focusManager) private var focusManager
  @State private var id: FocusID?
  let binding: FocusState<Value>.Binding
  let value: Value

  func body(content: Content) -> some View {
    content
      // Focus manager changes focus to this element.
      .onChange(of: focusManager.focusedID) { _, focusedID in
        if id == focusedID {
          binding.value.wrappedValue = value
        } else if binding.value.wrappedValue == value {
          binding.value.wrappedValue = binding.unfocusedValue
        }
      }
      // The focus id from focusable.
      .onPreferenceChange(FocusIDKey.self) { id in
        self.id = id
        if let id {
          binding.ids.wrappedValue[value] = id
        }
      }
      // FocusState is programmatically set.
      .onChange(of: binding.value.wrappedValue) { _, newValue in
        if let id, newValue == value {
          focusManager.focus(id)
        }
      }
  }
}
