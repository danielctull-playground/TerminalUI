
/// Amount of space a view is offered.
package struct ProposedSize {
  package let width: Horizontal
  package let height: Vertical

  package init(width: Horizontal, height: Vertical) {
    self.width = width
    self.height = height
  }
}
