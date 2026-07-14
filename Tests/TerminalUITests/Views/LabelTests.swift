@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Label", .tags(.view))
struct LabelTests {

  @Suite struct Style {

    @Test func `default`() {

      let screen = TestScreen(width: 10, height: 1)
      screen.render {
        Label {
          Text("title")
        } icon: {
          Text("icon")
        }
      }

      #expect(screen.cells == [
        Position(x:  1, y: 1): Cell("i"),
        Position(x:  2, y: 1): Cell("c"),
        Position(x:  3, y: 1): Cell("o"),
        Position(x:  4, y: 1): Cell("n"),

        Position(x:  6, y: 1): Cell("t"),
        Position(x:  7, y: 1): Cell("i"),
        Position(x:  8, y: 1): Cell("t"),
        Position(x:  9, y: 1): Cell("l"),
        Position(x: 10, y: 1): Cell("e"),
      ])
    }

    @Test func `titleAndIcon`() {

      let screen = TestScreen(width: 10, height: 1)
      screen.render {
        Label {
          Text("title")
        } icon: {
          Text("icon")
        }
        .labelStyle(.titleAndIcon)
      }

      #expect(screen.cells == [
        Position(x:  1, y: 1): Cell("i"),
        Position(x:  2, y: 1): Cell("c"),
        Position(x:  3, y: 1): Cell("o"),
        Position(x:  4, y: 1): Cell("n"),

        Position(x:  6, y: 1): Cell("t"),
        Position(x:  7, y: 1): Cell("i"),
        Position(x:  8, y: 1): Cell("t"),
        Position(x:  9, y: 1): Cell("l"),
        Position(x: 10, y: 1): Cell("e"),
      ])
    }

    @Test func `titleOnly`() {

      let screen = TestScreen(width: 10, height: 1)
      screen.render {
        Label {
          Text("title")
        } icon: {
          Text("icon")
        }
        .labelStyle(.titleOnly)
      }

      #expect(screen.cells == [
        Position(x: 4, y: 1): Cell("t"),
        Position(x: 5, y: 1): Cell("i"),
        Position(x: 6, y: 1): Cell("t"),
        Position(x: 7, y: 1): Cell("l"),
        Position(x: 8, y: 1): Cell("e"),
      ])
    }

    @Test func `iconOnly`() {

      let screen = TestScreen(width: 10, height: 1)
      screen.render {
        Label {
          Text("title")
        } icon: {
          Text("icon")
        }
        .labelStyle(.iconOnly)
      }

      #expect(screen.cells == [
        Position(x: 4, y: 1): Cell("i"),
        Position(x: 5, y: 1): Cell("c"),
        Position(x: 6, y: 1): Cell("o"),
        Position(x: 7, y: 1): Cell("n"),
      ])
    }

    @Test func `custom`() {

      struct Custom: LabelStyle {
        func makeBody(configuration: Configuration) -> some View {
          VStack(spacing: 1) {
            configuration.icon
            configuration.title
          }
        }
      }

      let screen = TestScreen(width: 5, height: 3)
      screen.render {
        Group {
          Label {
            Text("title")
          } icon: {
            Text("icon")
          }
        }
        .labelStyle(Custom())
      }

      #expect(screen.cells == [
        Position(x: 1, y: 1): Cell("i"),
        Position(x: 2, y: 1): Cell("c"),
        Position(x: 3, y: 1): Cell("o"),
        Position(x: 4, y: 1): Cell("n"),

        Position(x: 1, y: 3): Cell("t"),
        Position(x: 2, y: 3): Cell("i"),
        Position(x: 3, y: 3): Cell("t"),
        Position(x: 4, y: 3): Cell("l"),
        Position(x: 5, y: 3): Cell("e"),
      ])
    }
  }

  @Suite(.tags(.preferenceValues))
  struct `Preference Values` {

    @Test func `default value`() {

      var output = ""

      TestScreen(width: 3, height: 3).render {
        Label { Color.black } icon: { Color.blue }
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == PreferenceKey.A.defaultValue)
    }

    @Test func `modified value`() {

      var output = ""

      TestScreen(width: 3, height: 3).render {
        Label { Color.black } icon: { Color.blue }
          .preference(key: PreferenceKey.A.self, value: "new")
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == "new")
    }
  }
}
