@testable import AttributeGraph
import Testing

@Suite("Rule")
struct RuleTests {

  @Test("create")
  func create() {
    let graph = Graph()
    let rule = graph.rule("rule") { 12 }
    #expect(rule.value == 12)
    #expect(rule.name == "rule")
    #expect(rule.name.description == "rule")
  }

  @Test("update")
  func update() {
    let graph = Graph()
    let x = graph.attribute("x", value: 1)
    let y = graph.rule("y") { x.value * 2 }
    #expect(y.value == 2)
    x.value = 2
    #expect(y.value == 4)
  }

  @Test("dirty")
  func dirty() {
    let graph = Graph()
    let x = graph.attribute("x", value: 1)
    let y = graph.rule("y") { x.value * 2 }
    #expect(y.value == 2)

    x.value = 2
    #expect(y.dirty == true)
    #expect(y.value == 4)
    #expect(y.dirty == false)
  }
}
