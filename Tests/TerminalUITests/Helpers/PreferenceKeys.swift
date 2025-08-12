import TerminalUI

struct PreferenceKeyA: PreferenceKey {
  static var defaultValue: String { "A" }
  static func reduce(value: inout String, nextValue: () -> String) {
    value.append(nextValue())
  }
}

struct PreferenceKeyB: PreferenceKey {
  static var defaultValue: String { "B" }
  static func reduce(value: inout String, nextValue: () -> String) {
    value.append(nextValue())
  }
}

extension PreferenceKey {
  typealias A = PreferenceKeyA
  typealias B = PreferenceKeyB
}
