@testable import TerminalUI

extension Canvas {

  package func render(size: Size, content: () -> some View) {
    let renderer = Renderer(
      canvas: self,
      content: content
    )
    renderer.render(event: WindowChange(size: size))
  }
}
