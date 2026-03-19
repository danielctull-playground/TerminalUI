import Dispatch

#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#endif

struct Exit: Event {}

extension Exit {

  static var sequence: some Sendable & AsyncSequence<Exit, Never> {
    AsyncStream(DispatchSource.makeSignalSource(signal: SIGINT))
      .map { _ in Exit() }
  }
}
