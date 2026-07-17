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

      #expect(screen.buffer.description == """
        icon_title
        """)
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

      #expect(screen.buffer.description == """
        icon_title
        """)
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

      #expect(screen.buffer.description == """
        ___title__
        """)
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

      #expect(screen.buffer.description == """
        ___icon___
        """)
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

      #expect(screen.buffer.description == """
        icon_
        _____
        title
        """)
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
