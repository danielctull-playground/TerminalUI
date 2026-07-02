import ArgumentParser
import TerminalUI

struct Phrase: App, AsyncParsableCommand {

  static let configuration = CommandConfiguration(
    abstract: "Shows how App and AsyncParsableCommand can be used together."
  )

  @Option(help: "How many times to repeat 'phrase'.")
  var count: Int = 1

  @Argument(help: "The phrase to display.")
  var phrase: String

  private var text: String {
    Array(repeating: phrase, count: count)
      .joined(separator: ", ")
  }

  var body: some View {
    Text(text)
      .foregroundColor(.black)
      .backgroundColor(.yellow)
  }
}
