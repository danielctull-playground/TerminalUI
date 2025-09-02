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

  @Test("first body: fatal")
  func firstBody() async {
    await #expect(processExitsWith: .failure) {
      _ = ViewBuilder
        .buildPartialBlock(first: Color.black)
        .body
    }
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

  @Test("accumulated body: fatal")
  func accumulatedBody() async {
    await #expect(processExitsWith: .failure) {
      _ = ViewBuilder
        .buildPartialBlock(accumulated: Color.black, next: Color.blue)
        .body
    }
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

  @Test("optional body: fatal")
  func optionalBody() async {
    await #expect(processExitsWith: .failure) {
      _ = ViewBuilder
        .buildOptional(Color.black)
        .body
    }
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

  @Test("either body: fatal")
  func eitherBody() async {
    await #expect(processExitsWith: .failure) {
      let either: Either<Color, Color> = ViewBuilder.buildEither(first: Color.black)
      _ = either.body
    }
    await #expect(processExitsWith: .failure) {
      let either: Either<Color, Color> = ViewBuilder.buildEither(second: Color.black)
      _ = either.body
    }
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

  @Test("limited availability body: fatal")
  func limitedAvailabilityBody() async {
    await #expect(processExitsWith: .failure) {
      _ = ViewBuilder.buildLimitedAvailability(Color.black).body
    }
  }
}
