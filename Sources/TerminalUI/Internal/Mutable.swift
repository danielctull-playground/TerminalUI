
/// Acts as a mutable box for values in a struct.
@propertyWrapper
package final class Mutable<Value> {
  package var wrappedValue: Value
  package init(wrappedValue: Value) {
    self.wrappedValue = wrappedValue
  }
}
