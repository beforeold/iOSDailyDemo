import SwiftUI
import AVFoundation

@main
struct DemoVideoBackgroundPlayApp: App {
  init() {
    // 配置音频会话以支持后台播放
    configureAudioSession()
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
  
  private func configureAudioSession() {
    #if os(iOS)
    do {
      let audioSession = AVAudioSession.sharedInstance()
      // 配置为 playback 类别，支持后台播放
      try audioSession.setCategory(.playback, mode: .moviePlayback, options: [])
      try audioSession.setActive(true, options: [])
      print("✅ App 音频会话配置成功，支持后台播放")
    } catch {
      print("❌ App 配置音频会话失败: \(error.localizedDescription)")
    }
    #endif
  }
}
