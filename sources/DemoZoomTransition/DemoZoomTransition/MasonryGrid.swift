import SwiftUI

struct MasonryGrid<Content: View, T: Identifiable>: View {
  private let items: [T]
  private let columns: Int
  private let spacing: CGFloat
  private let content: (T) -> Content

  init(
    items: [T],
    columns: Int = 2,
    spacing: CGFloat = 8,
    @ViewBuilder content: @escaping (T) -> Content
  ) {
    self.items = items
    self.columns = max(columns, 1)
    self.spacing = spacing
    self.content = content
  }

  var body: some View {
    ScrollView {
      MasonryLayout(columns: columns, spacing: spacing) {
        ForEach(items) { item in
          content(item)
        }
      }
      .padding(.horizontal, spacing)
    }
  }
}

struct MasonryLayout: Layout {
  let columns: Int
  let spacing: CGFloat

  func sizeThatFits(
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout ()
  ) -> CGSize {
    let width = proposal.replacingUnspecifiedDimensions().width
    let itemWidth = (width - spacing * CGFloat(columns - 1)) / CGFloat(columns)

    var columnHeights = [CGFloat](repeating: 0, count: columns)

    for subview in subviews {
      let size = subview.sizeThatFits(.init(width: itemWidth, height: nil))
      let idx = columnHeights.enumerated().min(by: { $0.element < $1.element })!.offset
      columnHeights[idx] += size.height + spacing
    }

    let height = columnHeights.max() ?? 0
    return CGSize(width: width, height: height)
  }

  func placeSubviews(
    in bounds: CGRect,
    proposal: ProposedViewSize,
    subviews: Subviews,
    cache: inout ()
  ) {
    let itemWidth = (bounds.width - spacing * CGFloat(columns - 1)) / CGFloat(columns)
    var yOffsets = [CGFloat](repeating: bounds.minY, count: columns)

    for subview in subviews {
      let size = subview.sizeThatFits(.init(width: itemWidth, height: nil))
      let idx = yOffsets.enumerated().min(by: { $0.element < $1.element })!.offset
      let x = bounds.minX + CGFloat(idx) * (itemWidth + spacing)
      let y = yOffsets[idx]

      subview.place(
        at: CGPoint(x: x, y: y),
        proposal: .init(width: itemWidth, height: size.height)
      )

      yOffsets[idx] += size.height + spacing
    }
  }
}

struct DemoView: View {
  struct Photo: Identifiable {
    let id = UUID()
    let url: URL
    let height: CGFloat
  }

  let photos: [Photo] = [
    // populate with URL + varying heights
  ]

  var body: some View {
    MasonryGrid(items: photos, columns: 2, spacing: 8) { photo in
      AsyncImage(url: photo.url) { phase in
        switch phase {
        case .success(let img):
          img.resizable()
            .aspectRatio(contentMode: .fill)
            .frame(height: photo.height)
            .clipped()
            .background(Color.gray)
        default:
          ProgressView()
            .frame(height: photo.height)
        }
      }
    }
  }
}

#Preview {
  DemoView()
}
