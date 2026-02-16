
protocol PrimitiveView: View where Body == Never {}

extension PrimitiveView {

  public var body: Never {
    fatalError("body should never be called for primitive views.")
  }
}
