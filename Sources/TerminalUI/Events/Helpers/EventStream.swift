import AsyncAlgorithms

@resultBuilder
enum EventStream {

  static func buildExpression<Failure: Error>(
    _ expression: some Sendable & AsyncSequence<any Event, Failure>
  ) -> some Sendable & AsyncSequence<any Event, any Error> {
    expression.mapError { $0 as any Error }
  }

  static func buildExpression(
    _ expression: some Sendable & AsyncSequence<some Event, Never>
  ) -> some Sendable & AsyncSequence<any Event, any Error> {
    expression.map { $0 as any Event }
  }

  static func buildExpression(
    _ expression: some Sendable & AsyncSequence<some Event, any Error>
  ) -> some Sendable & AsyncSequence<any Event, any Error> {
    expression.map { $0 as any Event }
  }

  static func buildPartialBlock(
    first: some Sendable & AsyncSequence<any Event, any Error>
  ) -> some Sendable & AsyncSequence<any Event, any Error> {
    first
  }

  static func buildPartialBlock(
    accumulated: some Sendable & AsyncSequence<any Event, any Error>,
    next: some Sendable & AsyncSequence<any Event, any Error>
  ) -> some Sendable & AsyncSequence<any Event, any Error> {
    merge(accumulated, next)
  }
}
