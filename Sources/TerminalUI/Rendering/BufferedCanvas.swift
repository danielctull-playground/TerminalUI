
private struct BufferedCanvas<Base: Canvas>: Canvas {

  let base: Base
  @Mutable private var pixels: [Position: Pixel] = [:]

  func drawFrame(_ frame: () -> Void) {

    let previous = pixels

    frame()

    let changed = pixels.filter { position, pixel in
      previous[position] != pixel
    }

    base.drawFrame {
      for (position, pixel) in changed {
        base.draw(pixel, at: position)
      }
    }
  }

  func draw(_ pixel: Pixel, at position: Position) {
    pixels[position] = pixel
  }
}

extension Canvas {

  func buffered() -> some Canvas {
    BufferedCanvas(base: self)
  }
}
