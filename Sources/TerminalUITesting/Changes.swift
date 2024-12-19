import TerminalUI
import Testing

extension Canvas {

  public func changes() -> ChangesCanvas {
    ChangesCanvas(base: self)
  }
}

public struct Change: Equatable {
  public let position: Position
  public let pixel: Pixel

  public init(position: Position, pixel: Pixel) {
    self.position = position
    self.pixel = pixel
  }
}

public struct ChangesCanvas: Canvas {

  let base: Canvas
  @Mutable private var _changes: [Change] = []

  public func draw(_ pixel: Pixel, at position: Position) {
    _changes.append(Change(position: position, pixel: pixel))
    base.draw(pixel, at: position)
  }
}

extension ChangesCanvas {
  public var changes: [Change] { _changes }
}
