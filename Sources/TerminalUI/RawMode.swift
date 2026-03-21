
#if canImport(Darwin)
import Darwin
#elseif canImport(Glibc)
import Glibc
#endif

struct RawMode: ~Copyable {

  private let original: termios

  init() {
    var original = termios()
    tcgetattr(STDIN_FILENO, &original)
    self.original = original
    var raw = original
    cfmakeraw(&raw)
    tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw)
  }

  deinit {
    var original = original
    tcsetattr(STDIN_FILENO, TCSAFLUSH, &original)
  }
}
