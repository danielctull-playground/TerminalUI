
public struct Label<Title: View, Icon: View>: View {

  @Environment(\.labelStyle) private var style
  private let title: Title
  private let icon: Icon

  public init(@ViewBuilder title: () -> Title, @ViewBuilder icon: () -> Icon) {
    self.title = title()
    self.icon = icon()
  }

  public var body: some View {
    let configuration = LabelStyle.Configuration(title: title, icon: icon)
    AnyView(style.resolve(configuration: configuration))
  }
}

// MARK: - LabelStyle

public protocol LabelStyle/*: DynamicProperty*/ {

  typealias Configuration = LabelStyleConfiguration
  associatedtype Body: View

  @ViewBuilder
  func makeBody(configuration: Configuration) -> Body
}

extension View {

  public func labelStyle(_ style: some LabelStyle) -> some View {
    environment(\.labelStyle, style)
  }
}

extension EnvironmentValues {
  @Entry fileprivate var labelStyle: any LabelStyle = .titleAndIcon
}

// MARK: - LabelStyleConfiguration

public struct LabelStyleConfiguration {

  public struct Title: View {
    fileprivate let base: AnyView
    public var body: some View { base }
  }

  public struct Icon: View {
    fileprivate let base: AnyView
    public var body: some View { base }
  }

  public let title: Title
  public let icon: Icon

  fileprivate init(title: some View, icon: some View) {
    self.title = Title(base: AnyView(title))
    self.icon = Icon(base: AnyView(icon))
  }
}

extension LabelStyle {

  fileprivate func resolve(configuration: Configuration) -> some View {
    ResolvedLabelStyle(style: self, configuration: configuration)
  }
}

private struct ResolvedLabelStyle<Style: LabelStyle>: View {

  let style: Style
  let configuration: Style.Configuration

  var body: some View {
    style.makeBody(configuration: configuration)
  }
}

// MARK: - TitleAndIconLabelStyle

extension LabelStyle where Self == TitleAndIconLabelStyle {
  public static var titleAndIcon: Self { Self() }
}

public struct TitleAndIconLabelStyle: LabelStyle {
  public func makeBody(configuration: Configuration) -> some View {
    HStack(spacing: 1) {
      configuration.icon
      configuration.title
    }
  }
}

// MARK: - TitleOnlyLabelStyle

extension LabelStyle where Self == TitleOnlyLabelStyle {
  public static var titleOnly: Self { Self() }
}

public struct TitleOnlyLabelStyle: LabelStyle {
  public func makeBody(configuration: Configuration) -> some View {
    configuration.title
  }
}

// MARK: - IconOnlyLabelStyle

extension LabelStyle where Self == IconOnlyLabelStyle {
  public static var iconOnly: Self { Self() }
}

public struct IconOnlyLabelStyle: LabelStyle {
  public func makeBody(configuration: Configuration) -> some View {
    configuration.icon
  }
}
