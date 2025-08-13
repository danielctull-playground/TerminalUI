
protocol Dependency: AnyObject {
  var dependants: [any Dependant] { get set }
  var name: AttributeName { get }
}

protocol Dependant: AnyObject {
  var dependencies: [any Dependency] { get set }
  var dirty: Bool { get set }
}
