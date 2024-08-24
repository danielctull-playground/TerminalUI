
struct Italic: Equatable {
  let sgr: SelectGraphicRendition
  static let on = Italic(sgr: 3)
  static let off = Italic(sgr: 23)
}

struct Underline: Equatable {
  let sgr: SelectGraphicRendition
  static let on = Underline(sgr: 4)
  static let off = Underline(sgr: 24)
}

struct Blinking: Equatable {
  let sgr: SelectGraphicRendition
  static let on = Blinking(sgr: 5)
  static let off = Blinking(sgr: 25)
}

struct Inverse: Equatable {
  let sgr: SelectGraphicRendition
  static let on = Inverse(sgr: 7)
  static let off = Inverse(sgr: 27)
}

struct Hidden: Equatable {
  let sgr: SelectGraphicRendition
  static let on = Hidden(sgr: 8)
  static let off = Hidden(sgr: 28)
}

struct Strikethrough: Equatable {
  let sgr: SelectGraphicRendition
  static let on = Strikethrough(sgr: 9)
  static let off = Strikethrough(sgr: 29)
}
