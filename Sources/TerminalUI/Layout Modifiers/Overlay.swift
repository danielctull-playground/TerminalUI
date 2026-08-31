
extension View {

  public func overlay<Content: View>(
    alignment: Alignment = .center,
    @ViewBuilder content: () -> Content
  ) -> some View {
    ZStack(alignment: alignment) {
      self
      content()
    }
  }
}
