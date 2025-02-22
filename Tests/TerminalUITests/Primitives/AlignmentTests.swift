import TerminalUI
import TerminalUITesting
import Testing

@Suite("Alignment") struct AlignmentTests {

  @Test("static values", arguments: Array<
    (Alignment,       VerticalAlignment, HorizontalAlignment)
  >([
    (.topLeading,     .top,              .leading ),
    (.top,            .top,              .center  ),
    (.topTrailing,    .top,              .trailing),
    (.leading,        .center,           .leading ),
    (.center,         .center,           .center  ),
    (.trailing,       .center,           .trailing),
    (.bottomLeading,  .bottom,           .leading ),
    (.bottom,         .bottom,           .center  ),
    (.bottomTrailing, .bottom,           .trailing),
  ]))
  func staticValues(
    alignment: Alignment,
    vertical: VerticalAlignment,
    horizontal: HorizontalAlignment
  ) {
    #expect(alignment.horizontal == horizontal)
    #expect(alignment.vertical == vertical)
  }
}
