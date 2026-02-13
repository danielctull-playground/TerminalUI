@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("FlexibleFrame", .tags(.modifier))
struct FlexibleFrameTests {

  private let canvas = TestCanvas(width: 3, height: 3)
  private let view = Color.blue
  private let pixel = Pixel(" ", background: .blue)

  @Test func `body: fatal`() async {
    await #expect(processExitsWith: .failure) {
      _ = Color.black
        .frame(
          minWidth: nil,
          idealWidth: nil,
          maxWidth: nil,
          minHeight: nil,
          idealHeight: nil,
          maxHeight: nil
        )
        .body
    }
  }

  @Test(arguments: Array<(Int?, Int?, Int?, Int?, Int?, Int?, Alignment, [Position])>([
    // minWidth
    (  1, nil, nil, nil, nil, nil, .center, .all),
    (  2, nil, nil, nil, nil, nil, .center, .all),
    (  3, nil, nil, nil, nil, nil, .center, .all),
    (  4, nil, nil, nil, nil, nil, .center, .all),

    // maxWidth
    (nil, nil,   1, nil, nil, nil, .leading, .all),
//    (nil, nil,   2, nil, nil, nil, .leading, .leading + .xCenter),
//    (nil, nil,   3, nil, nil, nil, .leading, .all),
//    (nil, nil,   4, nil, nil, nil, .leading, .all),
//
//    (nil, nil,   1, nil, nil, nil, .center, .center),
//    (nil, nil,   2, nil, nil, nil, .center, .leading + .xCenter),
//    (nil, nil,   3, nil, nil, nil, .center, .all),
//    (nil, nil,   4, nil, nil, nil, .center, .all),

    // minHeight
    (nil, nil, nil,   1, nil, nil, .center, .all),
    (nil, nil, nil,   2, nil, nil, .center, .all),

    // maxHeight
    (nil, nil, nil, nil, nil,   1, .top, .top),
    (nil, nil, nil, nil, nil,   2, .top, .top + .yCenter),
    (nil, nil, nil, nil, nil,   3, .top, .all),
    (nil, nil, nil, nil, nil,   4, .top, .all),

    (nil, nil, nil, nil, nil,   1, .center, .yCenter),
    (nil, nil, nil, nil, nil,   2, .center, .yCenter + .top),
    (nil, nil, nil, nil, nil,   3, .center, .all),
    (nil, nil, nil, nil, nil,   4, .center, .all),

    (nil, nil, nil, nil, nil,   1, .bottom, .bottom),
    (nil, nil, nil, nil, nil,   2, .bottom, .bottom + .yCenter),
    (nil, nil, nil, nil, nil,   3, .bottom, .all),
    (nil, nil, nil, nil, nil,   4, .bottom, .all),

  ]))
  func frame(
    minWidth: Int?,
    idealWidth: Int?,
    maxWidth: Int?,
    minHeight: Int?,
    idealHeight: Int?,
    maxHeight: Int?,
    alignment: Alignment,
    expected: [Position]
  ) {

    canvas.render {
      view.frame(
        minWidth: minWidth,
        idealWidth: idealWidth,
        maxWidth: maxWidth,
        minHeight: minHeight,
        idealHeight: idealHeight,
        maxHeight: maxHeight,
        alignment: alignment
      )
    }

    let expected = Dictionary(uniqueKeysWithValues: expected.map { ($0, pixel) })

    #expect(canvas.pixels == expected)
  }

  @Test func `minWidth: nil, idealWidth: nil, maxWidth: nil, minHeight: nil, idealHeight: nil, maxHeight: nil`() {

    canvas.render {
      view.frame(
        minWidth: nil,
        idealWidth: nil,
        maxWidth: nil,
        minHeight: nil,
        idealHeight: nil,
        maxHeight: nil
      )
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): pixel,
      Position(x: 2, y: 1): pixel,
      Position(x: 3, y: 1): pixel,
      Position(x: 1, y: 2): pixel,
      Position(x: 2, y: 2): pixel,
      Position(x: 3, y: 2): pixel,
      Position(x: 1, y: 3): pixel,
      Position(x: 2, y: 3): pixel,
      Position(x: 3, y: 3): pixel,
    ])
  }

  @Test func `minWidth: 1, idealWidth: nil, maxWidth: nil, minHeight: nil, idealHeight: nil, maxHeight: nil`() {

    canvas.render {
      view.frame(
        minWidth: 1,
        idealWidth: nil,
        maxWidth: nil,
        minHeight: nil,
        idealHeight: nil,
        maxHeight: nil
      )
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): pixel,
      Position(x: 2, y: 1): pixel,
      Position(x: 3, y: 1): pixel,
      Position(x: 1, y: 2): pixel,
      Position(x: 2, y: 2): pixel,
      Position(x: 3, y: 2): pixel,
      Position(x: 1, y: 3): pixel,
      Position(x: 2, y: 3): pixel,
      Position(x: 3, y: 3): pixel,
    ])
  }

  @Test func `minWidth: 2, idealWidth: nil, maxWidth: nil, minHeight: nil, idealHeight: nil, maxHeight: nil`() {

    canvas.render {
      view.frame(
        minWidth: 2,
        idealWidth: nil,
        maxWidth: nil,
        minHeight: nil,
        idealHeight: nil,
        maxHeight: nil
      )
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): pixel,
      Position(x: 2, y: 1): pixel,
      Position(x: 3, y: 1): pixel,
      Position(x: 1, y: 2): pixel,
      Position(x: 2, y: 2): pixel,
      Position(x: 3, y: 2): pixel,
      Position(x: 1, y: 3): pixel,
      Position(x: 2, y: 3): pixel,
      Position(x: 3, y: 3): pixel,
    ])
  }

  @Test func `width: 2, height: nil`() {

    canvas.render {
      view.frame(width: 2)
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): pixel,
      Position(x: 1, y: 2): pixel,
      Position(x: 1, y: 3): pixel,
      Position(x: 2, y: 1): pixel,
      Position(x: 2, y: 2): pixel,
      Position(x: 2, y: 3): pixel,
    ])
  }

  @Test func `width: nil, height: 1`() {

    canvas.render {
      view.frame(height: 1)
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 2): pixel,
      Position(x: 2, y: 2): pixel,
      Position(x: 3, y: 2): pixel,
    ])
  }

  @Test func `width: nil, height: 2`() {

    canvas.render {
      view.frame(height: 2)
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): pixel,
      Position(x: 2, y: 1): pixel,
      Position(x: 3, y: 1): pixel,
      Position(x: 1, y: 2): pixel,
      Position(x: 2, y: 2): pixel,
      Position(x: 3, y: 2): pixel,
    ])
  }

  @Test func `width: 1, height: 1`() {

    canvas.render {
      view.frame(width: 1, height: 1)
    }

    #expect(canvas.pixels == [
      Position(x: 2, y: 2): pixel,
    ])
  }

  @Test func `width: 2, height: 2`() {

    canvas.render {
      view.frame(width: 2, height: 2)
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): pixel,
      Position(x: 2, y: 1): pixel,
      Position(x: 1, y: 2): pixel,
      Position(x: 2, y: 2): pixel,
    ])
  }

  @Test func `nested`() {

    canvas.render {
      view
        .frame(width: 1, height: 1)
        .frame(width: 3, height: 3)
    }

    #expect(canvas.pixels == [
      Position(x: 2, y: 2): pixel,
    ])
  }

  @Test(arguments: Array<(Alignment, Position)>([
    (.topLeading,     Position(x: 1, y: 1)),
    (.top,            Position(x: 2, y: 1)),
    (.topTrailing,    Position(x: 3, y: 1)),
    (.leading,        Position(x: 1, y: 2)),
    (.center,         Position(x: 2, y: 2)),
    (.trailing,       Position(x: 3, y: 2)),
    (.bottomLeading,  Position(x: 1, y: 3)),
    (.bottom,         Position(x: 2, y: 3)),
    (.bottomTrailing, Position(x: 3, y: 3)),
  ]))
  func `alignment`(alignment: Alignment, position: Position) {

    canvas.render {
      view
        .frame(width: 1, height: 1)
        .frame(width: 3, height: 3, alignment: alignment)
    }

    #expect(canvas.pixels == [position: pixel])
  }

  @Suite(.tags(.preferenceValues))
  struct `Preference Values` {

    @Test func `default value`() {

      var output = ""

      TestCanvas(width: 3, height: 3).render {
        Text("x")
          .frame(width: 1, height: 1)
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == PreferenceKey.A.defaultValue)
    }

    @Test func `modified value`() {

      var output = ""

      TestCanvas(width: 3, height: 3).render {
        Text("x")
          .preference(key: PreferenceKey.A.self, value: "new")
          .frame(width: 1, height: 1)
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == "new")
    }
  }
}
extension [Position] {

  fileprivate static let all = leading + xCenter + trailing

  fileprivate static let leading = [
    Position(x: 1, y: 1),
    Position(x: 1, y: 2),
    Position(x: 1, y: 3),
  ]

  fileprivate static let xCenter = [
    Position(x: 2, y: 1),
    Position(x: 2, y: 2),
    Position(x: 2, y: 3),
  ]

  fileprivate static let trailing = [
    Position(x: 3, y: 1),
    Position(x: 3, y: 2),
    Position(x: 3, y: 3),
  ]

  fileprivate static let top = [
    Position(x: 1, y: 1),
    Position(x: 2, y: 1),
    Position(x: 3, y: 1),
  ]

  fileprivate static let yCenter = [
    Position(x: 1, y: 2),
    Position(x: 2, y: 2),
    Position(x: 3, y: 2),
  ]

  fileprivate static let bottom = [
    Position(x: 1, y: 3),
    Position(x: 2, y: 3),
    Position(x: 3, y: 3),
  ]
}
