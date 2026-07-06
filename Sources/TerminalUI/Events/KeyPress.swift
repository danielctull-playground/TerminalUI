
struct KeyPress: Equatable, Sendable {
  let character: Character
}

extension KeyPress: Event {
  func updateEnvironment(_ environment: inout EnvironmentValues) {
    environment.focusManager.handle(self)
  }
}

extension KeyPress: ExpressibleByUnicodeScalarLiteral {
  init(unicodeScalarLiteral value: Character) {
    self.init(character: value)
  }
}

extension KeyPress {
  static let tab: KeyPress = "\t"
}

// MARK: Sequence modifier

extension AsyncSequence where Self: Sendable, Element == any Event {

  var keyPressEvents: some Sendable & AsyncSequence<any Event, Failure> {
    map { event in
      guard let byte = event as? Byte else { return event }
      return KeyPress(character: Character(Unicode.Scalar(byte.rawValue)))
    }
  }
}
