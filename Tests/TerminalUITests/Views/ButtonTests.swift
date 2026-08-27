@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Button", .tags(.view))
struct ButtonTests {

  @Test func `focused when tabbed to`() {

    let screen = TestScreen(width: 8, height: 1)
    let renderer = Renderer(screen: screen) {
      Button {} label: { Text("button") }
    }

    renderer.render(event: WindowSize(size: Size(width: 8, height: 1)))
    #expect(screen.buffer == [
      Position(x: 1, y: 1): Cell(content: "[", style: .default),
      Position(x: 2, y: 1): Cell(content: "b", style: .default),
      Position(x: 3, y: 1): Cell(content: "u", style: .default),
      Position(x: 4, y: 1): Cell(content: "t", style: .default),
      Position(x: 5, y: 1): Cell(content: "t", style: .default),
      Position(x: 6, y: 1): Cell(content: "o", style: .default),
      Position(x: 7, y: 1): Cell(content: "n", style: .default),
      Position(x: 8, y: 1): Cell(content: "]", style: .default),
    ])

    renderer.render(event: KeyPress.tab)
    #expect(screen.buffer == [
      Position(x: 1, y: 1): Cell(content: "[", style: Style(bold: .on)),
      Position(x: 2, y: 1): Cell(content: "b", style: Style(bold: .on)),
      Position(x: 3, y: 1): Cell(content: "u", style: Style(bold: .on)),
      Position(x: 4, y: 1): Cell(content: "t", style: Style(bold: .on)),
      Position(x: 5, y: 1): Cell(content: "t", style: Style(bold: .on)),
      Position(x: 6, y: 1): Cell(content: "o", style: Style(bold: .on)),
      Position(x: 7, y: 1): Cell(content: "n", style: Style(bold: .on)),
      Position(x: 8, y: 1): Cell(content: "]", style: Style(bold: .on)),
    ])
  }

  @Test func `action is executed when pressed`() {

    var actions = 0
    let screen = TestScreen(width: 8, height: 1)
    let renderer = Renderer(screen: screen) {
      Button {
        actions += 1
      } label: {
        Text("button")
      }
    }

    renderer.render(event: WindowSize(size: Size(width: 8, height: 1)))
    #expect(actions == 0)

    renderer.render(event: KeyPress.tab)
    #expect(actions == 0)

    renderer.render(event: KeyPress.return)
    #expect(actions == 1)

    renderer.render(event: KeyPress.space)
    #expect(actions == 2)
  }

  @Suite("Style")
  struct StyleTests {

    @Test func `default`() {

      let screen = TestScreen(width: 8, height: 1)
      screen.render {
        Button {} label: { Text("button") }
      }

      #expect(screen.buffer.description == """
        [button]
        """)
    }

    @Test func `custom`() {

      struct Custom: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
          VStack(spacing: 0) {
            Text("┏━━━━━━┓")
            HStack(spacing: 0) {
              Text("┃")
              configuration.label
              Text("┃")
            }
            Text("┗━━━━━━┛")
          }
        }
      }

      let screen = TestScreen(width: 8, height: 3)
      screen.render {
        Button {} label: { Text("button") }
          .buttonStyle(Custom())
      }

      #expect(screen.buffer.description == """
        ┏━━━━━━┓
        ┃button┃
        ┗━━━━━━┛
        """)
    }
  }


  @Suite(.tags(.preferenceValues))
  struct `Preference Values` {

    @Test func `default value`() {

      var output = ""

      TestScreen(width: 3, height: 3).render {
        Button {} label: { Color.blue }
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == PreferenceKey.A.defaultValue)
    }

    @Test func `modified value`() {

      var output = ""

      TestScreen(width: 3, height: 3).render {
        Button {} label: { Color.blue }
          .preference(key: PreferenceKey.A.self, value: "new")
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == "new")
    }
  }
}
