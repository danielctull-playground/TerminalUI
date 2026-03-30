
package struct Mode: Equatable, Hashable, Sendable {
  fileprivate let marker: CSI.Marker?
  fileprivate let parameter: CSI.Parameter
}

extension Mode {

  static func ansi(_ parameter: CSI.Parameter) -> Mode {
    Mode(marker: nil, parameter: parameter)
  }

  static func dec(_ parameter: CSI.Parameter) -> Mode {
    Mode(marker: "?", parameter: parameter)
  }
}

// MARK: - Mode.Report

extension Mode {
  package struct Report {
    let mode: Mode
    let status: Status
  }
}

extension Mode.Report: CSIEvent {

  struct Invalid: Error {}

  init(csi: CSI) throws {

    guard
      csi.command == "y",
      csi.intermediates == "$",
      csi.parameters.elements.count == 2,
      let first = csi.parameters.elements.first,
      let second = csi.parameters.elements.last
    else {
      throw Invalid()
    }

    self.init(
      mode: Mode(marker: csi.marker, parameter: first),
      status: Mode.Status(parameter: second)
    )
  }
}

// MARK: - Mode.Status

extension Mode {

  package struct Status: Equatable {
    fileprivate let parameter: CSI.Parameter
  }
}

extension Mode.Status {
  static let notRecognized = Self(parameter: 0)
  static let set = Self(parameter: 1)
  static let reset = Self(parameter: 2)
  static let permanentlySet = Self(parameter: 3)
  static let permanentlyReset = Self(parameter: 4)
}

// MARK: - CSI commands

extension CSI {

  static func request(_ mode: Mode) -> CSI {
    CSI(marker: mode.marker, parameters: [mode.parameter], intermediates: "$", command: "p")
  }

  static func set(_ mode: Mode) -> CSI {
    CSI(marker: mode.marker, parameters: [mode.parameter], command: "h")
  }

  static func reset(_ mode: Mode) -> CSI {
    CSI(marker: mode.marker, parameters: [mode.parameter], command: "l")
  }
}
