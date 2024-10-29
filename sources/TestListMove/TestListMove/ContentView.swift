import SwiftUI

struct ContentView: View {
  @State private var items = ["Item 1", "Item 2", "Item 3", "Item 4"]
  @State private var isEditing = false

  var body: some View {
    NavigationView {
      List {
        ForEach(items, id: \.self) { item in
          Text(item)
        }
        .onMove(perform: move)
      }
      .navigationTitle("Orderable List")
      .navigationBarItems(
        leading: EditButton(), // Provides an edit button for reordering
        trailing: Button(action: { isEditing.toggle() }) {
          Text(isEditing ? "Done" : "Edit2")
        }
      )
      .environment(\.editMode, isEditing ? .constant(.active) : .constant(.inactive))
    }
  }

  // Move function to reorder items
  private func move(from source: IndexSet, to destination: Int) {
    items.move(fromOffsets: source, toOffset: destination)
  }
}

#Preview {
  ContentView()
}
