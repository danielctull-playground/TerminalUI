
protocol Dependency: AnyObject {
  var dependants: [any Dependant] { get set }
}

protocol Dependant: AnyObject {
  var dependencies: [any Dependency] { get set }
  var dirty: Bool { get set }
}
