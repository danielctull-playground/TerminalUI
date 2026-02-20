@preconcurrency import Dispatch
import AsyncAlgorithms

@available(macOS 15.0, *)
@MainActor
protocol Event: Sendable {
  associatedtype Sequence: AsyncSequence<Self, Never> & Sendable
  static var sequence: Sequence { get }
}

@MainActor
func foo() -> some AsyncSequence<any Event, Never> {
  let a = WindowChange.sequence.map { $0 as any Event }
  let b = WindowChange.sequence.map { $0 as any Event }
  let c = WindowChange.sequence.map { $0 as any Event }
  return merge(a, b, c)
}

@available(macOS 15.0, *)
struct WindowChange: Event {
  let size: Size
}

@available(macOS 15.0, *)
extension WindowChange {

  static let sequence = AsyncStream(DispatchSource.makeSignalSource(signal: SIGWINCH)) {
    var winsize = winsize()
    let result = ioctl(STDOUT_FILENO, UInt(TIOCGWINSZ), &winsize)
    guard result == EXIT_SUCCESS else { fatalError() }
    let size = Size(width: Int(winsize.ws_col), height: Int(winsize.ws_row))
    return WindowChange(size: size)
  }
}

extension AsyncStream {
  init(_ source: any DispatchSourceProtocol, _ make: @escaping () -> Element) {
    self.init { continuation in
      source.setEventHandler {
        continuation.yield(make())
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
