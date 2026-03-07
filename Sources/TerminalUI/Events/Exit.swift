import Dispatch

struct Exit: Event {}

extension Exit {

  static var sequence: some AsyncSequence<Exit, Never> {
    AsyncStream(DispatchSource.makeSignalSource(signal: SIGINT))
      .map(Exit.init)
  }
}
