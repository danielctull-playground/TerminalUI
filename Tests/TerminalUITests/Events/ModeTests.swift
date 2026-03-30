@testable import TerminalUI
import Testing

@Suite("Mode")
struct ModeTests {

  @Test func `report: failure`() {
    #expect(throws: Error.self) {
      try Mode.Report(csi: CSI(command: "a"))
    }
  }

  @Suite("ANSI")
  struct ANSI {

    @Test(arguments: [
      (0 as CSI.Parameter, Mode.Status.notRecognized   ),
      (1 as CSI.Parameter, Mode.Status.set             ),
      (2 as CSI.Parameter, Mode.Status.reset           ),
      (3 as CSI.Parameter, Mode.Status.permanentlySet  ),
      (4 as CSI.Parameter, Mode.Status.permanentlyReset),
    ])
    func report(parameter: CSI.Parameter, status: Mode.Status) throws {
      let csi = CSI(parameters: [1912, parameter], intermediates: "$", command: "y")
      let report = try Mode.Report(csi: csi)
      #expect(report.status == status)
      #expect(report.mode == .ansi(1912))
    }

    @Test func request() {
      let request = CSI.request(.ansi(1912))
      let expected = CSI(parameters: 1912, intermediates: "$", command: "p")
      #expect(request == expected)
    }

    @Test func set() {
      let request = CSI.set(.ansi(1912))
      let expected = CSI(parameters: 1912, command: "h")
      #expect(request == expected)
    }

    @Test func reset() {
      let request = CSI.reset(.ansi(1912))
      let expected = CSI(parameters: 1912, command: "l")
      #expect(request == expected)
    }
  }

  @Suite("DEC")
  struct DEC {

    @Test(arguments: [
      (0 as CSI.Parameter, Mode.Status.notRecognized   ),
      (1 as CSI.Parameter, Mode.Status.set             ),
      (2 as CSI.Parameter, Mode.Status.reset           ),
      (3 as CSI.Parameter, Mode.Status.permanentlySet  ),
      (4 as CSI.Parameter, Mode.Status.permanentlyReset),
    ])
    func report(parameter: CSI.Parameter, status: Mode.Status) throws {
      let csi = CSI(
        marker: "?",
        parameters: [1912, parameter],
        intermediates: "$",
        command: "y"
      )
      let report = try Mode.Report(csi: csi)
      #expect(report.status == status)
      #expect(report.mode == .dec(1912))
    }

    @Test func request() {
      let request = CSI.request(.dec(1912))
      let expected = CSI(marker: "?", parameters: 1912, intermediates: "$", command: "p")
      #expect(request == expected)
    }

    @Test func set() {
      let request = CSI.set(.dec(1912))
      let expected = CSI(marker: "?", parameters: 1912, command: "h")
      #expect(request == expected)
    }

    @Test func reset() {
      let request = CSI.reset(.dec(1912))
      let expected = CSI(marker: "?", parameters: 1912, command: "l")
      #expect(request == expected)
    }
  }
}
