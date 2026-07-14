@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Renderer")
struct RendererTests {

  @Test func `height: zero`() {
    let screen = TestScreen(width: 3, height: 0)
    screen.render {
      Color.red
    }
    #expect(screen.cells.isEmpty)
  }

  @Test func `width: zero`() {
    let screen = TestScreen(width: 0, height: 3)
    screen.render {
      Color.red
    }
    #expect(screen.cells.isEmpty)
  }

  @Test func `one renderer draws across multiple frames`() {

    let screen = TestScreen(width: 0, height: 0)
    let renderer = Renderer(screen: screen, content: Color.red)

    renderer.render(event: WindowSize(size: Size(width: 1, height: 1)))
    #expect(Set(screen.cells.keys) == [
      Position(x: 1, y: 1)
    ])

    renderer.render(event: WindowSize(size: Size(width: 3, height: 1)))
    #expect(Set(screen.cells.keys) == [
      Position(x: 1, y: 1),
      Position(x: 2, y: 1),
      Position(x: 3, y: 1),
    ])
  }

  @Test func `the graph is released once the renderer is gone`() {

    struct Probe<Object: AnyObject>: View {
      let box: Object
      var body: some View { Color.red }
    }

    final class Box {}
    weak var box: Box?

    do {
      let strongBox = Box()
      box = strongBox

      let renderer = Renderer(screen: TestScreen(width: 1, height: 1), content: Probe(box: strongBox))
      renderer.render(event: WindowSize(size: Size(width: 1, height: 1)))
    }

    // If the graph retained itself, it and the view tree holding the box would
    // outlive the renderer and box would not be nil here.
    #expect(box == nil)
  }
}
