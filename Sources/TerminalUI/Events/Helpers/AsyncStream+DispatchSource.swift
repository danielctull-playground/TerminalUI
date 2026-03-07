@preconcurrency import Dispatch

extension AsyncStream<Void> {
  init(_ source: any DispatchSourceProtocol) {
    self.init { continuation in
      source.setEventHandler {
        continuation.yield(())
      }
      source.setCancelHandler {
        continuation.finish()
      }
      continuation.onTermination = { _ in
        source.cancel()
      }
      continuation.yield(()) // Send an initial value.
      source.resume()
    }
  }
}
