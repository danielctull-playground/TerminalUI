
package protocol Event: Sendable {
  func updateEnvironment(_ environment: inout EnvironmentValues)
}

extension Event {
  package func updateEnvironment(_ environment: inout EnvironmentValues) {}
}
