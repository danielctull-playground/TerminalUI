import TerminalUI
import Testing

public final class TestCanvas: Canvas {

  private var _pixels: [Position: Pixel] = [:]
  private let bounds: Rect

  public init(width: Int, height: Int) {
    bounds = Rect(origin: .origin, size: Size(width: width, height: height))
  }

  package func draw(_ draw: (Frame) -> Void) {
    var pixels: [Position: Pixel] = [:]
    let frame = Frame { pixel, position in
      pixels[position] = pixel
    }
    draw(frame)
    _pixels = pixels
  }
}

extension TestCanvas {

  public var pixels: [Position: Pixel] { _pixels }
  
  public func render(@ViewBuilder content: () -> some View) {
    render(size: bounds.size, content: content)
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
