
struct Screen<Content: View>: View {

  @Environment(\.windowBounds) private var bounds
  let content: Content

  var body: some View {
    VStack {
      content
    }
    .frame(width: bounds.size.width, height: bounds.size.height)
  }
}
