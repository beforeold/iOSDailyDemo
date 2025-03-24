import SwiftUI

struct RotatingDotView: View {
  var isAnimating = false

  var body: some View {
    ZStack {
      // 背景
      Color(.black)
        .ignoresSafeArea()

      // 白色背景容器
      RoundedRectangle(cornerRadius: 20)
        .fill(Color(.systemGray6))
        .frame(width: 300, height: 200)

      // 头像
      Image(systemName: "photo")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 36, height: 36)
        .clipShape(Circle())

      if isAnimating {
        TaskAnimationView(
          color: .orange,
          size: CGSize(width: 36, height: 36)
        )
      }
    }
  }
}

struct TaskAnimationView: View {
  @State private var isAnimating = false

  var color: Color
  var size: CGSize

  var body: some View {
    ZStack {
      Circle()
        .stroke(color, lineWidth: 1)
        .frame(width: size.width, height: size.height)

      // 小球
      Circle()
        .strokeBorder(Color.white, lineWidth: 1)
        .background(Circle().fill(color))
        .frame(width: 6, height: 6)
        .offset(x: size.width * 0.5)  // 半径距离
        .rotationEffect(.degrees(isAnimating ? 360 : 0))
        .animation(
          .linear(duration: 1.5).repeatForever(autoreverses: false),
          value: isAnimating
        )
    }
    .onAppear {
      isAnimating = true
    }
  }
}

struct ContentView: View {
  @State private var isAnimating = true

  var body: some View {
    NavigationStack {
      VStack {
        RotatingDotView(isAnimating: isAnimating)

        Toggle(isOn: $isAnimating) { Text("Is Animating") }
        NavigationLink("Detail") {
          Text("Detail Content")
        }
      }
    }
  }
}

#Preview {
  ContentView()
}
