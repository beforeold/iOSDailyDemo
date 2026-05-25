import Darwin
import Foundation
import ObjectiveC.runtime
import OSLog
import UIKit

@MainActor
final class AmbientMusicPrivateTrigger: ObservableObject {
    @Published private(set) var events: [TriggerEvent] = [
        TriggerEvent(kind: .info, message: "Ready for private Ambient Music probe.")
    ]
    @Published private(set) var intentSurface: AmbientMusicIntentSurface?
    @Published private(set) var isRunning = false

    private let adaptiveMusicPath = "/System/Library/PrivateFrameworks/AdaptiveMusic.framework/AdaptiveMusic"
    private let mediaRemotePath = "/System/Library/PrivateFrameworks/MediaRemote.framework/MediaRemote"
    private let ambientBundleID = "com.apple.AdaptiveMusicApp"
    private let directPlaybackTimeoutNanoseconds: UInt64 = 5_000_000_000
    private let eventLogger = Logger(
        subsystem: "com.example.ambientmusicprivate",
        category: "PrivateProbe"
    )
    private let ambientUserActivityTypes = [
        "com.apple.AdaptiveMusicApp",
        "com.apple.AdaptiveMusic.AdaptiveMusicWidget.single-mood",
        "com.apple.AdaptiveMusic.AdaptiveMusicWidget.multi-mood",
        "com.apple.AdaptiveMusicApp.AdaptiveMusicWidget",
        "com.apple.AdaptiveMusicApp.AdaptiveMusicControl"
    ]
    private var triggerBackgroundTask: UIBackgroundTaskIdentifier = .invalid
    private var directPlaybackAttemptID: UUID?

    func runFullAttempt() {
        guard !isRunning else { return }
        isRunning = true
        events.removeAll()

        beginTriggerBackgroundTask()
        append(.info, "Starting private trigger attempt.")
        probeAdaptiveMusicFramework()
        launchAmbientMusicApp()
        sendMediaRemotePlayCommand()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.sendMediaRemotePlayCommand()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.queryNowPlayingState(context: "auto trigger")
            self.isRunning = false
            self.endTriggerBackgroundTask()
        }
    }

    func probeAdaptiveMusicFramework() {
        guard let handle = dlopen(adaptiveMusicPath, RTLD_NOW) else {
            append(.failure, "AdaptiveMusic dlopen failed: \(String(cString: dlerror()))")
            return
        }

        append(.success, "Loaded AdaptiveMusic private framework.")

        let symbols = [
            "_$s13AdaptiveMusic06ToggleB6IntentV7performQryYaKF": "ToggleMusicIntent.perform",
            "_$s13AdaptiveMusic06ToggleB6IntentV14openAppWhenRunSbvgZ": "ToggleMusicIntent.openAppWhenRun",
            "_$s13AdaptiveMusic6PlayerC4play5mediayAA5MediaV_tYaKF": "Player.play(media:)",
            "_$s13AdaptiveMusic22SuggestedPlaylistQueryV11fromLibraryAA4MoodV0D0VvgZ": "SuggestedPlaylistQuery.fromLibrary",
            "_$s13AdaptiveMusic5MediaV8playlistAcA4MoodV8PlaylistV_tcfC": "Media.init(playlist: Mood.Playlist)",
            "_$s13AdaptiveMusic06ToggleB6IntentV5value8playlist6playerACSb_AA4MoodV8PlaylistVSgAA6PlayerCtcfC": "ToggleMusicIntent.init(value:playlist:player:)"
        ]

        for (symbol, label) in symbols {
            if resolveSymbol(symbol, in: handle) != nil {
                append(.success, "Resolved \(label).")
            } else {
                append(.warning, "Could not resolve \(label).")
            }
        }
    }

    func probePlaybackConstructionPath() {
        guard let handle = dlopen(adaptiveMusicPath, RTLD_NOW) else {
            append(.failure, "AdaptiveMusic dlopen failed: \(String(cString: dlerror()))")
            return
        }

        let playbackSymbols = [
            "_$s13AdaptiveMusic22SuggestedPlaylistQueryV11fromLibraryAA4MoodV0D0VvgZ": "SuggestedPlaylistQuery.fromLibrary -> Mood.Playlist",
            "_$s13AdaptiveMusic7LibraryC17validatedPlaylist9forMoodID08selectedE0AA0G0V0E0VSgAH0H0O_AKtYaF": "Library.validatedPlaylist(forMoodID:selectedPlaylist:) async -> Mood.Playlist?",
            "_$s13AdaptiveMusic5MediaV8playlistAcA4MoodV8PlaylistV_tcfC": "Media.init(playlist: Mood.Playlist)",
            "_$s13AdaptiveMusic6PlayerC4play5mediayAA5MediaV_tYaKF": "Player.play(media:) async throws",
            "_$s13AdaptiveMusic6PlayerC4play5mediayAA5MediaV_tYaKFTu": "Player.play(media:) async function pointer record",
            "_$s13AdaptiveMusic06ToggleB6IntentV5value8playlist6playerACSb_AA4MoodV8PlaylistVSgAA6PlayerCtcfC": "ToggleMusicIntent.init(value:playlist:player:)",
            "_$s13AdaptiveMusic06ToggleB6IntentV7performQryYaKF": "ToggleMusicIntent.perform() async throws"
        ]

        var resolvedCount = 0
        for (symbol, label) in playbackSymbols {
            if resolveSymbol(symbol, in: handle) != nil {
                resolvedCount += 1
                append(.success, "Resolved playback path: \(label).")
            } else {
                append(.warning, "Missing playback path symbol: \(label).")
            }
        }

        if resolvedCount == playbackSymbols.count {
            append(
                .info,
                "Playback symbols are present, but this probe does not call them. The remaining gap is safely constructing Apple's private Mood.Playlist/Media Swift values and invoking async Player.play(media:)."
            )
        } else {
            append(.warning, "Playback construction path is incomplete on this OS build.")
        }
    }

    func attemptDirectPrivatePlayback() {
        guard !isRunning else { return }
        isRunning = true
        let attemptID = UUID()
        directPlaybackAttemptID = attemptID
        append(.info, "Starting unsafe direct AdaptiveMusic playback attempt.")

        let adaptiveMusicPath = adaptiveMusicPath
        let attemptState = DirectPlaybackAttemptState()
        Task.detached(priority: .userInitiated) { [weak self, adaptiveMusicPath, attemptID, attemptState] in
            do {
                try await AmbientMusicDirectPrivatePlayback.call(
                    adaptiveMusicPath: adaptiveMusicPath
                ) { [weak self] kind, message in
                    await self?.appendFromDetachedTask(kind, message)
                }

                guard attemptState.finish() else {
                    AmbientMusicDirectPrivatePlayback.logLateResult()
                    return
                }
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    guard self.directPlaybackAttemptID == attemptID else {
                        self.append(.info, "Direct Player.play(media:) returned after the timeout window; ignoring late result.")
                        return
                    }
                    self.append(.success, "Direct Player.play(media:) returned without throwing.")
                    self.completeDirectPrivatePlaybackAttempt(
                        attemptID,
                        context: "direct private playback"
                    )
                }
            } catch {
                guard attemptState.finish() else {
                    AmbientMusicDirectPrivatePlayback.logLateError(error)
                    return
                }
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    guard self.directPlaybackAttemptID == attemptID else {
                        self.append(.info, "Direct Player.play(media:) failed after the timeout window; ignoring late error.")
                        return
                    }
                    self.append(.failure, "Direct private playback failed: \(error.localizedDescription)")
                    self.completeDirectPrivatePlaybackAttempt(
                        attemptID,
                        context: "direct private playback"
                    )
                }
            }
        }

        let timeoutSeconds = Double(directPlaybackTimeoutNanoseconds) / 1_000_000_000
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + timeoutSeconds) { [weak self, attemptID, attemptState] in
            guard attemptState.finish() else { return }

            AmbientMusicDirectPrivatePlayback.logWatchdogTimeout()
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                guard self.directPlaybackAttemptID == attemptID else { return }
                self.append(
                    .warning,
                    "Direct Player.play(media:) did not return within 5 seconds; this usually means MediaRemote bless/entitlement blocked the private playback path."
                )
                self.completeDirectPrivatePlaybackAttempt(
                    attemptID,
                    context: "direct private playback timeout"
                )
            }
        }
    }

    private func completeDirectPrivatePlaybackAttempt(
        _ attemptID: UUID,
        context: String
    ) {
        guard directPlaybackAttemptID == attemptID else { return }
        directPlaybackAttemptID = nil

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.queryNowPlayingState(context: context)
            self.isRunning = false
        }
    }

    func probeDirectAdaptiveMusicPlayer(callPause: Bool = false) {
        guard let handle = dlopen(adaptiveMusicPath, RTLD_NOW) else {
            append(.failure, "AdaptiveMusic dlopen failed: \(String(cString: dlerror()))")
            return
        }

        let sharedSymbolName = "_$s13AdaptiveMusic6PlayerC6sharedACvgZ"
        guard let sharedSymbol = resolveSymbol(sharedSymbolName, in: handle) else {
            append(.failure, "Could not resolve Player.shared getter.")
            return
        }

        typealias PlayerSharedGetter = @convention(thin) () -> AnyObject
        let getSharedPlayer = unsafeBitCast(sharedSymbol, to: PlayerSharedGetter.self)
        let player = getSharedPlayer()
        append(.success, "Direct Swift ABI call returned Player.shared: \(player).")

        let librarySymbolName = "_$s13AdaptiveMusic7LibraryC6sharedACvgZ"
        if let librarySymbol = resolveSymbol(librarySymbolName, in: handle) {
            typealias LibrarySharedGetter = @convention(thin) () -> AnyObject
            let getSharedLibrary = unsafeBitCast(librarySymbol, to: LibrarySharedGetter.self)
            let library = getSharedLibrary()
            append(.success, "Direct Swift ABI call returned Library.shared: \(library).")
        } else {
            append(.warning, "Could not resolve Library.shared getter.")
        }

        guard callPause else {
            append(.info, "Skipped Player.pause(); direct pause crashed on iOS 26.4 simulator.")
            return
        }

        let pauseSymbolName = "_$s13AdaptiveMusic6PlayerC5pauseyyF"
        guard let pauseSymbol = resolveSymbol(pauseSymbolName, in: handle) else {
            append(.failure, "Could not resolve Player.pause().")
            return
        }

        typealias PlayerPause = @convention(thin) (AnyObject) -> Void
        let pause = unsafeBitCast(pauseSymbol, to: PlayerPause.self)
        pause(player)
        append(.success, "Direct Swift ABI call completed Player.pause().")
    }

    private func resolveSymbol(
        _ symbol: String,
        in handle: UnsafeMutableRawPointer
    ) -> UnsafeMutableRawPointer? {
        if let resolved = dlsym(handle, symbol) {
            return resolved
        }
        if symbol.hasPrefix("_") {
            return dlsym(handle, String(symbol.dropFirst()))
        }
        return dlsym(handle, "_" + symbol)
    }

    func analyzeIntentSurface() {
        do {
            let surface = try AmbientMusicIntentSurfaceAnalyzer.analyze()
            intentSurface = surface
            append(.success, "Loaded AdaptiveMusic AppIntents metadata.")
            append(.info, "Found \(surface.actions.count) intents, \(surface.moods.count) mood ids, \(surface.queries.count) query providers.")
            if surface.autoShortcutCount == 0 {
                append(.warning, "No App Shortcuts exported for Shortcuts/Siri discovery.")
            }
        } catch {
            append(.failure, "Intent metadata probe failed: \(error.localizedDescription)")
        }
    }

    func launchAmbientMusicApp() {
        guard let workspace = defaultApplicationWorkspace() else { return }
        guard let objcSend = dlsym(dlopen(nil, RTLD_NOW), "objc_msgSend") else {
            append(.failure, "Could not resolve objc_msgSend.")
            return
        }

        let selectors = [
            "openApplicationWithBundleID:",
            "openApplicationWithBundleIdentifier:"
        ]

        for selectorName in selectors {
            let selector = NSSelectorFromString(selectorName)
            guard workspace.responds(to: selector) else { continue }

            typealias MessageSendOpen = @convention(c) (AnyObject, Selector, NSString) -> ObjCBool
            let open = unsafeBitCast(objcSend, to: MessageSendOpen.self)
            let opened = open(workspace, selector, ambientBundleID as NSString).boolValue

            if opened {
                append(.success, "Requested launch for \(ambientBundleID) using \(selectorName).")
            } else {
                append(.warning, "Launch request returned false for \(ambientBundleID).")
            }
            return
        }

        append(.failure, "No known LSApplicationWorkspace open selector is available.")
    }

    func launchAmbientMusicUserActivity(moodID: String) {
        beginTriggerBackgroundTask()

        guard let workspace = defaultApplicationWorkspace() else {
            endTriggerBackgroundTask()
            return
        }
        probeUserActivityTypes(on: workspace)
        guard let proxy = applicationProxy(for: ambientBundleID) else {
            append(.failure, "Could not resolve LSApplicationProxy for \(ambientBundleID).")
            endTriggerBackgroundTask()
            return
        }
        guard let objcSend = dlsym(dlopen(nil, RTLD_NOW), "objc_msgSend") else {
            append(.failure, "Could not resolve objc_msgSend.")
            endTriggerBackgroundTask()
            return
        }

        let activityType = ambientUserActivityTypes[0]
        let activity = NSUserActivity(activityType: activityType)
        activity.title = "Ambient Music \(moodID)"
        activity.targetContentIdentifier = moodID
        activity.isEligibleForHandoff = false
        activity.isEligibleForSearch = false
        activity.userInfo = [
            "moodID": moodID,
            "_moodID": moodID,
            "selectedMoodID": moodID,
            "bundleIdentifier": ambientBundleID
        ]
        activity.becomeCurrent()

        let selector = NSSelectorFromString("openUserActivity:withApplicationProxy:completionHandler:")
        guard workspace.responds(to: selector) else {
            append(.failure, "LSApplicationWorkspace openUserActivity selector is unavailable.")
            activity.invalidate()
            endTriggerBackgroundTask()
            return
        }

        typealias Completion = @convention(block) (Bool, NSError?) -> Void
        let completion: Completion = { [weak self, weak activity] success, error in
            DispatchQueue.main.async { [weak self, weak activity] in
                if success {
                    self?.append(.success, "Opened Ambient Music user activity for mood \(moodID).")
                } else if let error {
                    self?.append(
                        .failure,
                        "User activity open failed: \(error.domain) \(error.code) \(error.localizedDescription) \(error.userInfo)"
                    )
                } else {
                    self?.append(.warning, "User activity open returned false for mood \(moodID).")
                }
                activity?.invalidate()
            }
        }

        typealias MessageSendOpenActivity = @convention(c) (
            AnyObject,
            Selector,
            NSUserActivity,
            AnyObject,
            Completion
        ) -> Void
        let openActivity = unsafeBitCast(objcSend, to: MessageSendOpenActivity.self)
        append(.info, "Opening Ambient Music user activity \(activityType) for mood \(moodID).")
        openActivity(workspace, selector, activity, proxy, completion)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.queryNowPlayingState(context: "user activity \(moodID)")
            self.endTriggerBackgroundTask()
        }
    }

    private func defaultApplicationWorkspace() -> AnyObject? {
        guard let rawWorkspaceClass = objc_getClass("LSApplicationWorkspace") else {
            append(.failure, "LSApplicationWorkspace is unavailable.")
            return nil
        }

        let defaultWorkspace = NSSelectorFromString("defaultWorkspace")
        guard let workspaceClass = rawWorkspaceClass as? NSObjectProtocol,
              workspaceClass.responds(to: defaultWorkspace) else {
            append(.failure, "LSApplicationWorkspace.defaultWorkspace is unavailable.")
            return nil
        }

        guard let workspace = workspaceClass.perform(defaultWorkspace)?.takeUnretainedValue() else {
            append(.failure, "Could not create LSApplicationWorkspace.")
            return nil
        }

        return workspace
    }

    private func applicationProxy(for bundleID: String) -> AnyObject? {
        guard let rawProxyClass = objc_getClass("LSApplicationProxy") else {
            append(.failure, "LSApplicationProxy is unavailable.")
            return nil
        }

        let selector = NSSelectorFromString("applicationProxyForIdentifier:")
        guard let proxyClass = rawProxyClass as? NSObjectProtocol,
              proxyClass.responds(to: selector) else {
            append(.failure, "LSApplicationProxy.applicationProxyForIdentifier is unavailable.")
            return nil
        }

        return proxyClass.perform(selector, with: bundleID as NSString)?.takeUnretainedValue()
    }

    private func probeUserActivityTypes(on workspace: AnyObject) {
        guard let objcSend = dlsym(dlopen(nil, RTLD_NOW), "objc_msgSend") else {
            append(.failure, "Could not resolve objc_msgSend for user activity type probe.")
            return
        }

        let selector = NSSelectorFromString("applicationsForUserActivityType:")
        guard workspace.responds(to: selector) else {
            append(.warning, "applicationsForUserActivityType is unavailable.")
            return
        }

        typealias MessageSendApplications = @convention(c) (AnyObject, Selector, NSString) -> NSArray?
        let applicationsForType = unsafeBitCast(objcSend, to: MessageSendApplications.self)
        for activityType in ambientUserActivityTypes {
            let applications = applicationsForType(workspace, selector, activityType as NSString)
            append(.info, "User activity type \(activityType) applications: \(applications?.count ?? 0).")
        }
    }

    func sendMediaRemotePlayCommand() {
        guard let handle = loadMediaRemoteFramework() else { return }

        if dlsym(handle, "MRMediaRemoteSendCommandToApp") != nil {
            append(.warning, "MRMediaRemoteSendCommandToApp exists, but direct call is skipped because its private ABI is unstable.")
        } else {
            append(.warning, "MRMediaRemoteSendCommandToApp is unavailable.")
        }

        if let symbol = dlsym(handle, "MRMediaRemoteSendCommandWithReply") {
            typealias SendCommandWithReply = @convention(c) (
                Int32,
                CFDictionary?,
                DispatchQueue,
                @escaping @convention(block) (Int32) -> Void
            ) -> Void
            let sendCommandWithReply = unsafeBitCast(symbol, to: SendCommandWithReply.self)
            sendCommandWithReply(0, nil, .main) { [weak self] status in
                DispatchQueue.main.async {
                    if status == 0 {
                        self?.append(.success, "MediaRemote play command reply status: success.")
                    } else {
                        self?.append(.warning, "MediaRemote play command reply status: \(status).")
                    }
                }
            }
            append(.info, "Sent global MediaRemote play command with reply.")
            return
        }

        guard let globalSymbol = dlsym(handle, "MRMediaRemoteSendCommand") else {
            append(.failure, "MRMediaRemoteSendCommand is unavailable.")
            return
        }

        typealias SendCommand = @convention(c) (Int32, CFDictionary?) -> Void
        let sendCommand = unsafeBitCast(globalSymbol, to: SendCommand.self)
        sendCommand(0, nil)
        append(.info, "Sent global MediaRemote play command without reply.")
    }

    func queryNowPlayingState(context: String = "manual check") {
        guard let handle = loadMediaRemoteFramework() else { return }

        append(.info, "Querying MediaRemote Now Playing state for \(context).")
        queryNowPlayingDisplayID(handle)
        queryNowPlayingDisplayName(handle)
        queryNowPlayingIsPlaying(handle)
        queryNowPlayingPlaybackState(handle)
    }

    private func loadMediaRemoteFramework() -> UnsafeMutableRawPointer? {
        guard let handle = dlopen(mediaRemotePath, RTLD_NOW) else {
            append(.failure, "MediaRemote dlopen failed: \(String(cString: dlerror()))")
            return nil
        }

        append(.success, "Loaded MediaRemote private framework.")
        return handle
    }

    private func queryNowPlayingDisplayID(_ handle: UnsafeMutableRawPointer) {
        guard let symbol = dlsym(handle, "MRMediaRemoteGetNowPlayingApplicationDisplayID") else {
            append(.warning, "MRMediaRemoteGetNowPlayingApplicationDisplayID is unavailable.")
            return
        }

        typealias GetDisplayID = @convention(c) (
            DispatchQueue,
            @escaping @convention(block) (CFString?) -> Void
        ) -> Void
        let getDisplayID = unsafeBitCast(symbol, to: GetDisplayID.self)
        let targetBundleID = ambientBundleID
        getDisplayID(.main) { [weak self, targetBundleID] displayID in
            let value = (displayID as String?) ?? "nil"
            DispatchQueue.main.async { [weak self] in
                if value == targetBundleID {
                    self?.append(.success, "Now Playing app display id: \(value).")
                } else {
                    self?.append(.warning, "Now Playing app display id: \(value).")
                }
            }
        }
    }

    private func queryNowPlayingDisplayName(_ handle: UnsafeMutableRawPointer) {
        guard let symbol = dlsym(handle, "MRMediaRemoteGetNowPlayingApplicationDisplayName") else {
            append(.warning, "MRMediaRemoteGetNowPlayingApplicationDisplayName is unavailable.")
            return
        }

        typealias GetDisplayName = @convention(c) (
            DispatchQueue,
            @escaping @convention(block) (CFString?) -> Void
        ) -> Void
        let getDisplayName = unsafeBitCast(symbol, to: GetDisplayName.self)
        getDisplayName(.main) { [weak self] displayName in
            let value = (displayName as String?) ?? "nil"
            DispatchQueue.main.async { [weak self] in
                self?.append(.info, "Now Playing app name: \(value).")
            }
        }
    }

    private func queryNowPlayingIsPlaying(_ handle: UnsafeMutableRawPointer) {
        guard let symbol = dlsym(handle, "MRMediaRemoteGetNowPlayingApplicationIsPlaying") else {
            append(.warning, "MRMediaRemoteGetNowPlayingApplicationIsPlaying is unavailable.")
            return
        }

        typealias GetIsPlaying = @convention(c) (
            DispatchQueue,
            @escaping @convention(block) (DarwinBoolean) -> Void
        ) -> Void
        let getIsPlaying = unsafeBitCast(symbol, to: GetIsPlaying.self)
        getIsPlaying(.main) { [weak self] isPlaying in
            DispatchQueue.main.async {
                if isPlaying.boolValue {
                    self?.append(.success, "Now Playing reports isPlaying = true.")
                } else {
                    self?.append(.warning, "Now Playing reports isPlaying = false.")
                }
            }
        }
    }

    private func queryNowPlayingPlaybackState(_ handle: UnsafeMutableRawPointer) {
        guard let symbol = dlsym(handle, "MRMediaRemoteGetNowPlayingApplicationPlaybackState") else {
            append(.warning, "MRMediaRemoteGetNowPlayingApplicationPlaybackState is unavailable.")
            return
        }

        typealias GetPlaybackState = @convention(c) (
            DispatchQueue,
            @escaping @convention(block) (Int32) -> Void
        ) -> Void
        let getPlaybackState = unsafeBitCast(symbol, to: GetPlaybackState.self)
        getPlaybackState(.main) { [weak self] playbackState in
            DispatchQueue.main.async {
                self?.append(.info, "Now Playing playback state raw value: \(playbackState).")
            }
        }
    }

    private func append(_ kind: TriggerEvent.Kind, _ message: String) {
        print("[\(kind.rawValue)] \(message)")
        eventLogger.notice("[\(kind.rawValue, privacy: .public)] \(message, privacy: .public)")
        events.append(TriggerEvent(kind: kind, message: message))
    }

    private func appendFromDetachedTask(_ kind: TriggerEvent.Kind, _ message: String) {
        append(kind, message)
    }

    private func beginTriggerBackgroundTask() {
        guard triggerBackgroundTask == .invalid else { return }

        triggerBackgroundTask = UIApplication.shared.beginBackgroundTask(
            withName: "AmbientMusicPrivateTrigger"
        ) { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.append(.warning, "Trigger background task expired.")
                self?.endTriggerBackgroundTask()
            }
        }
    }

    private func endTriggerBackgroundTask() {
        guard triggerBackgroundTask != .invalid else { return }

        UIApplication.shared.endBackgroundTask(triggerBackgroundTask)
        triggerBackgroundTask = .invalid
    }
}

private enum AmbientMusicDirectPrivatePlayback {
    typealias EventSink = @Sendable (TriggerEvent.Kind, String) async -> Void
    private static let watchdogLogger = Logger(
        subsystem: "com.example.ambientmusicprivate",
        category: "PrivateProbe"
    )

    static func call(
        adaptiveMusicPath: String,
        eventSink: EventSink
    ) async throws {
        guard let handle = dlopen(adaptiveMusicPath, RTLD_NOW) else {
            throw AmbientMusicDirectPlaybackError.frameworkLoadFailed(lastDynamicLoaderError())
        }

        let fromLibrarySymbol = try requireSymbol(
            "_$s13AdaptiveMusic22SuggestedPlaylistQueryV11fromLibraryAA4MoodV0D0VvgZ",
            label: "SuggestedPlaylistQuery.fromLibrary",
            in: handle
        )
        let mediaInitSymbol = try requireSymbol(
            "_$s13AdaptiveMusic5MediaV8playlistAcA4MoodV8PlaylistV_tcfC",
            label: "Media.init(playlist:)",
            in: handle
        )
        let playerSharedSymbol = try requireSymbol(
            "_$s13AdaptiveMusic6PlayerC6sharedACvgZ",
            label: "Player.shared getter",
            in: handle
        )
        let playAsyncRecord = try requireSymbol(
            "_$s13AdaptiveMusic6PlayerC4play5mediayAA5MediaV_tYaKFTu",
            label: "Player.play(media:) async function pointer record",
            in: handle
        )

        typealias FromLibrary = @convention(thin) () -> AdaptiveMusicOpaquePlaylist
        typealias MediaFromPlaylist = @convention(thin) (
            AdaptiveMusicOpaquePlaylist
        ) -> AdaptiveMusicOpaqueMedia
        typealias PlayerSharedGetter = @convention(thin) () -> AnyObject
        typealias PlayerPlay = @convention(thin) (
            AdaptiveMusicOpaqueMedia,
            AnyObject
        ) async throws -> Void

        let fromLibrary = unsafeBitCast(fromLibrarySymbol, to: FromLibrary.self)
        let makeMedia = unsafeBitCast(mediaInitSymbol, to: MediaFromPlaylist.self)
        let getSharedPlayer = unsafeBitCast(playerSharedSymbol, to: PlayerSharedGetter.self)
        let play = unsafeBitCast(playAsyncRecord, to: PlayerPlay.self)

        let playlist = fromLibrary()
        await eventSink(
            .success,
            "Constructed default Mood.Playlist via SuggestedPlaylistQuery.fromLibrary."
        )

        let media = makeMedia(playlist)
        await eventSink(.success, "Constructed AdaptiveMusic.Media from private playlist.")

        let player = getSharedPlayer()
        await eventSink(.success, "Resolved Player.shared: \(player).")
        await eventSink(.info, "Calling Player.play(media:) through its async function pointer record.")
        await eventSink(
            .warning,
            "If no later event appears and OSLog shows 'MPCMediaRemotePublisher failed to bless application', the private call reached Apple's playback path but is blocked by MediaRemote bless/entitlement."
        )

        try await play(media, player)
    }

    static func logWatchdogTimeout() {
        let message = "Direct Player.play(media:) watchdog fired after 5 seconds; MediaRemote bless/entitlement likely blocked the private playback path. On some OS builds the private call can stop in-process scheduling before this watchdog runs."
        print("[Warn] \(message)")
        watchdogLogger.warning("\(message, privacy: .public)")
    }

    static func logLateResult() {
        let message = "Direct Player.play(media:) returned after watchdog completion; ignoring late result."
        print("[Info] \(message)")
        watchdogLogger.info("\(message, privacy: .public)")
    }

    static func logLateError(_ error: Error) {
        let message = "Direct Player.play(media:) failed after watchdog completion; ignoring late error: \(error.localizedDescription)"
        print("[Info] \(message)")
        watchdogLogger.info("\(message, privacy: .public)")
    }

    private static func requireSymbol(
        _ symbol: String,
        label: String,
        in handle: UnsafeMutableRawPointer
    ) throws -> UnsafeMutableRawPointer {
        guard let resolved = resolveSymbol(symbol, in: handle) else {
            throw AmbientMusicDirectPlaybackError.missingSymbol(label)
        }
        return resolved
    }

    private static func resolveSymbol(
        _ symbol: String,
        in handle: UnsafeMutableRawPointer
    ) -> UnsafeMutableRawPointer? {
        if let resolved = dlsym(handle, symbol) {
            return resolved
        }
        if symbol.hasPrefix("_") {
            return dlsym(handle, String(symbol.dropFirst()))
        }
        return dlsym(handle, "_" + symbol)
    }

    private static func lastDynamicLoaderError() -> String {
        guard let error = dlerror() else { return "unknown error" }
        return String(cString: error)
    }
}

private final class DirectPlaybackAttemptState: @unchecked Sendable {
    private let lock = NSLock()
    private var isFinished = false

    func finish() -> Bool {
        lock.lock()
        defer { lock.unlock() }

        guard !isFinished else { return false }
        isFinished = true
        return true
    }
}

private enum AmbientMusicDirectPlaybackError: LocalizedError {
    case frameworkLoadFailed(String)
    case missingSymbol(String)

    var errorDescription: String? {
        switch self {
        case .frameworkLoadFailed(let message):
            "AdaptiveMusic dlopen failed: \(message)"
        case .missingSymbol(let label):
            "Could not resolve \(label)."
        }
    }
}

private struct AdaptiveMusicOpaquePlaylist {
    var word0: UInt64 = 0
    var word1: UInt64 = 0
    var word2: UInt64 = 0
    var word3: UInt64 = 0
    var word4: UInt64 = 0
    var word5: UInt64 = 0
    var word6: UInt64 = 0
    var word7: UInt64 = 0
}

private struct AdaptiveMusicOpaqueMedia {
    var word0: UInt64 = 0
    var word1: UInt64 = 0
    var word2: UInt64 = 0
    var word3: UInt64 = 0
    var word4: UInt64 = 0
    var word5: UInt64 = 0
    var word6: UInt64 = 0
    var word7: UInt64 = 0
    var word8: UInt64 = 0
    var word9: UInt64 = 0
    var word10: UInt64 = 0
}

struct TriggerEvent: Identifiable, Equatable {
    enum Kind: String {
        case info = "Info"
        case success = "OK"
        case warning = "Warn"
        case failure = "Fail"
    }

    let id = UUID()
    let kind: Kind
    let message: String
}
