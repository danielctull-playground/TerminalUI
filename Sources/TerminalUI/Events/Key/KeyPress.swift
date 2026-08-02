
public struct KeyPress: Equatable, Sendable {
  public let key: KeyEquivalent
  public let characters: String
}

extension KeyPress {
  init(_ character: Character) {
    self.init(
      key: KeyEquivalent(character),
      characters: String(character)
    )
  }
}

extension KeyPress: Event {
  package func updateEnvironment(_ environment: inout EnvironmentValues) {
    environment.focusManager.handle(self)
  }
}

extension KeyPress {
  static let tab = KeyPress(key: .tab, characters: "\t")
}

// MARK: Sequence modifier

extension AsyncSequence where Self: Sendable, Element == any Event {

  var keyPressEvents: some Sendable & AsyncSequence<any Event, Failure> {
    map { event in
      guard let byte = event as? Byte else { return event }
      return KeyPress(Character(Unicode.Scalar(byte.rawValue)))
    }
  }
}
