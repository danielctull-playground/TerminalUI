import ArgumentParser
import TerminalUI

struct Typing: App, AsyncParsableCommand {

  static let configuration = CommandConfiguration(
    abstract: "Shows how App and AsyncParsableCommand can be used together."
  )

  var body: some View {
    Content()
  }
}

struct Content: View {
  @State private var a = ""
  @State private var b = ""

  var body: some View {
    HStack {

      Color.black

      VStack(spacing: 1) {
        Text(a)
          .backgroundColor(.blue)
          .foregroundColor(.yellow)

        TextField(text: $a)
          .backgroundColor(.yellow)
          .foregroundColor(.blue)
      }

      Color.black

      VStack(spacing: 1) {
        Text(b)
          .backgroundColor(.red)
          .foregroundColor(.white)

        TextField(text: $b)
          .backgroundColor(.white)
          .foregroundColor(.red)
      }

      Color.black
    }
  }
}
