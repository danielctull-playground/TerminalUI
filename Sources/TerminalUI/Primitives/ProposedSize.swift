
/// Amount of space a view is offered.
package struct ProposedSize {
  let width: Horizontal
  let height: Vertical

  package init(width: Horizontal, height: Vertical) {
    self.width = width
    self.height = height
  }
}
