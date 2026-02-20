@preconcurrency import Dispatch
import AsyncAlgorithms
import Darwin
import Foundation

@available(macOS 15.0, *)
@MainActor
protocol Event: Sendable {
  associatedtype Sequence: AsyncSequence<Self, any Error> & Sendable
  static var sequence: Sequence { get }
}

@MainActor
func foo() -> some AsyncSequence<any Event, any Error> {
  let windowChange = WindowChange.sequence.map { $0 as any Event }
  let input = Input.sequence.map { $0 as any Event }
  return merge(windowChange, input)
}

struct Input {
  let character: Character
}

extension Input: Event {

  static var sequence: some AsyncSequence<Input, any Error> & Sendable {
    FileHandle.standardInput
      .bytes
      .characters
      .map { Input(character: $0) }
  }
}

struct WindowChange {
  let size: Size
}

extension WindowChange: Event {

  static var sequence: some AsyncSequence<WindowChange, any Error> & Sendable {
    AsyncStream(DispatchSource.makeSignalSource(signal: SIGWINCH)) {
      var winsize = winsize()
      let result = ioctl(STDOUT_FILENO, UInt(TIOCGWINSZ), &winsize)
      guard result == EXIT_SUCCESS else { fatalError() }
      let size = Size(width: Int(winsize.ws_col), height: Int(winsize.ws_row))
      return WindowChange(size: size)
    }
    .map(\.self)
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
