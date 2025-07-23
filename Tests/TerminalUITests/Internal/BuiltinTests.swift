import TerminalUI
import Testing

@Suite("Builtin")
struct BuiltinTests {

  @Test func body_should_not_be_called() async {
    await #expect(processExitsWith: .failure) {
      _ = Text("").body
    }
  }
}
