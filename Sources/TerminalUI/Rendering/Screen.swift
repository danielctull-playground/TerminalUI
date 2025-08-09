
struct Screen<Content: View>: View {

  @Environment(\.windowSize) private var windowSize
  let content: Content

  var body: some View {
    VStack {
      content
    }
    .frame(width: windowSize.width, height: windowSize.height)
  }
}
