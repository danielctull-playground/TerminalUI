
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
    output.write(bold.control)
  }

  mutating func setItalic(_ italic: Italic) {
    output.write(italic.control)
  }

  mutating func setUnderline(_ underline: Underline) {
    output.write(underline.control)
  }

  mutating func setBlinking(_ blinking: Blinking) {
    output.write(blinking.control)
  }

  mutating func setInverse(_ inverse: Inverse) {
    output.write(inverse.control)
  }

  mutating func setHidden(_ hidden: Hidden) {
    output.write(hidden.control)
  }

  mutating func setStrikethrough(_ strikethrough: Strikethrough) {
    output.write(strikethrough.control)
  }

  mutating func write(_ character: Character) {
    output.write(String(character))
  }
}
