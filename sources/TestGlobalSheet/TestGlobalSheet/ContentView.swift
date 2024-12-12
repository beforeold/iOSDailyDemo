import SwiftUI

// https://gist.github.com/azamsharpschool/9e7732f85f85353de069425454d0e8dc


enum Sheet: Identifiable, Hashable {
  case settings
  case contact(String)

  var id: Self { self }
}

struct SheetAction {
  typealias Action = (Sheet, (() -> Void)?) -> Void
  let action: Action

  func callAsFunction(_ sheet: Sheet, _ dismiss: (() -> Void)? = nil) {
    action(sheet, dismiss)
  }
}

struct ShowSheetKey: EnvironmentKey {
  static var defaultValue: SheetAction = SheetAction { _, _ in }
}

extension EnvironmentValues {
  var showSheet: (SheetAction) {
    get { self[ShowSheetKey.self] }
    set { self[ShowSheetKey.self] = newValue }
  }
}

struct SheetView: View {

  let sheet: Sheet

  var body: some View {
    switch sheet {
    case .settings:
      Text("Settings")
    case .contact(let name):
      Text("Contacting \(name)")
    }
  }
}

// THIS IS JUST FOR THE PREVIEWS
struct ContentViewContainer: View {

  @State private var selectedSheet: Sheet?
  @State private var onSheetDismiss: (() -> Void)?

  var body: some View {
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

struct ContentView: View {

  @Environment(\.showSheet) private var showSheet

  @State private var customSheet = false

  private func settingsScreenDismissed() {
    print("settingsScreenDismissed")
  }

  var body: some View {
    VStack(spacing: 30) {
      Button("Show Settings Screen") {
        showSheet(.settings, settingsScreenDismissed)
      }

      Button("Show Contact Screen") {
        showSheet(.contact("John Doe"))
      }

      Button("Show Content Screen") {
        customSheet = true
      }
    }
    .sheet(isPresented: $customSheet, content: {
      CustomSheet()
    })
    .buttonStyle(.borderedProminent)
    .padding()
    .tint(.orange)
  }
}

struct CustomSheet: View {
  @Environment(\.showSheet) private var showSheet

  var body: some View {
    VStack {
      Text("this is custom sheet")

      Button("show global") {
        showSheet(.settings)
      }
    }
  }
}

#Preview {
  ContentViewContainer()
}
