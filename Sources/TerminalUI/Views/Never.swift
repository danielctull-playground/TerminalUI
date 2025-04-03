
extension Never: View {

  public var body: Never {
    fatalError("Never body should never be called.")
  }

  public static func _makeView(_ inputs: ViewInputs<Never>) -> ViewOutputs {
    fatalError("Never makeView should never be called.")
  }
}
