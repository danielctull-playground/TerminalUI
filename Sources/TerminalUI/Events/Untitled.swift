@preconcurrency import Dispatch

@available(macOS 15.0, *)
@MainActor
protocol Event {
  associatedtype Sequence: AsyncSequence<Self, Never>
  static var sequence: Sequence { get }
}

@available(macOS 15.0, *)
struct WindowChange: Event {
  let size: Size
}

@available(macOS 15.0, *)
extension WindowChange {

  static let sequence: some AsyncSequence<Self, Never> = AsyncStream(
    DispatchSource.makeSignalSource(signal: SIGWINCH)
  )
  .compactMap {
    var winsize = winsize()
    let result = ioctl(STDOUT_FILENO, UInt(TIOCGWINSZ), &winsize)
    guard result == EXIT_SUCCESS else { return nil }
    let size = Size(width: Int(winsize.ws_col), height: Int(winsize.ws_row))
    return WindowChange(size: size)
  }
}

extension AsyncStream<Void> {
  init(_ source: any DispatchSourceProtocol) {
    self.init { continuation in
      source.setEventHandler {
        continuation.yield(())
      }
      source.setCancelHandler {
        continuation.finish()
      }
      continuation.onTermination = { _ in
        source.cancel()
      }
      source.resume()
    }
  }
}
