
package final class Attribute<Value> {

  package let name: Name
  package var value: Value

  init(name: Name, value: Value) {
    self.name = name
    self.value = value
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
