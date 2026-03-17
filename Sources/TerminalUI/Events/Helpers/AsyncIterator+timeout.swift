
extension AsyncIteratorProtocol where Self: Sendable, Element: Sendable {

  /// Returns the next element or `nil` if timeout elapses first.
  ///
  /// The iterator's next call and a sleep are raced in child tasks.
  /// If the sleep wins, the iterator task is cancelled and `nil` is
  /// returned immediately. If an element arrives first the sleep task
  /// is cancelled and the element is returned.
  ///
  /// - Parameters:
  ///   - duration: Maximum time to wait for the next element.
  ///   - clock: The clock used to measure the interval.
  mutating func next<C: Clock>(
    timeout duration: C.Instant.Duration,
    clock: C = .continuous
  ) async throws(Failure) -> Element? {

    do {

      let _self = self

      let result = try await withThrowingTaskGroup(of: RaceResult<Self>.self) { group in

        group.addTask {
          var iterator = _self
          let element = try await iterator.next()
          return .element(iterator, element)
        }

        group.addTask {
          try await clock.sleep(for: duration)
          return .timeout
        }

        defer { group.cancelAll() }
        return try await group.next()!
      }

      switch result {
      case .element(let updatedIterator, let element):
        self = updatedIterator
        return element
      case .timeout:
        return nil
      }

    } catch let error as Failure {
      throw error

    } catch {
      fatalError(error.localizedDescription)
    }
  }
}

private enum RaceResult<Iterator>: Sendable
  where
  Iterator: AsyncIteratorProtocol,
  Iterator: Sendable,
  Iterator.Element: Sendable
{
  case element(Iterator, Iterator.Element?)
  case timeout
}
