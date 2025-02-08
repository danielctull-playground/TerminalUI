import AttributeGraph
import Testing

@Suite("Input")
struct InputTests {

  @Test("create")
  func create() {
    let graph = Graph()
    let input = graph.input("x", 12)
    #expect(input.value == 12)
    #expect(input.name == "x")
    #expect(input.name.description == "x")
  }
}
