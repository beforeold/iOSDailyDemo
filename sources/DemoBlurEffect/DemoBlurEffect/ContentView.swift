import SwiftUI

private struct BlurPreset: Identifiable {
  let id = UUID()
  let title: String
  let value: Int
}

struct ContentView: View {
  private let imageURL = URL(
    string: "https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg?auto=compress&cs=tinysrgb&w=1200"
  )!

  private let presets: [BlurPreset] = (0..<100).map {
    BlurPreset(title: "#\($0)", value: $0)
  }

  var body: some View {
    ScrollView {
      LazyVStack(spacing: 28) {
        Text("Blur Styles From Objective-C")
          .font(.system(.largeTitle))
          .foregroundStyle(.white)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.horizontal)
          .padding(.top, 16)

        ForEach(presets) { preset in
          BlurCard(imageURL: imageURL, preset: preset)
        }
      }
      .padding(.bottom, 32)
    }
    .background(Color.black.opacity(0.95).ignoresSafeArea())
  }
}

private struct BlurCard: View {
  let imageURL: URL
  let preset: BlurPreset

  private let cornerRadius: CGFloat = 24

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text(preset.title)
        .font(.headline)
        .foregroundStyle(.secondary)

      ZStack(alignment: .bottomLeading) {
        RemoteImage(url: imageURL)
        BlurEffectView(styleValue: preset.value)
        Text("Blur value \(preset.value)")
          .font(.subheadline)
          .bold()
          .padding(.horizontal, 12)
          .padding(.vertical, 8)
          .foregroundStyle(.white)
          .background(
            Color.black.opacity(0.35),
            in: Capsule()
          )
          .padding(16)
      }
      .frame(height: 220)
      .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
      .overlay(
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
          .stroke(.white.opacity(0.2), lineWidth: 1)
      )
      .shadow(color: .black.opacity(0.4), radius: 18, y: 6)
    }
    .padding(.horizontal)
  }
}

private struct RemoteImage: View {
  let url: URL

  var body: some View {
    AsyncImage(url: url) { phase in
      switch phase {
      case .success(let image):
        image
          .resizable()
          .scaledToFill()
          .transition(.opacity.combined(with: .scale))
      case .empty:
        ProgressView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(Color.gray.opacity(0.2))
      case .failure:
        VStack(spacing: 8) {
          Image(systemName: "wifi.slash")
            .font(.largeTitle)
          Text("Image unavailable")
            .font(.footnote)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundStyle(.secondary)
        .background(Color.gray.opacity(0.2))
      @unknown default:
        Color.gray.opacity(0.3)
      }
    }
    .clipped()
  }
}

private struct BlurEffectView: UIViewRepresentable {
  let styleValue: Int

  func makeUIView(context: Context) -> UIVisualEffectView {
    let view = UIVisualEffectView()
    view.backgroundColor = .clear
    view.isUserInteractionEnabled = false
    return view
  }

  func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    uiView.effect = BlurEffectProvider.effect(forStyleValue: styleValue)
  }
}

#Preview {
  ContentView()
}
