import TerminalUI
import Testing

public struct TestCanvas: Canvas {
  @Mutable package var pixels: [Position: Pixel] = [:]
  private let size: Size
  public init(width: Horizontal, height: Vertical) {
    size = Size(width: width, height: height)
  }
  public func draw(_ pixel: Pixel, at position: Position) {
    pixels[position] = pixel
  }
}

extension TestCanvas {
  public func render(content: () -> some View) {
    content()._render(in: self, size: size)
  }
}

extension TestCanvas: CustomStringConvertible {

  public var description: String {

    let origin = Position.origin
    let ys = (origin.y...size.height)
    let xs = (origin.x...size.width)

    var characters: [[Character]] = ys.map { _ in xs.map { _ in " " } }

    for (position, pixel) in pixels {
      guard ys.contains(position.y) && xs.contains(position.x) else { continue }
      let y = origin.y.distance(to: position.y)
      let x = origin.x.distance(to: position.x)
      characters[y][x] = pixel.content
    }

    return characters
      .map { String($0) }
      .joined(separator: "\n")
  }
}
