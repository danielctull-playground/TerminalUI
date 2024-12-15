
public enum Edge {}

extension Edge {
  public struct Set<Value> {
    fileprivate let _insets: (Value) -> EdgeInsets
  }
}

extension Edge.Set {
  func insets(_ value: Value) -> EdgeInsets {
    _insets(value)
  }
}

extension Edge.Set<Int> {

  public static var all: Self {
    Self { value in
      let vertical = Vertical(value)
      let horizontal = Horizontal(value)
      return EdgeInsets(
        top: vertical,
        leading: horizontal,
        bottom: vertical,
        trailing: horizontal)
    }
  }
}

extension Edge.Set<Vertical> {

  public static var top: Self {
    Self { EdgeInsets(top: $0, leading: 0, bottom: 0, trailing: 0) }
  }

  public static var bottom: Self {
    Self { EdgeInsets(top: 0, leading: 0, bottom: $0, trailing: 0) }
  }

  public static var vertical: Self {
    Self { EdgeInsets(top: $0, leading: 0, bottom: $0, trailing: 0) }
  }
}

extension Edge.Set<Horizontal> {

  public static var leading: Self {
    Self { EdgeInsets(top: 0, leading: $0, bottom: 0, trailing: 0) }
  }

  public static var trailing: Self {
    Self { EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: $0) }
  }

  public static var horizontal: Self {
    Self { EdgeInsets(top: 0, leading: $0, bottom: 0, trailing: $0) }
  }
}
