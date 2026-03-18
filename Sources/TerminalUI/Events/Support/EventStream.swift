import AsyncAlgorithms

@resultBuilder
enum EventStream {

  static func buildExpression<Failure>(
    _ expression: some Sendable & AsyncSequence<some Event, Failure>
  ) -> some Sendable & AsyncSequence<any Event, Failure> {
    expression.map { $0 as any Event }
  }

  static func buildPartialBlock<Failure>(
    first: some Sendable & AsyncSequence<any Event, Failure>
  ) -> some Sendable & AsyncSequence<any Event, Failure> {
    first
  }

  static func buildPartialBlock<Failure>(
    accumulated: some Sendable & AsyncSequence<any Event, Failure>,
    next: some Sendable & AsyncSequence<any Event, Failure>
  ) -> some Sendable & AsyncSequence<any Event, Failure> {
    merge(accumulated, next)
  }
}
