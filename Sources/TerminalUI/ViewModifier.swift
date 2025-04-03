
extension View {

  public func modifier<Modifier: ViewModifier>(
    _ modifier: Modifier
  ) -> some View where Modifier.Content == Self {
    ModifiedView(content: self, modifier: modifier)
  }
}

/// A modifier that you apply to a view or another view modifier, producing a
/// different version of the original value.
public protocol ViewModifier {

  /// The content view type passed to `body()`.
  associatedtype Content

  /// The type of view representing the body.
  associatedtype Body: View

  /// Gets the current body of the caller.
  func body(content: Content) -> Body
}

private struct ModifiedView<Content: View, Modifier: ViewModifier> where Content == Modifier.Content {
  let content: Content
  let modifier: Modifier
}

extension ModifiedView: View {

  var body: Modifier.Body {
    fatalError()
  }

  static func _makeView(_ inputs: ViewInputs<Self>) -> ViewOutputs {
    Body._makeView(inputs.map { view in view.modifier.body(content: view.content) })
  }
}
