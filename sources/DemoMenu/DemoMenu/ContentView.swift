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
  @State private var selectedInterests: Set<Interest> = [.design]

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

      InterestPicker(selection: $selectedInterests)

      Text("Interests: \(interestSummary)")
    }
    .padding()
  }

  enum Interest: String, CaseIterable, Identifiable {
    case design = "Design"
    case engineering = "Engineering"
    case marketing = "Marketing"
    case support = "Support"

    var id: Self { self }
  }

  private var interestSummary: String {
    if selectedInterests.isEmpty {
      return "None"
    }
    return selectedInterests.map(\.rawValue).sorted().joined(separator: ", ")
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

private struct InterestPicker: View {
  @Binding var selection: Set<ContentView.Interest>

  private func toggle(_ interest: ContentView.Interest) {
    if selection.contains(interest) {
      selection.remove(interest)
    } else {
      selection.insert(interest)
    }
  }

  var body: some View {
    Menu {
      ForEach(ContentView.Interest.allCases) { interest in
        Button {
          toggle(interest)
        } label: {
          Label(
            interest.rawValue,
            systemImage: selection.contains(interest) ? "checkmark.circle.fill" : "circle"
          )
        }
      }

      Divider()

      Button(role: .destructive) {
        selection.removeAll()
      } label: {
        Label("Clear all", systemImage: "trash")
      }
    }
    label: {
      Label(
        selection.isEmpty ? "Pick interests" : "Interests (\(selection.count))",
        systemImage: selection.isEmpty ? "line.3.horizontal.decrease.circle" : "checkmark.circle"
      )
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
