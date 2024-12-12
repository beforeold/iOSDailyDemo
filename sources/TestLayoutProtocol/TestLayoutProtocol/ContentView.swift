import SwiftUI

struct GridSection: Identifiable {
  let id: UUID = UUID()
  let title: String
  let items: [GridItem]
}

struct GridItem: Identifiable {
  let id: UUID = UUID()
  let content: String
}

struct SectionedGridLayout: Layout {
  func makeCache(subviews: Subviews) -> Void? {
    nil
  }

  let columns: Int
  let spacing: CGFloat
  let headerHeight: CGFloat

  func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void?) -> CGSize {
    let columnWidth = (proposal.width ?? 0 - CGFloat(columns - 1) * spacing) / CGFloat(columns)
    var totalHeight: CGFloat = 0

    var currentRowItemCount = 0
    for subview in subviews {
      if subview[HeaderKey.self] {
        totalHeight += headerHeight + spacing
        currentRowItemCount = 0
      } else {
        currentRowItemCount += 1
        if currentRowItemCount == 1 {  // First item in a new row
          totalHeight += columnWidth + spacing
        }
        if currentRowItemCount == columns {
          currentRowItemCount = 0
        }
      }
    }

    return CGSize(width: proposal.width ?? 0, height: totalHeight)
  }

  func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void?) {
    let columnWidth = (bounds.width - CGFloat(columns - 1) * spacing) / CGFloat(columns)
    var xOffset: CGFloat = 0
    var yOffset: CGFloat = 0
    var currentRowItemCount = 0

    for subview in subviews {
      if subview[HeaderKey.self] {
        // Place header
        subview.place(
          at: CGPoint(x: bounds.minX, y: bounds.minY + yOffset),
          anchor: .topLeading,
          proposal: ProposedViewSize(width: bounds.width, height: headerHeight)
        )
        yOffset += headerHeight + spacing
        currentRowItemCount = 0  // Reset for new section
      } else {
        // Place grid item
        let columnIndex = currentRowItemCount % columns
        xOffset = CGFloat(columnIndex) * (columnWidth + spacing)
        subview.place(
          at: CGPoint(x: bounds.minX + xOffset, y: bounds.minY + yOffset),
          anchor: .topLeading,
          proposal: ProposedViewSize(width: columnWidth, height: columnWidth)
        )

        currentRowItemCount += 1
        if currentRowItemCount % columns == 0 {  // Move to next row
          yOffset += columnWidth + spacing
        }
      }
    }
  }
}

struct HeaderKey: LayoutValueKey {
  static var defaultValue: Bool = false
  typealias Value = Bool
}

struct SectionedGridView: View {
  let sections: [GridSection]

  let columns: Int = 3
  let spacing: CGFloat = 16
  let headerHeight: CGFloat = 50

  var body: some View {
    ScrollView {
      LazyVStack {
        SectionedGridLayout(
          columns: columns,
          spacing: spacing,
          headerHeight: headerHeight
        ) {
          ForEach(sections) { section in
            // Header
            Text(section.title)
              .font(.headline)
              .frame(maxWidth: .infinity, maxHeight: headerHeight)
              .background(Color.gray.opacity(0.2))
              .cornerRadius(8)
              .tag("header")  // Explicitly tag this view as a header
              .layoutValue(key: HeaderKey.self, value: true)

            // Items
            ForEach(section.items) { item in
              GridItemView(content: item.content)
            }
          }
        }
        .padding()
      }
    }
  }
}

struct GridItemView: View {
  let content: String

  var body: some View {
    Text(content)
      .font(.caption)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .aspectRatio(1, contentMode: .fit)
      .background(Color.blue)
      .foregroundColor(.white)
      .cornerRadius(8)
  }
}

struct ContentView: View {
  let sections: [GridSection] = [
    GridSection(title: "Section 1", items: (1...9).map { GridItem(content: "Item \($0)") }),
    GridSection(title: "Section 2", items: (10...18).map { GridItem(content: "Item \($0)") }),
    GridSection(title: "Section 3", items: (19...27).map { GridItem(content: "Item \($0)") }),
  ]

  var body: some View {
    SectionedGridView(sections: sections)
  }
}

#Preview {
  ContentView()
}
