
struct Cursor {

  private var output = Output.standard

  mutating func move(to position: Position) {
    output.write(position.controlSequence)
  }

  mutating func setForegroundColor(_ color: Color) {
    output.write(color.foreground)
  }

  mutating func setBackgroundColor(_ color: Color) {
    output.write(color.background)
  }

  mutating func setBold(_ bold: Bold) {
    output.write(ControlSequence(bold.sgr))
  }

  mutating func setItalic(_ italic: Italic) {
    output.write(ControlSequence(italic.sgr))
  }

  mutating func setUnderline(_ underline: Underline) {
    output.write(ControlSequence(underline.sgr))
  }

  mutating func setBlinking(_ blinking: Blinking) {
    output.write(ControlSequence(blinking.sgr))
  }

  mutating func setInverse(_ inverse: Inverse) {
    output.write(ControlSequence(inverse.sgr))
  }

  mutating func setHidden(_ hidden: Hidden) {
    output.write(ControlSequence(hidden.sgr))
  }

  mutating func setStrikethrough(_ strikethrough: Strikethrough) {
    output.write(ControlSequence(strikethrough.sgr))
  }

  mutating func write(_ character: Character) {
    output.write(String(character))
  }
}
