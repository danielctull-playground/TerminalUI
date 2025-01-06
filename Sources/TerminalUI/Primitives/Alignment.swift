
public struct Alignment: Equatable, Hashable, Sendable {

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

  public static var topLeading: Self {
    Self(horizontal: .leading, vertical: .top)
  }

  public static var top: Self {
    Self(horizontal: .center, vertical: .top)
  }

  public static var topTrailing: Self {
    Self(horizontal: .trailing, vertical: .top)
  }

  public static var leading: Self {
    Self(horizontal: .leading, vertical: .center)
  }

  public static var center: Self {
    Self(horizontal: .center, vertical: .center)
  }

  public static var trailing: Self {
    Self(horizontal: .trailing, vertical: .center)
  }

  public static var bottomLeading: Self {
    Self(horizontal: .leading, vertical: .bottom)
  }

  public static var bottom: Self {
    Self(horizontal: .center, vertical: .bottom)
  }

  public static var bottomTrailing: Self {
    Self(horizontal: .trailing, vertical: .bottom)
  }
}

extension Alignment {
  func position(for size: Size) -> Position {
    Position(
      x: horizontal.value(in: size),
      y: vertical.value(in: size))
  }
}

// MARK: - AlignmentID

public protocol AlignmentID: Equatable {
  static func defaultValue(in size: Size) -> Int
}

// MARK: - AlignmentKey

public struct AlignmentKey: Equatable, Hashable, Sendable {

  fileprivate let id: any AlignmentID.Type

  public static func == (lhs: AlignmentKey, rhs: AlignmentKey) -> Bool {
    String(describing: lhs.id) == String(describing: rhs.id)
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(String(describing: id))
  }
}

// MARK: - Horizontal Alignment

public struct HorizontalAlignment: Equatable, Hashable, Sendable {
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
  fileprivate func value(in size: Size) -> Int {
    key.id.defaultValue(in: size)
  }
}

extension HorizontalAlignment {

  public static var leading: Self {
    enum Leading: AlignmentID {
      static func defaultValue(in size: Size) -> Int { 1 }
    }
    return Self(Leading.self)
  }

  public static var center: Self {
    enum Center: AlignmentID {
      static func defaultValue(in size: Size) -> Int { Int(size.width) / 2 }
    }
    return Self(Center.self)
  }

  public static var trailing: Self {
    enum Trailing: AlignmentID {
      static func defaultValue(in size: Size) -> Int { Int(size.width) }
    }
    return Self(Trailing.self)
  }
}

// MARK: - Vertical Alignment

public struct VerticalAlignment: Equatable, Hashable, Sendable {
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
  fileprivate func value(in size: Size) -> Int {
    key.id.defaultValue(in: size)
  }
}

extension VerticalAlignment {

  public static var top: Self {
    enum Top: AlignmentID {
      static func defaultValue(in size: Size) -> Int { 1 }
    }
    return Self(Top.self)
  }

  public static var center: Self {
    enum Center: AlignmentID {
      static func defaultValue(in size: Size) -> Int { Int(size.height) / 2 }
    }
    return Self(Center.self)
  }

  public static var bottom: Self {
    enum Bottom: AlignmentID {
      static func defaultValue(in size: Size) -> Int { Int(size.height) }
    }
    return Self(Bottom.self)
  }
}
