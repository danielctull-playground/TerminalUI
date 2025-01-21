
package final class Rule<Value> {

  package let name: Name
  private let make: () -> Value

  package var value: Value {
    make()
  }

  init(name: Name, make: @escaping () -> Value) {
    self.name = name
    self.make = make
  }
}

// MARK: - Rule.Name

extension Rule {
  package typealias Name = RuleName
}

package struct RuleName: Equatable {
  private let raw: String
}

extension Rule.Name: ExpressibleByStringLiteral {
  package init(stringLiteral value: String) {
    self.init(raw: value)
  }
}

extension Rule.Name: CustomStringConvertible {
  package var description: String { raw }
}
