import TerminalUI

extension Canvas {

  @MainActor
  package func render(size: Size, content: () -> some View) {
    Size.window = size
    let renderer = Renderer(canvas: self, content: content)
    renderer.run()
  }
}
