import TerminalUI

#if ENABLE_OSLOG
import Logging
import OSLogging
#endif

@main
struct Demo: App {

#if ENABLE_OSLOG
  init() {
    LoggingSystem.bootstrap { label in
      OSLogHandler(subsystem: "uk.co.danieltull.terminalui.demo", category: label)
    }
  }
#endif

  var body: some View {
    HStack {
      Color(red: 1, green: 0, blue: 0)
      VStack {
        Color(red: 0.5, green: 0, blue: 1)
        HStack {
          Text("daniel")
            .italic()
            .underline(style: .double)
            .padding(1)
          Text("tull")
            .underline()
            .padding(.trailing, 1)
        }
        Color(red: 1, green: 1, blue: 0)
      }
      Color(red: 1, green: 0.5, blue: 0)
    }
    .bold()
  }
}
