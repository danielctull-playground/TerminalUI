
package final class Attribute<Value> {

  package let name: Name
  private let makeValue: () -> Value

  package var value: Value {
    makeValue()
  }

  init(name: Name, makeValue: @escaping () -> Value) {
    self.name = name
    self.makeValue = makeValue
  }
}

// MARK: - Attribute.Name

extension Attribute {
  package typealias Name = AttributeName
}

package struct AttributeName: Equatable {
  private let raw: String
}

extension Attribute.Name: ExpressibleByStringLiteral {
  package init(stringLiteral value: String) {
    self.init(raw: value)
  }
}

extension Attribute.Name: CustomStringConvertible {
  package var description: String { raw }
}
