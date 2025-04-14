import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
    }
    .padding()
  }
}

enum Route: Hashable {
    case list
    case detail(photo: Photo)
}

extension Route: View {
    var body: some View {
        switch self {
        case .list: ListView()
        case let .detail(photo): DetailView(photo: photo)
        }
    }
}

struct PhotoApp: App {
    @State var paths = NavigationPath()
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $paths) {
                ListView()
                    .navigationDestination(for: Route.self) { $0 }
            }
        }
    }
}

struct Photo: Hashable, Identifiable {
    var id = UUID()
    var title: String
    var favorited = false
}

class ListViewModel: ObservableObject {
    @Published var photoList: [Photo] = [
        .init(title: "aaa"),
        .init(title: "bbb"),
        .init(title: "ccc"),
    ]
    func favoritePhoto(_ photo: Photo?) {
        if let i = photoList.firstIndex(where: { $0.id == photo?.id }) {
            photoList[i].favorited.toggle()
        }
    }
}

struct ListView: View {
    @StateObject var vm = ListViewModel()
    var body: some View {
        List(vm.photoList) { photo in
            NavigationLink(value: Route.detail(photo: photo)) {
                ListRowView(photo: photo)
            }
        }
        .navigationTitle("List View")
    }
}

struct ListRowView: View {
  var photo: Photo

  var body: some View {
    Text(photo.title)
  }
}

struct DetailView: View {
  var photo: Photo

  var body: some View {
    Text(photo.title)
  }
}

#Preview {
  ContentView()
}
