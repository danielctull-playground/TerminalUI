import TerminalUI

struct TestApp<Body: View>: App {
  let body: Body
  init(body: () -> Body) {
    self.body = body()
  }
  init() { fatalError() }
}
