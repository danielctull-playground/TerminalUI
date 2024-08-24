
extension Never: View {

  public var body: Never {
    fatalError("Never body should never be called.")
  }
}
