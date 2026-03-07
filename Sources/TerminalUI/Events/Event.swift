
public protocol Event: Sendable {
  associatedtype Sequence: AsyncSequence<Self, any Error> & Sendable
  static var sequence: Sequence { get }

  func updateEnvironment(_ environment: inout EnvironmentValues)
}

extension Event {
  func updateEnvironment(_ environment: inout EnvironmentValues) {}
}
