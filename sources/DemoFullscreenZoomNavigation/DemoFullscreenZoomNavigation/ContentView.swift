import SwiftUI

struct DemoItem: Identifiable, Hashable {
  var id: String { title }
  let title: String
  let detail: String
}

struct ContentView: View {
  private let items: [DemoItem] = [
    .init(title: "First Item", detail: "This is a simple detail screen for the first item."),
    .init(title: "Second Item", detail: "Another example detail view presented full screen."),
    .init(title: "Third Item", detail: "Use this to show more context about the tapped row."),
    .init(title: "Fourth Item", detail: "Details can include any content you need."),
    .init(title: "Fifth Item", detail: "Tap close to return to the list.")
  ]

  @Namespace private var zoomNamespace
  @State private var selectedItem: DemoItem?

  var body: some View {
    NavigationStack {
      List(items) { item in
        Button {
          selectedItem = item
        } label: {
          ItemCard(item: item, namespace: zoomNamespace)
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
      }
      .onAppear {
        print("appear")
      }
      .onDisappear {
        print("disappear")
      }
      .navigationTitle("Items")
      .fullScreenCover(item: $selectedItem) { item in
        DetailView(
          item: item,
          namespace: zoomNamespace
        ) {
          selectedItem = nil
        }
        .navigationTransition(.zoom(sourceID: item.id, in: zoomNamespace))
      }
    }
  }
}

private struct ItemCard: View {
  let item: DemoItem
  let namespace: Namespace.ID

  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        Text(item.title)
          .font(.headline)
        Text("Tap to open detail")
          .font(.subheadline)
          .foregroundStyle(.secondary)
      }
      Spacer()
      Image(systemName: "chevron.right")
        .foregroundStyle(.tertiary)
    }
    .padding()
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(.thinMaterial)
    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    .matchedTransitionSource(id: item.id, in: namespace)
  }
}

private struct DetailView: View {
  let item: DemoItem
  let namespace: Namespace.ID
  let dismiss: () -> Void

  var body: some View {
    ZStack(alignment: .topTrailing) {
      Color(.systemBackground)
        .ignoresSafeArea()

      VStack(alignment: .leading, spacing: 20) {
        ItemCard(item: item, namespace: namespace)
          .padding(.top, 40)
        Text(item.detail)
          .font(.body)
          .foregroundStyle(.primary)
        Spacer()
      }
      .padding(.horizontal)
      .matchedTransitionSource(id: item.id, in: namespace)

      Button {
        dismiss()
      } label: {
        Image(systemName: "xmark.circle.fill")
          .font(.system(size: 28, weight: .semibold))
          .foregroundStyle(.secondary)
          .padding()
      }
      .accessibilityLabel("Close")
    }
  }
}

#Preview {
  ContentView()
}
