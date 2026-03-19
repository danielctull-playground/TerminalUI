@preconcurrency import Dispatch

extension AsyncStream<UInt> {
  init(_ source: any DispatchSourceProtocol) {
    self.init { continuation in
      source.setEventHandler {
        continuation.yield(source.data)
      }
      source.setCancelHandler {
        continuation.finish()
      }
      continuation.onTermination = { _ in
        source.cancel()
      }
      source.resume()
    }
  }
}
