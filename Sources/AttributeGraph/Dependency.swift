
protocol Dependency: AnyObject {
  var dependants: [Dependant] { get set }
}

protocol Dependant: AnyObject {
  var dependencies: [Dependency] { get set }
  var dirty: Bool { get set }
}
