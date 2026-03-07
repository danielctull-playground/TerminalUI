
package protocol Event: Sendable {
  func updateEnvironment(_ environment: inout EnvironmentValues)
}

extension Event {
  func updateEnvironment(_ environment: inout EnvironmentValues) {}
}
