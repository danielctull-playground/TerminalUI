
public struct Color: CustomStringConvertible, Equatable, Sendable, View {

  public let description: String
  let foreground: GraphicRendition
  let background: GraphicRendition

  public var body: some View {
    fatalError("Body should never be called.")
  }

  public static func makeView(inputs: ViewInputs<Self>) -> ViewOutputs {
    ViewOutputs(displayItems: inputs.graph.attribute("color") {[
      DisplayItem {
        $0.replacingUnspecifiedDimensions()
      } render: { bounds in
        let pixel = Pixel(" ", background: inputs.node)
        for x in bounds.minX...bounds.maxX {
          for y in bounds.minY...bounds.maxY {
            inputs.canvas.draw(pixel, at: Position(x: x, y: y))
          }
        }
      }
    ]})
  }
}

// MARK: - ANSI colors

extension Color {
  public static var black: Color { ansi(name: "black", foreground: 30, background: 40) }
  public static var red: Color { ansi(name: "red", foreground: 31, background: 41) }
  public static var green: Color { ansi(name: "green", foreground: 32, background: 42) }
  public static var yellow: Color { ansi(name: "yellow", foreground: 33, background: 43) }
  public static var blue: Color { ansi(name: "blue", foreground: 34, background: 44) }
  public static var magenta: Color { ansi(name: "magenta", foreground: 35, background: 45) }
  public static var cyan: Color { ansi(name: "cyan", foreground: 36, background: 46) }
  public static var white: Color { ansi(name: "white", foreground: 37, background: 47) }
  public static var `default`: Color { ansi(name: "default", foreground: 39, background: 49) }
}

extension Color {
  private static func ansi(
    name: String,
    foreground: GraphicRendition,
    background: GraphicRendition
  ) -> Color {
    Color(
      description: "ansi(\(name))",
      foreground: foreground,
      background: background)
  }
}

// MARK: - RGB

extension Color {

  public init(
    red: Double,
    green: Double,
    blue: Double
  ) {
    let r = red.in(0...255)
    let g = green.in(0...255)
    let b = blue.in(0...255)
    self.init(
      description: "red: \(red), green: \(green), blue: \(blue)",
      foreground: [38,2,r,g,b],
      background: [48,2,r,g,b]
    )
  }

  public init(white: Double) {
    let w = white.in(0...255)
    self.init(
      description: "white: \(white)",
      foreground: [38,2,w,w,w],
      background: [48,2,w,w,w]
    )
  }
}

extension Double {

  fileprivate func `in`(_ range: ClosedRange<Int>) -> Int {
    let upper = range.upperBound
    let lower = range.lowerBound
    return max(min(Int(Double(upper) * self) - lower, upper), lower)
  }
}
