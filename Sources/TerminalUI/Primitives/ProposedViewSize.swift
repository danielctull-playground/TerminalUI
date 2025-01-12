
/// A proposal for the size of a view.
public struct ProposedViewSize: Equatable {

  /// The proposed horizontal size.
  ///
  /// A value of `nil` represents an unspecified width proposal, which a view
  /// interprets to mean that it should use its ideal width.
  public let width: Int?

  /// The proposed vertical size.
  ///
  /// A value of `nil` represents an unspecified height proposal, which a view
  /// interprets to mean that it should use its ideal height.
  public let height: Int?

  public init(width: Int?, height: Int?) {
    self.width = width
    self.height = height
  }

  public func replacingUnspecifiedDimensions(
    by size: Size = Size(width: 10, height: 10)
  ) -> Size {
    Size(
      width: width ?? size.width,
      height: height ?? size.height)
  }
}

extension ProposedViewSize {
  public init(_ size: Size) {
    self.init(width: size.width, height: size.height)
  }
}
