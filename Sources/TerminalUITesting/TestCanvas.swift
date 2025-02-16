import TerminalUI
import Testing

public struct TestCanvas: Canvas {

  @Mutable private var _pixels: [Position: Pixel] = [:]
  private let bounds: Rect

  public init(width: Int, height: Int) {
    bounds = Rect(origin: .origin, size: Size(width: width, height: height))
  }

  public func draw(_ pixel: Pixel, at position: Position) {
    _pixels[position] = pixel
  }
}

extension TestCanvas {

  public var pixels: [Position: Pixel] { _pixels }

  public func render(content: () -> some View) {
    render(in: bounds, content: content)
  }
}

extension TestCanvas: CustomStringConvertible {

  public var description: String {

    let ys = (bounds.minY...bounds.maxY)
    let xs = (bounds.minX...bounds.maxX)

    var characters: [[Character]] = ys.map { _ in xs.map { _ in " " } }

    for (position, pixel) in pixels {
      guard ys.contains(position.y) && xs.contains(position.x) else { continue }
      let y = bounds.origin.y.distance(to: position.y)
      let x = bounds.origin.x.distance(to: position.x)
      characters[y][x] = pixel.content
    }

    return characters
      .map { String($0) }
      .joined(separator: "\n")
  }
}
