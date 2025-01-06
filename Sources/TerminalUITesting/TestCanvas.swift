import TerminalUI
import Testing

public struct TestCanvas: Canvas {

  @Mutable private var _pixels: [Position: Pixel] = [:]
  private let size: ProposedSize

  public init(width: Int, height: Int) {
    size = ProposedSize(width: width, height: height)
  }

  public func draw(_ pixel: Pixel, at position: Position) {
    _pixels[position] = pixel
  }
}

extension TestCanvas {

  public var pixels: [Position: Pixel] { _pixels }

  public func render(content: () -> some View) {
    render(size: size, content: content)
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
