
// A view's resolved geometry, its absolute frame.
struct ViewGeometry: Equatable {

  /// The cell bounds this view occupies, in absolute screen coordinates.
  let frame: Rect
}


extension ViewGeometry {

  // A placeholder frame for a view that hasn't yet been placed.
  static let zero = ViewGeometry(frame: Rect(origin: .origin, size: .zero))
}
