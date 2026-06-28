import TerminalUI
import TerminalUITesting
import Testing

@Suite("Either", .tags(.viewBuilder))
struct EitherTests {

  @Test(.tags(.state))
  func `state inside a branch reflects a write`() {

    struct Stateful: View {
      @State var value = "old"
      var body: some View {
        Text(value)
          .preference(key: PreferenceKey.A.self, value: "new")
          .onPreferenceChange(PreferenceKey.A.self) { value = $0 }
      }
    }

    let canvas = TestCanvas(width: 3, height: 1)
    canvas.render {
      if true {
        Stateful()
      } else {
        EmptyView()
      }
    }

    #expect(canvas.pixels == [
      Position(x: 1, y: 1): Pixel("n"),
      Position(x: 2, y: 1): Pixel("e"),
      Position(x: 3, y: 1): Pixel("w"),
    ])
  }
}
