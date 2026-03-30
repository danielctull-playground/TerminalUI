
protocol CSIEvent: Event {
  init(csi: CSI) throws
}

extension AsyncSequence where Self: Sendable, Element == any Event {

  func csiEvents<each E: CSIEvent>(
    _ type: repeat (each E).Type
  ) -> some Sendable & AsyncSequence<any Event, Failure> {

    map { event in

      guard let csi = event as? CSI else { return event }

      for type in repeat (each type) {
        if let event = try? type.init(csi: csi) {
          return event
        }
      }

      return event
    }
  }
}
