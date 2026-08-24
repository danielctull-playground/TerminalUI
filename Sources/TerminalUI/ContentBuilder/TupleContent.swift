
public struct TupleContent<each Content> {

  let content: (repeat each Content)

  init(content: repeat each Content) {
    self.content = (repeat each content)
  }
}
