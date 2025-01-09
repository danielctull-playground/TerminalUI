
public struct Alignment: Equatable, Sendable {

  public let horizontal: HorizontalAlignment
  public let vertical: VerticalAlignment

  public init(
    horizontal: HorizontalAlignment,
    vertical: VerticalAlignment
  ) {
    self.horizontal = horizontal
    self.vertical = vertical
  }
}

extension Alignment: CustomStringConvertible {
  public var description: String {
    "Alignment(horizontal: \(horizontal), vertical: \(vertical))"
  }
}

extension Alignment {

  public static let topLeading = Alignment(
    horizontal: .leading,
    vertical: .top)

  public static let top = Alignment(
    horizontal: .center,
    vertical: .top)

  public static let topTrailing = Alignment(
    horizontal: .trailing,
    vertical: .top)

  public static let leading = Alignment(
    horizontal: .leading,
    vertical: .center)

  public static let center = Alignment(
    horizontal: .center,
    vertical: .center)

  public static let trailing = Alignment(
    horizontal: .trailing,
    vertical: .center)

  public static let bottomLeading = Alignment(
    horizontal: .leading,
    vertical: .bottom)

  public static let bottom = Alignment(
    horizontal: .center,
    vertical: .bottom)

  public static let bottomTrailing = Alignment(
    horizontal: .trailing,
    vertical: .bottom)
}

extension Alignment {
  func position(for size: Size) -> Position {
    Position(
      x: horizontal.value(in: size),
      y: vertical.value(in: size))
  }
}

// MARK: - AlignmentID

public protocol AlignmentID {
  static func defaultValue(in size: Size) -> InfinityInt
}

// MARK: - AlignmentKey

public struct AlignmentKey: Equatable, Sendable {

  fileprivate let id: any AlignmentID.Type

  public static func == (lhs: AlignmentKey, rhs: AlignmentKey) -> Bool {
    String(describing: lhs.id) == String(describing: rhs.id)
  }
}

// MARK: - Horizontal Alignment

public struct HorizontalAlignment: Equatable, Sendable {
  private let key: AlignmentKey
  public init(_ id: any AlignmentID.Type) {
    key = AlignmentKey(id: id)
  }
}

extension HorizontalAlignment: CustomStringConvertible {
  public var description: String {
    String(describing: key.id)
  }
}

extension HorizontalAlignment {
  func value(in size: Size) -> InfinityInt {
    key.id.defaultValue(in: size)
  }
}

extension HorizontalAlignment {

  private enum Leading: AlignmentID {
    static func defaultValue(in size: Size) -> InfinityInt { 1 }
  }

  private enum Center: AlignmentID {
    static func defaultValue(in size: Size) -> InfinityInt { size.width / size.height }
  }

  private enum Trailing: AlignmentID {
    static func defaultValue(in size: Size) -> InfinityInt { size.width }
  }

  public static let leading = HorizontalAlignment(Leading.self)

  public static let center = HorizontalAlignment(Center.self)

  public static let trailing = HorizontalAlignment(Trailing.self)
}

// MARK: - Vertical Alignment

public struct VerticalAlignment: Equatable, Sendable {
  private let key: AlignmentKey
  public init(_ id: any AlignmentID.Type) {
    key = AlignmentKey(id: id)
  }
}

extension VerticalAlignment: CustomStringConvertible {
  public var description: String {
    String(describing: key.id)
  }
}

extension VerticalAlignment {
  func value(in size: Size) -> InfinityInt {
    key.id.defaultValue(in: size)
  }
}

extension VerticalAlignment {

  private enum Top: AlignmentID {
    static func defaultValue(in size: Size) -> InfinityInt { 1 }
  }

  private enum Center: AlignmentID {
    static func defaultValue(in size: Size) -> InfinityInt { size.height / 2 }
  }

  private enum Bottom: AlignmentID {
    static func defaultValue(in size: Size) -> InfinityInt { size.height }
  }

  public static let top = VerticalAlignment(Top.self)

  public static let center = VerticalAlignment(Center.self)

  public static let bottom = VerticalAlignment(Bottom.self)
}
