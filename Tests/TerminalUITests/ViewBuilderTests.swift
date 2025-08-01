import TerminalUI
import TerminalUITesting
import Testing

@Suite("ViewBuilder", .tags(.modifier))
struct ViewBuilderTests {

  private var canvas = TestCanvas(width: 10, height: 10)

  @Test func empty() {
    canvas.render {}
    #expect(canvas.pixels == [:])
  }

  @Test func first() {

    canvas.render {
      Text("a")
    }

    #expect(canvas.pixels == [
      Position(x: 6, y: 6): Pixel("a"),
    ])
  }

  @Test func accumulated() {

    canvas.render {
      Text("a")
      Text("b")
    }

    #expect(canvas.pixels == [
      Position(x: 6, y: 5): Pixel("a"),
      Position(x: 6, y: 6): Pixel("b"),
    ])
  }

  @Test(arguments: [
    (true, [Position(x: 6, y: 6): Pixel("a")]),
    (false, [:])
  ])
  func optional(value: Bool, expectation: [Position: Pixel]) {

    canvas.render {
      if value {
        Text("a")
      }
    }

    #expect(canvas.pixels == expectation)
  }

  @Test(arguments: [
    (true, "a"),
    (false, "b")
  ])
  func either(value: Bool, character: Character) {

    canvas.render {
      if value {
        Text("a")
      } else {
        Text("b")
      }
    }

    #expect(canvas.pixels == [
      Position(x: 6, y: 6): Pixel(character),
    ])
  }

#if !os(Linux)
  // I can't find an #available flag that exists for linux machines.
  @Test func limitedAvailability() {

    canvas.render {
      if #available(iOS 999, macOS 999, tvOS 999, watchOS 999, *) {
        Text("a")
      } else if #available(*) {  // <-- This causes the builder to hit
        Text("b")                //     buildLimitedAvailability.
      }
    }

    #expect(canvas.pixels == [
      Position(x: 6, y: 6): Pixel("b"),
    ])
  }
#endif
}
