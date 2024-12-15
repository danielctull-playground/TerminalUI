
public struct EdgeInsets {
  let top: Vertical
  let leading: Horizontal
  let bottom: Vertical
  let trailing: Horizontal

  public init(
    top: Vertical,
    leading: Horizontal,
    bottom: Vertical,
    trailing: Horizontal
  ) {
    self.top = top
    self.leading = leading
    self.bottom = bottom
    self.trailing = trailing
  }
}
