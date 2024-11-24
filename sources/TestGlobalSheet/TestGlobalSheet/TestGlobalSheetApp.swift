import SwiftUI

@main
struct TestGlobalSheetApp: App {

  @State private var selectedSheet: Sheet?
  @State private var onSheetDismiss: (() -> Void)?

  var body: some Scene {
    WindowGroup {
      NavigationStack {
        ContentView()
          .environment(
            \.showSheet,
            SheetAction(action: { sheet, dismiss in
              selectedSheet = sheet
              onSheetDismiss = dismiss
            })
          )
          .sheet(item: $selectedSheet, onDismiss: onSheetDismiss) { sheet in
            SheetView(sheet: sheet)
          }
      }
    }
  }
}
