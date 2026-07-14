@testable import TerminalUI

extension Screen {

  package func render(size: Size, content: () -> some View) {
    let renderer = Renderer(
      screen: self,
      content: content
    )
    renderer.render(event: WindowSize(size: size))
  }
}
