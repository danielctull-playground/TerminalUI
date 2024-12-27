import TerminalUI

@main
struct Demo: App {

  var body: some View {

    HStack(children: [
      Color.red.padding(.leading, 1),
      Color.green.padding(.leading, 1),
      Color.yellow.padding(.leading, 1),
      Color.blue.padding(.leading, 1),
      Color.magenta.padding(.leading, 1),
      Color.cyan.padding(.leading, 1),
      Color.white.padding(.leading, 1),
    ])
    .frame(height: 2)

//    Text("daniel")
//      .bold()
//      .italic()
//      .underline()
//      .blinking()
//      .inverse()
  }
}
