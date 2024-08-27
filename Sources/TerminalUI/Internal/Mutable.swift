
/// Acts as a mutable box for values in a struct.
@propertyWrapper
final class Mutable<Value> {
  var wrappedValue: Value
  init(wrappedValue: Value) {
    self.wrappedValue = wrappedValue
  }
}
