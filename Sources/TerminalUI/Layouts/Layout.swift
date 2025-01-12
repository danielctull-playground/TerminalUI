
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
  public func makeCache(subviews: Subviews) -> Cache { Cache() }
  public func updateCache(_ cache: inout Cache, subviews: Subviews) {}
}

extension Layout {
  public func updateCache(_ cache: inout Cache, subviews: Subviews) {
    cache = makeCache(subviews: subviews)
  }
}

extension Layout {

  public func spacing(
    subviews: Subviews,
    cache: inout Cache
  ) -> ViewSpacing {
    ViewSpacing()
  }

  public func explicitAlignment(
    of guide: HorizontalAlignment,
    in bounds: Rect,
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout Cache
  ) -> Int? {
    nil
  }

  public func explicitAlignment(
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

public struct LayoutSubviews {
  private let raw: [LayoutSubview]
}

extension LayoutSubviews: RandomAccessCollection {
  public typealias Index = Int
  public var startIndex: Index { raw.startIndex }
  public var endIndex: Index { raw.endIndex }
  public func index(after i: Int) -> Int { raw.index(after: i) }
  public func index(before i: Int) -> Int { raw.index(before: i) }
  public subscript(position: Index) -> LayoutSubview { raw[position] }
}

// MARK: - LayoutSubviews

public struct LayoutSubview: Equatable {

//  public subscript<Key>(key: Key.Type) -> Key.Value where Key: LayoutValueKey {
//  }

  public let priority: Double

  public func sizeThatFits(_ proposal: ProposedViewSize) -> Size {
    .zero
  }

//  public func dimensions(in proposal: ProposedViewSize) -> ViewDimensions {
//  }

  public let spacing: ViewSpacing

  public func place(
    at position: Position,
//    anchor: UnitPoint = .topLeading,
    proposal: ProposedViewSize
  ) {
  }

//  public static func == (a: LayoutSubview, b: LayoutSubview) -> Bool {
//  }
}

// MARK: - LayoutValueKey

public protocol LayoutValueKey {
    associatedtype Value
    static var defaultValue: Self.Value { get }
}
