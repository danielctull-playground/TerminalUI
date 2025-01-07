
public enum Edge {}

extension Edge {
  public struct Set {
    fileprivate let insets: (Int) -> EdgeInsets
  }
}

extension EdgeInsets {

  init(set: Edge.Set, value: Int) {
    self = set.insets(value)
  }
}

extension Edge.Set {

  public static var all: Self {
    Self { EdgeInsets(top: $0, leading: $0, bottom: $0, trailing: $0) }
  }

  public static var vertical: Self {
    Self { EdgeInsets(top: $0, leading: 0, bottom: $0, trailing: 0) }
  }

  public static var horizontal: Self {
    Self { EdgeInsets(top: 0, leading: $0, bottom: 0, trailing: $0) }
  }

  public static var top: Self {
    Self { EdgeInsets(top: $0, leading: 0, bottom: 0, trailing: 0) }
  }

  public static var leading: Self {
    Self { EdgeInsets(top: 0, leading: $0, bottom: 0, trailing: 0) }
  }

  public static var bottom: Self {
    Self { EdgeInsets(top: 0, leading: 0, bottom: $0, trailing: 0) }
  }

  public static var trailing: Self {
    Self { EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: $0) }
  }
}
