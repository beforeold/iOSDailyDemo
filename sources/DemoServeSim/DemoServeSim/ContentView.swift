import AVFoundation
import SwiftUI
import os

private let logger = Logger(subsystem: "com.example.demoservesim", category: "playground")

struct ContentView: View {
  @State private var tapCount = 0
  @State private var typedText = ""
  @State private var dragOffset: CGSize = .zero
  @State private var accentIndex = 0
  @State private var showCameraPreview = false
  @State private var cursorVisible = true

  private let accents: [Color] = [Theme.clay, .teal, .indigo, .pink]

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(spacing: 16) {
          header

          ReceiptCard(command: "serve-sim tap <x> <y>", title: "Tap") {
            HStack(alignment: .firstTextBaseline, spacing: 16) {
              Text("\(tapCount)")
                .font(.system(size: 44, weight: .bold, design: .serif))
                .foregroundStyle(Theme.ink)
                .contentTransition(.numericText())
                .animation(.snappy, value: tapCount)

              Button {
                tapCount += 1
                logger.log("tap count = \(tapCount, privacy: .public)")
              } label: {
                Text("Tap me")
                  .font(.subheadline.weight(.semibold))
                  .padding(.horizontal, 18)
                  .padding(.vertical, 10)
              }
              .buttonStyle(.plain)
              .background(accents[accentIndex])
              .foregroundStyle(Theme.paper)
              .clipShape(Capsule())
            }
          }

          ReceiptCard(command: "serve-sim type \"…\"", title: "Type") {
            TextField("Type here", text: $typedText)
              .font(Theme.mono)
              .padding(12)
              .background(Theme.paper)
              .clipShape(RoundedRectangle(cornerRadius: 4))
              .overlay(
                RoundedRectangle(cornerRadius: 4)
                  .strokeBorder(Theme.ink.opacity(0.12), lineWidth: 1)
              )
              .onChange(of: typedText) { value in
                logger.log("typed: \(value, privacy: .public)")
              }
          }

          ReceiptCard(command: "serve-sim gesture '{…}'", title: "Drag") {
            RoundedRectangle(cornerRadius: 12)
              .fill(accents[accentIndex])
              .frame(width: 64, height: 64)
              .offset(dragOffset)
              .gesture(
                DragGesture()
                  .onChanged { dragOffset = $0.translation }
                  .onEnded { _ in
                    withAnimation(.spring) { dragOffset = .zero }
                  }
              )
              .frame(maxWidth: .infinity, minHeight: 100)
          }

          ReceiptCard(command: "serve-sim rotate <orientation>", title: "Recolor") {
            Button {
              accentIndex = (accentIndex + 1) % accents.count
              logger.log("accent index = \(accentIndex, privacy: .public)")
            } label: {
              Text("Cycle accent")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Theme.ink)
                .padding(.horizontal, 16)
                .padding(.vertical, 9)
                .overlay(
                  Capsule().strokeBorder(Theme.ink.opacity(0.25), lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
          }

          ReceiptCard(command: "serve-sim camera <bundle-id> --webcam", title: "Camera") {
            VStack(alignment: .leading, spacing: 12) {
              Toggle("Show camera preview", isOn: $showCameraPreview)
                .font(Theme.body)
                .tint(Theme.clay)
              if showCameraPreview {
                CameraPreview()
                  .frame(height: 180)
                  .clipShape(RoundedRectangle(cornerRadius: 4))
              }
            }
          }
        }
        .padding(20)
        .padding(.bottom, 12)
      }
      .background(Theme.paper)
      .toolbar(.hidden)
    }
    .task {
      while !Task.isCancelled {
        try? await Task.sleep(for: .milliseconds(600))
        cursorVisible.toggle()
      }
    }
  }

  private var header: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack(spacing: 0) {
        Text("DemoServeSim")
          .font(Theme.display)
          .foregroundStyle(Theme.ink)
        Text("_")
          .font(Theme.display)
          .foregroundStyle(Theme.clay)
          .opacity(cursorVisible ? 1 : 0)
      }

      Text("serve-sim playground")
        .font(Theme.mono)
        .foregroundStyle(Theme.clay)

      Text("Every card below is wired to a real terminal command. Run it from your Mac and this screen answers back.")
        .font(Theme.body)
        .foregroundStyle(Theme.stone)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.top, 8)
    .padding(.bottom, 4)
  }
}

private struct CameraPreview: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> CameraPreviewController {
    CameraPreviewController()
  }

  func updateUIViewController(_ uiViewController: CameraPreviewController, context: Context) {}
}

private final class CameraPreviewController: UIViewController {
  private let session = AVCaptureSession()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black
    configureSession()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    (view.layer.sublayers?.first as? AVCaptureVideoPreviewLayer)?.frame = view.bounds
  }

  private func configureSession() {
    guard let device = AVCaptureDevice.default(for: .video),
      let input = try? AVCaptureDeviceInput(device: device),
      session.canAddInput(input)
    else {
      logger.log("no camera input available")
      return
    }
    session.addInput(input)

    let previewLayer = AVCaptureVideoPreviewLayer(session: session)
    previewLayer.videoGravity = .resizeAspectFill
    previewLayer.frame = view.bounds
    view.layer.addSublayer(previewLayer)

    DispatchQueue.global(qos: .userInitiated).async { [session] in
      session.startRunning()
    }
  }

  deinit {
    session.stopRunning()
  }
}
