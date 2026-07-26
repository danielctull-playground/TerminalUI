
package protocol Event: Sendable {
  @MainActor
  func updateEnvironment(_ environment: inout EnvironmentValues)
}

extension Event {
  package func updateEnvironment(_ environment: inout EnvironmentValues) {}
}
