
public struct ConditionalContent<TrueContent, FalseContent> {

  enum Value {
    case `true`(TrueContent)
    case `false`(FalseContent)
  }

  let value: Value

  init(_ content: TrueContent) {
    value = .true(content)
  }

  init(_ content: FalseContent) {
    value = .false(content)
  }
}
