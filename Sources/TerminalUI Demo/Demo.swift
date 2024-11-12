import TerminalUI

@main
struct Demo: App {

  var body: some View {
    Text("daniel")
      .bold()
      .italic()
      .underline()
      .blinking()
      .inverse()
  }
}
