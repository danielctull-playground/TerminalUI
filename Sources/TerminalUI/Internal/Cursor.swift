
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

  mutating func write(_ character: Character) {
    output.write(String(character))
  }
}
