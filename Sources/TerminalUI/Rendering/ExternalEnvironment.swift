
package struct ExternalEnvironment {
  let update: (inout EnvironmentValues) -> Void
}

extension ExternalEnvironment: ExpressibleByNilLiteral {
  package init(nilLiteral: ()) {
    self.init { _ in }
  }
}
