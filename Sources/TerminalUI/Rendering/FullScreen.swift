
struct FullScreen<Content: View>: View {

  @Environment(\.windowSize) private var windowSize
  private let content: Content
  init(_ content: Content) {
    self.content = content
  }

  var body: some View {
    VStack {
      content
    }
    .frame(width: windowSize.size.width, height: windowSize.size.height)
  }
}
