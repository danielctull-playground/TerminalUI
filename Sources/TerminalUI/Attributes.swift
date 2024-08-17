
struct Bold: Equatable {
  let control: ControlSequence
  static let on = Bold(control: "1m")
  static let off = Bold(control: "22m")
}

struct Italic: Equatable {
  let control: ControlSequence
  static let on = Italic(control: "3m")
  static let off = Italic(control: "23m")
}

struct Underline: Equatable {
  let control: ControlSequence
  static let on = Underline(control: "4m")
  static let off = Underline(control: "24m")
}

struct Blinking: Equatable {
  let control: ControlSequence
  static let on = Blinking(control: "5m")
  static let off = Blinking(control: "25m")
}

struct Inverse: Equatable {
  let control: ControlSequence
  static let on = Inverse(control: "7m")
  static let off = Inverse(control: "27m")
}

struct Hidden: Equatable {
  let control: ControlSequence
  static let on = Hidden(control: "8m")
  static let off = Hidden(control: "28m")
}

struct Strikethrough: Equatable {
  let control: ControlSequence
  static let on = Strikethrough(control: "9m")
  static let off = Strikethrough(control: "29m")
}
