import SwiftUI


struct FilmView: View {
  var body: some View {
    VStack {
      Rectangle()
        .fill(Color.red)
        .frame(width: 40, height: 40)
    }
  }
}

struct ContentView: View {
  var body: some View {
    VStack {
      Rectangle()
        .fill(Color.blue)
        .frame(width: 100, height: 100)
    }
//    .overlay(alignment: .bottom) {
//      FilmView()
//        .alignmentGuide(.bottom) { $0[VerticalAlignment.top] }
//    }
//    .overlay(alignment: .topTrailing) {
//      FilmView()
//    }
    .overlay(alignment: .topTrailing) {
      FilmView()
        .alignmentGuide(.trailing) { d in d.width / 2 }
        .alignmentGuide(.top) { d in d.height / 2 }
    }
  }
}

#Preview {
  ContentView()
    .preferredColorScheme(.dark)
}
