@testable import TerminalUI
import TerminalUITesting
@testable import AttributeGraph
import Testing


private struct TestView: View {
  var body: some View {
    Text("A")
      .blinking()
  }
}

@Test("testing")
func testing() async throws {




  let graph = Graph()
  let canvas = TestCanvas(width: 100, height: 100)

  @Attribute var node: TestView
  @Input var environment: EnvironmentValues

  _node = graph.attribute("node") { TestView() }
  _environment = graph.input("environment", EnvironmentValues())



  let inputs = ViewInputs(
    graph: graph,
    canvas: canvas,
    dynamicProperties: DynamicProperties(
      graph: graph,
      environment: $environment
    ),
    node: $node)


  let outputs = TestView.makeView(inputs: inputs)

  func process(_ value: Any, indent: Int = 0) {
    print("\(String(repeating: " ", count: indent))\(value)")
    if let dependant = value as? Dependant {
      for dependency in dependant.dependencies {
        process(dependency.name, indent: indent + 2)
      }
    }
  }

  _ = outputs.displayItems

  process(outputs.$displayItems)


  print(outputs.$displayItems.dependencies)
  print(outputs.$displayItems.dependants)






}
