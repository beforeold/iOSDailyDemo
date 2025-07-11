import Observation
import PhotosUI
import SwiftUI

struct ContentView: View {
  class ViewModel: ObservableObject {
    @Published var isPresented = false {
      didSet {
        print("ispresented", isPresented)
      }
    }

    var selection: [PhotosPickerItem] = [] {
      didSet {
        print("selected", selection)
      }
    }
  }

  @State private var isPresented = false

  @ObservedObject private var viewModel = ViewModel()

  var body: some View {
    VStack {
      Button("Pick") {
        viewModel.isPresented = true
      }
    }
    .padding()
    .photosPicker(
      isPresented: $viewModel.isPresented,
      selection: $viewModel.selection,
      maxSelectionCount: 5,
    )
  }
}

#Preview {
  ContentView()
}
