import Foundation
@testable import TerminalUI
import Testing

#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#elseif canImport(Musl)
import Musl
#endif

@Suite("WindowChange")
struct WindowChangeTests {

  @Test func initialValue() {
    #expect(EnvironmentValues().windowSize == .zero)
  }

  @Test func equatable() {
    let a = Int.random
    let b = Int.random
    let c = Int.random
    #expect(WindowChange(size: Size(width: a, height: b)) == WindowChange(size: Size(width: a, height: b)))
    #expect(WindowChange(size: Size(width: a, height: b)) != WindowChange(size: Size(width: a, height: c)))
    #expect(WindowChange(size: Size(width: a, height: b)) != WindowChange(size: Size(width: c, height: b)))
  }

  @Test
  func updateEnvironment() {
    let size = Size(width: .random(in: 0...1000), height: .random(in: 0...1000))
    let change = WindowChange(size: size)
    var environment = EnvironmentValues()
    change.updateEnvironment(&environment)
    #expect(environment.windowSize == size)
  }

  @Suite("Sequence", .serialized)
  struct SequenceTests: ~Copyable {

    private let controller: Int32
    private let terminal: Int32
    private let fileHandle: FileHandle

    init() {
      var controller: Int32 = 0
      var terminal: Int32 = 0
      var size = winsize(ws_row: 24, ws_col: 80, ws_xpixel: 0, ws_ypixel: 0)
      openpty(&controller, &terminal, nil, nil, &size)
      self.controller = controller
      self.terminal = terminal
      self.fileHandle = FileHandle(fileDescriptor: terminal)
    }

    deinit {
      close(controller)
      close(terminal)
    }

    private func setWindowSize(width: UInt16, height: UInt16) {
      var newSize = winsize(ws_row: height, ws_col: width, ws_xpixel: 0, ws_ypixel: 0)
      _ = ioctl(controller, UInt(TIOCSWINSZ), &newSize)
      // SIGWINCH isn't automatically sent to us because the pty
      // isn't our controlling terminal — send it manually
      kill(getpid(), SIGWINCH)
    }

    @Test func initial() async throws {
      var iterator = WindowChange.sequence(fileHandle: fileHandle)
        .makeAsyncIterator()
      let change = try await iterator.next()
      #expect(change == WindowChange(size: Size(width: 80, height: 24)))
    }

    @Test func resize() async throws {
      var iterator = WindowChange.sequence(fileHandle: fileHandle)
        .makeAsyncIterator()

      let initial = try await iterator.next()
      #expect(initial == WindowChange(size: Size(width: 80, height: 24)))

      setWindowSize(width: 120, height: 40)
      let change = try await iterator.next()
      #expect(change == WindowChange(size: Size(width: 120, height: 40)))
    }

    @Test func filtersDuplicates() async throws {
      var iterator = WindowChange.sequence(fileHandle: fileHandle)
        .makeAsyncIterator()

      let initial = try await iterator.next()
      #expect(initial == WindowChange(size: Size(width: 80, height: 24)))

      // Send SIGWINCH without changing size — removeDuplicates should suppress
      kill(getpid(), SIGWINCH)

      // Now ctually change size, should skip the
      // duplicate 80x24 and receive 120x40
      setWindowSize(width: 120, height: 40)
      let change = try await iterator.next()
      #expect(change == WindowChange(size: Size(width: 120, height: 40)))
    }

    @Test func `requires terminal`() async throws {
      await #expect(processExitsWith: .failure) {
        let pipe = Pipe()
        var iterator = WindowChange.sequence(fileHandle: pipe.fileHandleForReading)
          .makeAsyncIterator()
        _ = try await iterator.next()
      }
    }
  }
}
