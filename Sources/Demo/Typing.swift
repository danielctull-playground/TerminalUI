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

  var body: some View {
    HStack {

      Color.black

      TypingView(primary: .blue, secondary: .yellow)

      Color.black

      TypingView(primary: .red, secondary: .white)

      Color.black
    }
  }
}

struct TypingView: View {

  @State private var typing = ""
  @State private var submitted = ""

  let primary: Color
  let secondary: Color

  var body: some View {
    VStack(spacing: 1) {
      TextField(text: $typing)
        .foregroundColor(primary)

      Button {
        submitted = typing
      } label: {
        Text("Submit")
      }

      Text(submitted)
        .backgroundColor(primary)
        .foregroundColor(secondary)
    }
  }
}
