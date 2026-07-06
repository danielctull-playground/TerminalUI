import ArgumentParser
import TerminalUI

@main
struct Demo: AsyncParsableCommand {

  static let configuration = CommandConfiguration(
    commandName: "demo",
    abstract: "Demo of TerminalUI",
    subcommands: [
      Phrase.self,
      Styles.self,
      Typing.self,
    ]
  )
}
