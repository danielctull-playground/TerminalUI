
public struct EnvironmentValues {

  private var values: [ObjectIdentifier: Any] = [:]

  public subscript<Key: EnvironmentKey>(key: Key.Type) -> Key.Value {
    get { values[ObjectIdentifier(key)] as? Key.Value ?? Key.defaultValue }
    set { values[ObjectIdentifier(key)] = newValue }
  }
}
