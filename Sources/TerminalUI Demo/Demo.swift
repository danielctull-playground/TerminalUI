import TerminalUI

@main
struct Demo: App {

  var body: some View {

    HStack(spacing: 1, content: [
      Color.red,
      Color.green,
      Color.yellow,
      Text("TerminalUI")
        .bold()
        .blinking()
        .italic(),
      Color.blue,
      Color.magenta,
      Color.cyan,
    ])

//    Text("daniel")
//      .bold()
//      .italic()
//      .underline()
//      .blinking()
//      .inverse()
  }
}
