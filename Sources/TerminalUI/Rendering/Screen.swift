
struct Screen<Content: View>: View {

  @Environment(\.windowSize) private var windowSize
  let content: Content

  var body: some View {
    VStack {
      content
    }
    .frame(width: windowSize.size.width, height: windowSize.size.height)
  }
}
