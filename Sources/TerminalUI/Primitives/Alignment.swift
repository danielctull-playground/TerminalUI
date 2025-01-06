
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

// MARK: - Horizontal Alignment

public enum HorizontalAlignment: Equatable, Hashable, Sendable {
  case leading
  case center
  case trailing
}

// MARK: - Vertical Alignment

public enum VerticalAlignment: Equatable, Hashable, Sendable {
  case top
  case center
  case bottom
}
