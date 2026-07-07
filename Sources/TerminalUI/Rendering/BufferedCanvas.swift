
private struct BufferedCanvas<Base: Canvas>: Canvas {

  let base: Base
  @Mutable private var pixels: [Position: Pixel] = [:]

  func draw(_ frame: (Frame) -> Void) {

    let previous = pixels

    frame(Frame { pixel, position in pixels[position] = pixel })

    let changed = pixels.filter { position, pixel in
      previous[position] != pixel
    }

    base.draw { frame in
      for (position, pixel) in changed {
        frame.draw(pixel, at: position)
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
