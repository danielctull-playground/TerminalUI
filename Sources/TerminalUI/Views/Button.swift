
public struct Button<Label> {

  @Environment(\.buttonStyle) private var buttonStyle
  private let action: () -> Void
  private let label: Label

  public init(action: @escaping () -> Void, @ViewBuilder label: () -> Label) {
    self.action = action
    self.label = label()
  }
}

// MARK: - View

extension Button: View where Label: View {

  public var body: some View {
    content
      .focusable()
      .onKeyPress { keyPress in
        guard keyPress == .space || keyPress == .return else { return .ignored }
        action()
        return .handled
      }
  }

  private var content: some View {
    let configuration = ButtonStyleConfiguration(label: label)
    let view = buttonStyle.resolve(configuration: configuration)
    return AnyView(view)
  }
}

// MARK: - Style

private struct DefaultButtonStyle: ButtonStyle {

  @Environment(\.isFocused) private var isFocused

  func makeBody(configuration: Configuration) -> some View {
    HStack {
      Text("[")
      configuration.label
      Text("]")
    }
    .bold(isFocused)
  }
}

public protocol ButtonStyle: DynamicProperty {

  typealias Configuration = ButtonStyleConfiguration
  associatedtype Body: View

  @ViewBuilder
  func makeBody(configuration: Configuration) -> Body
}

extension View {

  public func buttonStyle(_ style: some ButtonStyle) -> some View {
    environment(\.buttonStyle, style)
  }
}

public struct ButtonStyleConfiguration {

  public struct Label: View {
    fileprivate let base: AnyView
    public var body: some View { base }
  }

  public let label: Label

  fileprivate init(
    label: some View,
  ) {
    self.label = Label(base: AnyView(label))
  }
}

extension EnvironmentValues {
  @Entry fileprivate var buttonStyle: any ButtonStyle = DefaultButtonStyle()
}

extension ButtonStyle {

  fileprivate func resolve(configuration: Configuration) -> some View {
    ResolvedButtonStyle(style: self, configuration: configuration)
  }
}

private struct ResolvedButtonStyle<Style: ButtonStyle>: View {

  let style: Style
  let configuration: Style.Configuration

  var body: some View {
    style.makeBody(configuration: configuration)
  }
}
