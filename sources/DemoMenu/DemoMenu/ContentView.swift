import SwiftUI

struct ContentView: View {
  private enum Gender: String, CaseIterable, Identifiable {
    case male = "Male"
    case female = "Female"
    case other = "Other"

    var id: Self { self }
  }

  enum ContextAction: String, CaseIterable, Identifiable {
    case inspect = "Inspect"
    case duplicate = "Duplicate"
    case archive = "Archive"

    var id: Self { self }

    var icon: String {
      switch self {
      case .inspect: return "eye"
      case .duplicate: return "square.on.square"
      case .archive: return "archivebox"
      }
    }
  }

  @State private var selectedGender: Gender = .male
  @State private var selectedContextAction: ContextAction = .inspect

  var body: some View {
    VStack(spacing: 16) {
      Picker("Gender", selection: $selectedGender) {
        ForEach(Gender.allCases) { gender in
          VStack {
            Image(systemName: "gear")
            Text(gender.rawValue)
          }
          .tag(gender)
        }
      }
      .pickerStyle(.menu)

      Text("Selected: \(selectedGender.rawValue)")

      ContextActionPicker(selection: $selectedContextAction)

      Text("Context action: \(selectedContextAction.rawValue)")
    }
    .padding()
  }
}

private struct ContextActionPicker: View {
  @Binding var selection: ContentView.ContextAction

  var body: some View {
    Menu {
      Picker("Context Action", selection: $selection) {
        ForEach(ContentView.ContextAction.allCases) { action in
          Label(action.rawValue, systemImage: action.icon)
            .tag(action)
        }
      }

      Divider()

      Button(role: .destructive) {
        selection = .inspect
      } label: {
        Label("Reset to Inspect", systemImage: "arrow.uturn.backward")
      }
    }
    label: {
      Label("Action: \(selection.rawValue)", systemImage: selection.icon)
        .frame(maxWidth: .infinity)
        .padding()
        .background(.ultraThickMaterial, in: .rect(cornerRadius: 12))
        .overlay(
          RoundedRectangle(cornerRadius: 12)
            .stroke(.tertiary, lineWidth: 1)
        )
    }
  }
}

#Preview {
  ContentView()
}
