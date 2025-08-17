import TerminalUI

extension Canvas {

  package func render(size: Size, content: () -> some View) {
    let renderer = Renderer(
      canvas: self,
      environment: .windowSize(size),
      content: content
    )
    renderer.render()
  }
}
