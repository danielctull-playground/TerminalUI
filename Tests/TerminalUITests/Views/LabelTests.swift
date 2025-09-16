@testable import TerminalUI
import TerminalUITesting
import Testing

@Suite("Label", .tags(.view))
struct LabelTests {

  @Suite struct Style {

    @Test func `default`() {

      let canvas = TestCanvas(width: 10, height: 1)
      canvas.render {
        Label {
          Text("title")
        } icon: {
          Text("icon")
        }
      }

      #expect(canvas.pixels == [
        Position(x:  1, y: 1): Pixel("i"),
        Position(x:  2, y: 1): Pixel("c"),
        Position(x:  3, y: 1): Pixel("o"),
        Position(x:  4, y: 1): Pixel("n"),

        Position(x:  6, y: 1): Pixel("t"),
        Position(x:  7, y: 1): Pixel("i"),
        Position(x:  8, y: 1): Pixel("t"),
        Position(x:  9, y: 1): Pixel("l"),
        Position(x: 10, y: 1): Pixel("e"),
      ])
    }

    @Test func `titleAndIcon`() {

      let canvas = TestCanvas(width: 10, height: 1)
      canvas.render {
        Label {
          Text("title")
        } icon: {
          Text("icon")
        }
        .labelStyle(.titleAndIcon)
      }

      #expect(canvas.pixels == [
        Position(x:  1, y: 1): Pixel("i"),
        Position(x:  2, y: 1): Pixel("c"),
        Position(x:  3, y: 1): Pixel("o"),
        Position(x:  4, y: 1): Pixel("n"),

        Position(x:  6, y: 1): Pixel("t"),
        Position(x:  7, y: 1): Pixel("i"),
        Position(x:  8, y: 1): Pixel("t"),
        Position(x:  9, y: 1): Pixel("l"),
        Position(x: 10, y: 1): Pixel("e"),
      ])
    }

    @Test func `titleOnly`() {

      let canvas = TestCanvas(width: 10, height: 1)
      canvas.render {
        Label {
          Text("title")
        } icon: {
          Text("icon")
        }
        .labelStyle(.titleOnly)
      }

      #expect(canvas.pixels == [
        Position(x: 4, y: 1): Pixel("t"),
        Position(x: 5, y: 1): Pixel("i"),
        Position(x: 6, y: 1): Pixel("t"),
        Position(x: 7, y: 1): Pixel("l"),
        Position(x: 8, y: 1): Pixel("e"),
      ])
    }

    @Test func `iconOnly`() {

      let canvas = TestCanvas(width: 10, height: 1)
      canvas.render {
        Label {
          Text("title")
        } icon: {
          Text("icon")
        }
        .labelStyle(.iconOnly)
      }

      #expect(canvas.pixels == [
        Position(x: 4, y: 1): Pixel("i"),
        Position(x: 5, y: 1): Pixel("c"),
        Position(x: 6, y: 1): Pixel("o"),
        Position(x: 7, y: 1): Pixel("n"),
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

      let canvas = TestCanvas(width: 5, height: 3)
      canvas.render {
        Group {
          Label {
            Text("title")
          } icon: {
            Text("icon")
          }
        }
        .labelStyle(Custom())
      }

      #expect(canvas.pixels == [
        Position(x: 1, y: 1): Pixel("i"),
        Position(x: 2, y: 1): Pixel("c"),
        Position(x: 3, y: 1): Pixel("o"),
        Position(x: 4, y: 1): Pixel("n"),

        Position(x: 1, y: 3): Pixel("t"),
        Position(x: 2, y: 3): Pixel("i"),
        Position(x: 3, y: 3): Pixel("t"),
        Position(x: 4, y: 3): Pixel("l"),
        Position(x: 5, y: 3): Pixel("e"),
      ])
    }
  }

  @Suite(.tags(.preferenceValues))
  struct `Preference Values` {

    @Test func `default value`() {

      var output = ""

      TestCanvas(width: 3, height: 3).render {
        Label { Color.black } icon: { Color.blue }
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == PreferenceKey.A.defaultValue)
    }

    @Test func `modified value`() {

      var output = ""

      TestCanvas(width: 3, height: 3).render {
        Label { Color.black } icon: { Color.blue }
          .preference(key: PreferenceKey.A.self, value: "new")
          .onPreferenceChange(PreferenceKey.A.self) { output = $0 }
      }

      #expect(output == "new")
    }
  }
}
