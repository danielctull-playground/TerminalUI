
public protocol Layout {

  typealias Subviews = LayoutSubviews

  associatedtype Cache = Void

  func makeCache(
    subviews: Subviews
  ) -> Cache

  func sizeThatFits(
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout Cache
  ) -> Size

  func placeSubviews(
    in bounds: Rect,
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout Cache
  )
}

// MARK: - LayoutSubviews

public struct LayoutSubviews {
  fileprivate let raw: [LayoutSubview]
}

extension LayoutSubviews: RandomAccessCollection {
  public typealias Index = Int
  public var startIndex: Index { raw.startIndex }
  public var endIndex: Index { raw.endIndex }
  public func index(after i: Int) -> Int { raw.index(after: i) }
  public func index(before i: Int) -> Int { raw.index(before: i) }
  public subscript(position: Index) -> LayoutSubview { raw[position] }
}

// MARK: - LayoutSubview

public struct LayoutSubview {

  private let _sizeThatFits: (ProposedViewSize) -> Size
  private let _place: (Position, ProposedViewSize) -> Void

  fileprivate init(
    sizeThatFits: @escaping (ProposedViewSize) -> Size,
    place: @escaping (Position, ProposedViewSize) -> Void
  ) {
    _sizeThatFits = sizeThatFits
    _place = place
  }

  public func sizeThatFits(_ proposal: ProposedViewSize) -> Size {
    _sizeThatFits(proposal)
  }

  public func place(
    at position: Position,
    proposal: ProposedViewSize
  ) {
    _place(position, proposal)
  }
}

// MARK: - LayoutComputer

struct LayoutComputer {
  fileprivate let sizeThatFits: (ProposedViewSize) -> Size
  fileprivate let childGeometries: (Rect) -> [ChildGeometries]
}

extension Layout {

  fileprivate func computer(
    proposal: ProposedViewSize,
    subviews: [LayoutComputer]
  ) -> LayoutComputer {

    var geometries: [ChildGeometries] = Array(repeating: .empty, count: subviews.count)

    let subviews = LayoutSubviews(raw: subviews.enumerated().map { index, subview in
      LayoutSubview(
        sizeThatFits: subview.sizeThatFits,
        place: { position, proposal in
          let size = subview.sizeThatFits(proposal)
          geometries[index].frames.append(Rect(origin: position, size: size))
        })
    })

    var cache = makeCache(subviews: subviews)

    return LayoutComputer { proposal in

      sizeThatFits(
        proposal: proposal,
        subviews: subviews,
        cache: &cache)

    } childGeometries: { rect in

      placeSubviews(
        in: rect,
        proposal: ProposedViewSize(rect.size),
        subviews: subviews,
        cache: &cache)

      return geometries
    }
  }
}

// MARK: - ChildGeometries

private struct ChildGeometries: Sendable {
  var frames: [Rect]
}

extension ChildGeometries {
  static let empty = ChildGeometries(frames: [])
}
