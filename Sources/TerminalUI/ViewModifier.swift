
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

private struct ModifiedView<Modifier: ViewModifier>: Builtin, View {

  let content: Modifier.Content
  let modifier: Modifier

  func size(
    for proposal: ProposedViewSize,
    inputs: ViewInputs
  ) -> Size {
    inputs.environment.install(on: modifier)
    return modifier
      .body(content: content)
      ._size(for: proposal, inputs: inputs)
  }

  func render(in canvas: any Canvas, size: Size, inputs: ViewInputs) {
    inputs.environment.install(on: modifier)
    modifier
      .body(content: content)
      ._render(in: canvas, size: size, inputs: inputs)
  }
}
