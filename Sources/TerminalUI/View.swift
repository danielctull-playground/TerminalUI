
public protocol View {

  /// The type of view representing the body of this view.
  associatedtype Body: View

  /// The content and behavior of the view.
  var body: Body { get }
}

extension View {

  func displayItems(inputs: ViewInputs) -> [DisplayItem] {
    inputs.environment.install(on: self)
    if let builtin = self as? any Builtin {
      return builtin.displayItems(inputs: inputs)
    } else {
      return body.displayItems(inputs: inputs)
    }
  }
}
