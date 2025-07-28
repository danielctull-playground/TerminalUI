import AttributeGraph

struct ViewOutputs {
  let displayItems: [DisplayItem]
}

extension ViewOutputs {
  init(displayItem: DisplayItem) {
    self.init(displayItems: [displayItem])
  }
}
