import Dispatch

struct Exit: Event {}

extension Exit {

  static var sequence: some Sendable & AsyncSequence<Exit, Never> {
    AsyncStream(DispatchSource.makeSignalSource(signal: SIGINT))
      .map(Exit.init)
  }
}
