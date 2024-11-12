
extension TextOutputStream {

  mutating func move(to position: Position) {
    write(position.controlSequence)
  }

  mutating func setForegroundColor(_ color: Color) {
    write(color.foreground)
  }

  mutating func setBackgroundColor(_ color: Color) {
    write(color.background)
  }

  mutating func setBold(_ bold: Bold) {
    write(ControlSequence(bold.sgr))
  }

  mutating func setItalic(_ italic: Italic) {
    write(ControlSequence(italic.sgr))
  }

  mutating func setUnderline(_ underline: Underline) {
    write(ControlSequence(underline.sgr))
  }

  mutating func setBlinking(_ blinking: Blinking) {
    write(ControlSequence(blinking.sgr))
  }

  mutating func setInverse(_ inverse: Inverse) {
    write(ControlSequence(inverse.sgr))
  }

  mutating func setHidden(_ hidden: Hidden) {
    write(ControlSequence(hidden.sgr))
  }

  mutating func setStrikethrough(_ strikethrough: Strikethrough) {
    write(ControlSequence(strikethrough.sgr))
  }

  mutating func write(_ character: Character) {
    write(String(character))
  }
}
