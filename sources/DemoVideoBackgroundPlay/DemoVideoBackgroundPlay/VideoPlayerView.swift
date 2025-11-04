import Combine
import SwiftUI
import AVKit
import AVFoundation
#if os(iOS)
import UIKit
import MediaPlayer
#endif

class PlayerManager: NSObject, ObservableObject {
    static let shared = PlayerManager()
    var player: AVPlayer?
    @Published private var playerItem: AVPlayerItem?
    private var timeObserver: Any?

    private override init() {
        super.init()
        setupAudioSession()
        setupAudioInterruptionHandling()
    }
    
    func setupPlayer(with url: URL) {
        // 如果已有播放器，先清理
        if let existingPlayer = player {
            existingPlayer.pause()
            NotificationCenter.default.removeObserver(self)
        }
        
        print("🎬 开始创建播放器，URL: \(url)")
        
        // 创建播放项
        let item = AVPlayerItem(url: url)
        self.playerItem = item
        
        // 检查音频轨道
        item.asset.loadValuesAsynchronously(forKeys: ["tracks"]) {
            DispatchQueue.main.async {
                let audioTracks = item.asset.tracks(withMediaType: .audio)
                print("🔊 音频轨道数量: \(audioTracks.count)")
                if audioTracks.isEmpty {
                    print("⚠️ 警告：视频没有音频轨道，无法后台播放！")
                }
            }
        }
        
        // 创建播放器
        let newPlayer = AVPlayer(playerItem: item)
        
        // 配置播放器以支持后台播放
        newPlayer.allowsExternalPlayback = true
        newPlayer.automaticallyWaitsToMinimizeStalling = false
        
        self.player = newPlayer
        
        // 监听播放状态
        setupNotifications(for: newPlayer)

        // 配置 Now Playing 信息与远程控制
        #if os(iOS)
        configureNowPlayingInfo()
        setupRemoteCommandCenter()
        addTimeObserver()
        #endif
        
        // 延迟一下再播放，确保音频会话已激活
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            newPlayer.play()
            print("▶️ 播放器开始播放，rate: \(newPlayer.rate)")
        }
    }
    
    private func setupAudioSession() {
        #if os(iOS)
        do {
            let audioSession = AVAudioSession.sharedInstance()
            // 配置为 playback 类别，支持后台播放
            // 添加 mixWithOthers 选项，避免与其他音频冲突
            try audioSession.setCategory(.playback, mode: .moviePlayback, options: [])
            try audioSession.setActive(true, options: [])
            print("✅ 音频会话配置成功，支持后台播放")
        } catch {
            print("❌ 配置音频会话失败: \(error.localizedDescription)")
        }
        #endif
    }
    
    private func setupAudioInterruptionHandling() {
        #if os(iOS)
        // 监听音频会话中断
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAudioSessionInterruption),
            name: AVAudioSession.interruptionNotification,
            object: AVAudioSession.sharedInstance()
        )
        
        // 监听音频路由变化
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAudioSessionRouteChange),
            name: AVAudioSession.routeChangeNotification,
            object: AVAudioSession.sharedInstance()
        )
        #endif
    }
    
    #if os(iOS)
    private func configureNowPlayingInfo() {
        var info: [String: Any] = [
            MPMediaItemPropertyTitle: "Demo Video",
        ]
        if let item = playerItem {
            let duration = CMTimeGetSeconds(item.asset.duration)
            if duration.isFinite {
                info[MPMediaItemPropertyPlaybackDuration] = duration
            }
        }
        info[MPNowPlayingInfoPropertyPlaybackRate] = player?.rate ?? 0
        info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(player?.currentTime() ?? .zero)
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }

    private func setupRemoteCommandCenter() {
        let center = MPRemoteCommandCenter.shared()
        center.playCommand.isEnabled = true
        center.pauseCommand.isEnabled = true
        center.togglePlayPauseCommand.isEnabled = true

        center.playCommand.addTarget { [weak self] _ in
            self?.player?.play()
            self?.updateNowPlayingRate()
            return .success
        }
        center.pauseCommand.addTarget { [weak self] _ in
            self?.player?.pause()
            self?.updateNowPlayingRate()
            return .success
        }
        center.togglePlayPauseCommand.addTarget { [weak self] _ in
            if let rate = self?.player?.rate, rate > 0 {
                self?.player?.pause()
            } else {
                self?.player?.play()
            }
            self?.updateNowPlayingRate()
            return .success
        }
    }

    private func updateNowPlayingRate() {
        guard var info = MPNowPlayingInfoCenter.default().nowPlayingInfo else { return }
        info[MPNowPlayingInfoPropertyPlaybackRate] = player?.rate ?? 0
        info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(player?.currentTime() ?? .zero)
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }

    private func addTimeObserver() {
        guard timeObserver == nil else { return }
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] _ in
            self?.updateNowPlayingRate()
        }
    }
    @objc private func handleAudioSessionInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
            return
        }
        
        switch type {
        case .began:
            print("🔇 音频会话被中断（开始）")
            // 中断开始，播放器会自动暂停
        case .ended:
            print("🔊 音频会话中断结束")
            // 中断结束，尝试恢复播放
            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    // 应该恢复播放
                    do {
                        try AVAudioSession.sharedInstance().setActive(true)
                        player?.play()
                        print("   ✅ 恢复播放")
                    } catch {
                        print("   ❌ 恢复播放失败: \(error.localizedDescription)")
                    }
                }
            }
        @unknown default:
            break
        }
    }
    
    @objc private func handleAudioSessionRouteChange(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
            return
        }
        
        print("🔀 音频路由变化: \(reason.rawValue)")
        
        switch reason {
        case .oldDeviceUnavailable:
            // 旧设备不可用（例如拔出耳机）
            print("   设备断开连接")
        default:
            break
        }
    }
    #endif
    
    private func setupNotifications(for player: AVPlayer) {
        #if os(iOS)
        // 监听应用生命周期
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        #endif
        
        // 监听播放结束
        if let item = playerItem {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(playerItemDidPlayToEndTime),
                name: .AVPlayerItemDidPlayToEndTime,
                object: item
            )
        }
    }
    
    #if os(iOS)
    @objc private func applicationDidEnterBackground() {
        print("📱 应用进入后台，确保播放继续")
        print("   当前播放状态 - rate: \(player?.rate ?? -1)")
        
        // 重新激活音频会话
        do {
            let audioSession = AVAudioSession.sharedInstance()
            // 确保类别正确，使用与初始化相同的配置
            try audioSession.setCategory(.playback, mode: .moviePlayback, options: [])
            try audioSession.setActive(true, options: [])
            print("   ✅ 音频会话已激活")
        } catch {
            print("   ❌ 重新激活音频会话失败: \(error.localizedDescription)")
        }
        
        // 确保播放继续
        if let player = player {
            if player.rate == 0 {
                print("   播放器已暂停，重新开始播放")
                player.play()
            } else {
                print("   播放器正在播放")
            }
            // 再次检查状态
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                print("   后台播放检查 - rate: \(player.rate)")
                if player.rate == 0 {
                    print("   ⚠️ 播放器在后台被暂停了，尝试恢复")
                    player.play()
                }
            }
        }
    }
    
    @objc private func applicationWillEnterForeground() {
        print("📱 应用返回前台")
        print("   当前播放状态 - rate: \(player?.rate ?? -1)")
        if let player = player, player.rate == 0 {
            player.play()
        }
    }
    #endif
    
    @objc private func playerItemDidPlayToEndTime() {
        print("播放结束")
        // 可以在这里添加循环播放逻辑
    }
    
    deinit {
        #if os(iOS)
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
        }
        #endif
        NotificationCenter.default.removeObserver(self)
    }
}

#if os(iOS)
// 使用 AVPlayerViewController 支持后台播放
struct AVPlayerViewControllerRepresented: UIViewControllerRepresentable {
    let player: AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = true
        controller.allowsPictureInPicturePlayback = true
        // 关闭自动更新 Now Playing，我们手动管理
        controller.updatesNowPlayingInfoCenter = false
        // 确保视频可以在后台继续播放
        controller.entersFullScreenWhenPlaybackBegins = false
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // 不需要更新
    }
}
#endif

struct VideoPlayerView: View {
    let videoURL: URL
    @ObservedObject private var playerManager = PlayerManager.shared
    @State private var hasSetupPlayer = false
    
    var body: some View {
        #if os(iOS)
        Group {
            if let player = playerManager.player {
                AVPlayerViewControllerRepresented(player: player)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        if !hasSetupPlayer {
                            playerManager.setupPlayer(with: videoURL)
                            hasSetupPlayer = true
                        } else {
                            // 如果播放器已存在但未播放，则继续播放
                            if player.rate == 0 {
                                player.play()
                            }
                        }
                    }
            } else {
                ProgressView("加载中...")
                    .onAppear {
                        playerManager.setupPlayer(with: videoURL)
                    }
            }
        }
        #else
        Text("仅支持 iOS")
        #endif
    }
}

