
struct ViewInputs {
  let canvas: any Canvas
  let environment: EnvironmentValues

  init(
    canvas: any Canvas,
    environment: EnvironmentValues = EnvironmentValues()
  ) {
    self.canvas = canvas
    self.environment = environment
  }
}
