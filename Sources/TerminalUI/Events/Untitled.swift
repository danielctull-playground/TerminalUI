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
  let mouse = MouseEvent.sequence.map { $0 as any Event }
  return merge(windowChange, input, mouse)
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

enum MouseButton: Sendable {
  case left
  case middle
  case right
  case wheelUp
  case wheelDown
  case other(Int)
}

enum MouseKind: Sendable {
  case down
  case up
  case drag
  case move
  case scroll
}

struct MouseEvent: Sendable {
  let kind: MouseKind
  let button: MouseButton?
  let position: Position
  let shift: Bool
  let option: Bool
  let control: Bool
}

extension MouseEvent: Event {

  static var sequence: some AsyncSequence<MouseEvent, any Error> & Sendable {
    Input.sequence
      .map(\.character)
      .parseMouseSGR()
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

extension AsyncSequence where Element == Character, Self: Sendable {
  fileprivate func parseMouseSGR() -> some AsyncSequence<MouseEvent, any Error> & Sendable {
    AsyncThrowingStream { continuation in
      Task { @MainActor in
        var buffer = ""
        for try await character in self {
          buffer.append(character)
          while let event = MouseSGRParser.parseNextEvent(from: &buffer) {
            continuation.yield(event)
          }
        }
        continuation.finish()
      }
    }
  }
}

private enum MouseSGRParser {
  static func parseNextEvent(from buffer: inout String) -> MouseEvent? {
    guard let escRange = buffer.range(of: "\u{1b}[<") else {
      buffer.removeAll(keepingCapacity: true)
      return nil
    }
    if escRange.lowerBound != buffer.startIndex {
      buffer.removeSubrange(buffer.startIndex..<escRange.lowerBound)
    }
    guard let endIndex = buffer.firstIndex(where: { $0 == "m" || $0 == "M" }) else {
      return nil
    }
    let payloadStart = buffer.index(escRange.lowerBound, offsetBy: 3)
    let payload = String(buffer[payloadStart..<endIndex])
    let terminator = buffer[endIndex]
    buffer.removeSubrange(buffer.startIndex...endIndex)

    let parts = payload.split(separator: ";", maxSplits: 2, omittingEmptySubsequences: false)
    guard parts.count == 3,
          let code = Int(parts[0]),
          let x = Int(parts[1]),
          let y = Int(parts[2]) else {
      return nil
    }

    let modifiers = MouseModifiers(code: code)
    let position = Position(x: x, y: y)
    let kind = MouseKind(code: code, terminator: terminator)
    let button = MouseButton(code: code, kind: kind)

    return MouseEvent(
      kind: kind,
      button: button,
      position: position,
      shift: modifiers.shift,
      option: modifiers.option,
      control: modifiers.control
    )
  }
}

private struct MouseModifiers {
  let shift: Bool
  let option: Bool
  let control: Bool

  init(code: Int) {
    shift = (code & 4) != 0
    option = (code & 8) != 0
    control = (code & 16) != 0
  }
}

private extension MouseKind {
  init(code: Int, terminator: Character) {
    let motion = (code & 32) != 0
    let wheel = (code & 64) != 0
    if wheel {
      self = .scroll
      return
    }
    if terminator == "m" {
      self = .up
      return
    }
    if motion {
      self = .drag
      return
    }
    self = .down
  }
}

private extension MouseButton {
  init?(code: Int, kind: MouseKind) {
    guard kind != .up else { return nil }
    if kind == .scroll {
      self = (code & 1) == 1 ? .wheelDown : .wheelUp
      return
    }
    switch code & 3 {
    case 0:
      self = .left
    case 1:
      self = .middle
    case 2:
      self = .right
    default:
      self = .other(code & 3)
    }
  }
}
