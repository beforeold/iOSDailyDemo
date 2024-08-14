import SwiftUI

struct OverlayGradient: View {
  var body: some View {
    ZStack(alignment: .bottom) {
      Image("Pic")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 300, height: 300)
        .overlay(.thinMaterial)
        .mask(
            LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black]), startPoint: .top, endPoint: .bottom)
        )
    }
    .frame(width: 300, height: 300)
    //    .background(Color.red)
    .padding(50)
    //    .background(Color.green)
  }
}

#Preview {
  OverlayGradient()
}
