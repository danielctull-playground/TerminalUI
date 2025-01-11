
public protocol Layout {

  typealias Subviews = LayoutSubviews

  associatedtype Cache = Void

  func makeCache(
    subviews: Subviews
  ) -> Cache

  func updateCache(
    _ cache: inout Cache,
    subviews: Subviews
  )

  func spacing(
    subviews: Subviews,
    cache: inout Cache
  ) -> ViewSpacing

  func sizeThatFits(
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout Cache
  ) -> Size

  func placeSubviews(
    in bounds: Rect,
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout Cache
  )

  func explicitAlignment(
    of guide: HorizontalAlignment,
    in bounds: Rect,
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout Cache
  ) -> Int?

  func explicitAlignment(
    of guide: VerticalAlignment,
    in bounds: Rect,
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout Cache
  ) -> Int?
}

// MARK: - Default Implementations

extension Layout where Cache == Void {
  func makeCache(subviews: Subviews) -> Cache { Cache() }
  func updateCache(_ cache: inout Cache, subviews: Subviews) {}
}

extension Layout {

  func spacing(
    subviews: Subviews,
    cache: inout Cache
  ) -> ViewSpacing {
    ViewSpacing()
  }

  func explicitAlignment(
    of guide: HorizontalAlignment,
    in bounds: Rect,
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout Cache
  ) -> Int? {
    nil
  }

  func explicitAlignment(
    of guide: VerticalAlignment,
    in bounds: Rect,
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout Cache
  ) -> Int? {
    nil
  }
}

// MARK: - LayoutSubviews

public struct LayoutSubviews {}

// MARK: - LayoutSubviews

public struct LayoutSubview: Equatable {

//  public subscript<Key>(key: Key.Type) -> Key.Value where Key: LayoutValueKey {
//  }

  public let priority: Double

//  public func sizeThatFits(_ proposal: ProposedViewSize) -> Size {
//  }

//  public func dimensions(in proposal: ProposedViewSize) -> ViewDimensions {
//  }

  public let spacing: ViewSpacing

//  public func place(
//    at position: Position,
//    anchor: UnitPoint = .topLeading,
//    proposal: ProposedViewSize
//  ) {
//  }

//  public static func == (a: LayoutSubview, b: LayoutSubview) -> Bool {
//  }
}

// MARK: - LayoutValueKey

public protocol LayoutValueKey {
    associatedtype Value
    static var defaultValue: Self.Value { get }
}
