
struct Strikethrough: Equatable {
  let sgr: SelectGraphicRendition
  static let on = Strikethrough(sgr: 9)
  static let off = Strikethrough(sgr: 29)
}
