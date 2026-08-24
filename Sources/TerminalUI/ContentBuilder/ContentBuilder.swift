
@resultBuilder
public enum ContentBuilder {

  public static func buildBlock() -> EmptyContent {
    EmptyContent()
  }

  public static func buildPartialBlock<Content>(
    first: Content
) -> Content {
    first
  }

  public static func buildPartialBlock<First, Second>(
    accumulated: First,
    next: Second
  ) -> AccumulatedContent<First, Second> {
    AccumulatedContent(a: accumulated, b: next)
  }

  public static func buildBlock<each Content>(
    _ content: repeat each Content
  ) -> TupleContent<repeat each Content> {
    TupleContent(content: repeat each content)
  }

}

extension ContentBuilder {

  public static func buildOptional<Content>(
    _ optional: Content?
  ) -> Content? {
    optional
  }

  public static func buildEither<TrueContent, FalseContent>(
    first: TrueContent
  ) -> ConditionalContent<TrueContent, FalseContent> {
    ConditionalContent(first)
  }

  public static func buildEither<TrueContent, FalseContent>(
    second: FalseContent
  ) -> ConditionalContent<TrueContent, FalseContent> {
    ConditionalContent(second)
  }

  public static func buildLimitedAvailability<Content>(
    _ content: Content
  ) -> Content {
    content
  }
}
