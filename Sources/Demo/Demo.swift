import ArgumentParser

@main
struct Demo: AsyncParsableCommand {

  static let configuration = CommandConfiguration(
    commandName: "demo",
    abstract: "Demo of TerminalUI",
    subcommands: [
      Multi.self,
      Phrase.self,
    ]
  )
}
