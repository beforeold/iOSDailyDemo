# AmbientMusicPrivate Context

This demo is isolated from other demos. It is a private API research demo for
probing iOS Ambient Music internals, not an App Store-safe implementation.

Agents may edit only files under this directory unless explicitly instructed.

## What It Attempts

- Load private frameworks `AdaptiveMusic` and `MediaRemote` at runtime with
  `dlopen`/`dlsym`, avoiding build-time linkage so the same source can compile
  for simulator and device.
- Resolve `AdaptiveMusic.ToggleMusicIntent` symbols at runtime.
- Launch the hidden system app `com.apple.AdaptiveMusicApp` through private
  LaunchServices APIs. Avoid `unsafeBitCast` on Objective-C class objects; use
  `NSObjectProtocol.perform(_:)` for `defaultWorkspace`.
- Send a private global MediaRemote play command after the hidden Ambient Music
  app is launched.
- Query MediaRemote Now Playing state after the command so device runs can
  distinguish "UI launched" from "Ambient Music became the active playing app".
- Hold a short public `UIApplication` background task during the trigger
  window. On device, launching the hidden system app backgrounds this demo, so
  delayed MediaRemote commands may otherwise be suspended before they run.
- Inspect the `AdaptiveMusic.framework` App Intents metadata surface and show
  the extracted mood/action shape in the app. If the metadata file is not
  readable from the app process, the UI falls back to the iOS 26.4 signature
  extracted from the local simulator runtime.
- Probe the private playback construction path symbols and, only behind the
  explicit `Unsafe Direct Play` control, attempt the private
  `SuggestedPlaylistQuery.fromLibrary -> Media.init(playlist:) ->
  Player.play(media:)` chain.

## App Intents Findings

The Ambient Music implementation does contain App Intents metadata, but it does
not expose a third-party discoverable App Shortcut. The observed surface is:

- Mood ids: `productivity`, `chill`, `sleep`, `wellbeing`, and internal
  `custom`.
- Configuration intents:
  `SelectProductivityPlaylistIntent`, `SelectChillPlaylistIntent`,
  `SelectSleepPlaylistIntent`, `SelectWellbeingPlaylistIntent`,
  `SingleMoodWidgetConfigurationIntent`, and
  `MultipleMoodsWidgetConfigurationIntent`.
- Playback intent: `ToggleMusicIntent`.
- Entity/query dependency: `ToggleMusicIntent` accepts `value: Bool` plus an
  optional internal `Playlist`; playlist suggestions appear to come from
  `SuggestedPlaylistQuery`.
- App Shortcuts count: `0`.

The practical consequence is that the four public scenes have configuration
intents, not standalone play intents. `ToggleMusicIntent` is the closest play
entry, but direct per-scene playback requires constructing or resolving Apple's
private `Playlist` entity. Without that entity and related Apple-only
entitlements, Shortcuts/Siri cannot trigger these intents from a third-party
app.

## Playback Path Findings

The system framework does contain the pieces that Apple likely uses to start
playback:

- `SuggestedPlaylistQuery.fromLibrary -> Mood.Playlist`
- `Library.validatedPlaylist(forMoodID:selectedPlaylist:) async -> Mood.Playlist?`
- `Media.init(playlist: Mood.Playlist)`
- `Player.play(media:) async throws`
- `Player.play(media:) async function pointer record`
- `ToggleMusicIntent.init(value:playlist:player:)`
- `ToggleMusicIntent.perform() async throws`

The demo resolves these symbols with `dlsym` through the `Probe Playback Path`
button or `--playback-path-probe`. The explicit `Unsafe Direct Play` button, or
`--unsafe-direct-play`, goes further: it constructs opaque Swift ABI value
buffers for `Mood.Playlist` (64 bytes) and `Media` (88 bytes), resolves
`Player.shared`, and invokes `Player.play(media:)` through the async function
pointer record symbol (`...KFTu`).

On the iOS 26.4 simulator this direct chain no longer crashes and reaches
AdaptiveMusic core, but OSLog shows `MPCMediaRemotePublisher failed to bless
application`. The async `Player.play(media:)` call may then stop making forward
progress and can also prevent later in-process timers/watchdogs from running.
Treat the combination of the pre-call demo log plus the AdaptiveMusic bless
failure as the diagnostic: the private playback path was reached, but the system
refused to bless this third-party app as the media publisher. A direct
`Player.shared` and `Library.shared` getter call succeeds, but an unsafe direct
`Player.pause()` call crashed on the iOS 26.4 simulator, so other unmapped Swift
ABI calls must remain behind explicit unsafe probes.

Launching a spoofed `NSUserActivity` for the widget route is also blocked by
FrontBoard/LaunchServices with `Request is not trusted`. The hidden app appears
to accept trusted widget/user-activity launches, but a third-party app cannot
mint that trusted activity directly.

Do not directly call `MRMediaRemoteSendCommandToApp` unless its current ABI is
confirmed. On iOS 26.4 simulator it exists but crashed inside MediaRemote when
called with the previously guessed signature.

For reproducible simulator debugging, launch with:

```sh
xcrun simctl launch <simulator-id> com.example.ambientmusicprivate --auto-trigger
xcrun simctl launch <simulator-id> com.example.ambientmusicprivate --playback-path-probe
xcrun simctl launch <simulator-id> com.example.ambientmusicprivate --unsafe-direct-play
xcrun simctl launch <simulator-id> com.example.ambientmusicprivate --direct-player-probe
xcrun simctl launch <simulator-id> com.example.ambientmusicprivate --user-activity sleep
```

The `--auto-trigger` path should launch the hidden Ambient Music system UI and
send the global MediaRemote play command immediately and once again after a
short delay. It intentionally does not call `MRMediaRemoteSendCommandToApp`,
because that private ABI crashed on the iOS 26.4 simulator with the previously
guessed signature.

If the system UI appears but no sound starts, check the event log after
`Verify Now Playing`, `--auto-trigger`, or `--unsafe-direct-play`. A `nil` /
non-Ambient display id or `isPlaying = false` means the global play command did
not create or resume an Ambient Music playback queue. If `--unsafe-direct-play`
logs the `Player.play(media:)` call and OSLog contains `MPCMediaRemotePublisher
failed to bless application`, the private playback path was reached but the
system refused to bless this third-party app as the media publisher. The demo
may not produce further logs after that point because the private call can stall
the app's own scheduling. This is expected without Apple-only MediaRemote
entitlements; it is not the same as a successful scene playback trigger.

The real system implementation depends on Apple-only entitlements such as
`com.apple.private.applemediaservices` and `com.apple.mediaremote.request-bless`,
so this demo may compile yet still fail to trigger playback on a simulator or
device.

Build command:

```sh
xcodegen generate --spec project.yml
xcodebuild -project AmbientMusicPrivate.xcodeproj -scheme AmbientMusicPrivate -destination 'generic/platform=iOS Simulator' build
```

The Ambient Music system app appears on iOS 26.4 and later. On older OS
versions the private framework or hidden app may not exist, and the demo will
report runtime failures in the event log.
