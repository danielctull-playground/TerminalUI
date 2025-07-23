
public struct Either<First: View, Second: View>: Builtin, View {

  private enum Value {
    case first(First)
    case second(Second)
  }

  private let value: Value

  init(_ first: First) {
    value = .first(first)
  }

  init(_ second: Second) {
    value = .second(second)
  }

  func displayItems(inputs: ViewInputs) -> [DisplayItem] {
    switch value {
    case .first(let first): first.displayItems(inputs: inputs)
    case .second(let second): second.displayItems(inputs: inputs)
    }
  }
}
