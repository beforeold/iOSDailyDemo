import SwiftUI

struct ContentView: View {
    @StateObject private var trigger = AmbientMusicPrivateTrigger()
    @State private var didAutoTrigger = false
    @State private var didAnalyzeIntentSurface = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    statusRow(
                        title: "AdaptiveMusic",
                        value: "Private framework",
                        symbol: "music.note.list"
                    )
                    statusRow(
                        title: "Target",
                        value: "com.apple.AdaptiveMusicApp",
                        symbol: "app.badge"
                    )
                    statusRow(
                        title: "MediaRemote",
                        value: "Private play command",
                        symbol: "play.circle"
                    )
                }

                Section {
                    Button {
                        trigger.analyzeIntentSurface()
                    } label: {
                        Label("Analyze Intent Surface", systemImage: "list.bullet.rectangle")
                    }

                    Button {
                        trigger.runFullAttempt()
                    } label: {
                        Label(
                            trigger.isRunning ? "Running" : "Trigger Ambient Music",
                            systemImage: trigger.isRunning ? "hourglass" : "play.fill"
                        )
                    }
                    .disabled(trigger.isRunning)

                    Button {
                        trigger.probeAdaptiveMusicFramework()
                    } label: {
                        Label("Probe Framework", systemImage: "waveform.path.ecg")
                    }

                    Button {
                        trigger.probeDirectAdaptiveMusicPlayer()
                    } label: {
                        Label("Probe Direct Player", systemImage: "dot.scope")
                    }

                    Button {
                        trigger.probePlaybackConstructionPath()
                    } label: {
                        Label("Probe Playback Path", systemImage: "link")
                    }

                    Button(role: .destructive) {
                        trigger.attemptDirectPrivatePlayback()
                    } label: {
                        Label("Unsafe Direct Play", systemImage: "play.circle")
                    }
                    .disabled(trigger.isRunning)

                    Button(role: .destructive) {
                        trigger.probeDirectAdaptiveMusicPlayer(callPause: true)
                    } label: {
                        Label("Unsafe Direct Pause", systemImage: "pause.circle")
                    }

                    Button {
                        trigger.launchAmbientMusicApp()
                    } label: {
                        Label("Launch Hidden App", systemImage: "arrow.up.forward.app")
                    }

                    Button {
                        trigger.sendMediaRemotePlayCommand()
                    } label: {
                        Label("Send Play Command", systemImage: "playpause.fill")
                    }

                    Button {
                        trigger.queryNowPlayingState()
                    } label: {
                        Label("Verify Now Playing", systemImage: "dot.radiowaves.left.and.right")
                    }
                }

                Section("User Activity Launch") {
                    Button {
                        trigger.launchAmbientMusicUserActivity(moodID: "sleep")
                    } label: {
                        Label("Sleep", systemImage: "moon.zzz.fill")
                    }

                    Button {
                        trigger.launchAmbientMusicUserActivity(moodID: "chill")
                    } label: {
                        Label("Chill", systemImage: "sun.haze.fill")
                    }

                    Button {
                        trigger.launchAmbientMusicUserActivity(moodID: "productivity")
                    } label: {
                        Label("Productivity", systemImage: "checkmark.square.fill")
                    }

                    Button {
                        trigger.launchAmbientMusicUserActivity(moodID: "wellbeing")
                    } label: {
                        Label("Wellbeing", systemImage: "heart.fill")
                    }
                }

                if let surface = trigger.intentSurface {
                    Section("Moods") {
                        ForEach(surface.moods) { mood in
                            moodRow(mood)
                        }
                    }

                    Section("Intent Surface") {
                        factRow(
                            title: "App Shortcuts",
                            value: "\(surface.autoShortcutCount)",
                            symbol: surface.autoShortcutCount == 0 ? "xmark.circle" : "checkmark.circle"
                        )
                        factRow(
                            title: "Queries",
                            value: surface.queries.joined(separator: ", "),
                            symbol: "magnifyingglass"
                        )

                        ForEach(surface.actions) { action in
                            actionRow(action)
                        }
                    }

                    Section("Conclusion") {
                        ForEach(surface.notes, id: \.self) { note in
                            Text(note)
                                .font(.callout)
                                .textSelection(.enabled)
                        }
                    }
                }

                Section("Events") {
                    ForEach(trigger.events) { event in
                        HStack(alignment: .firstTextBaseline, spacing: 10) {
                            Text(event.kind.rawValue)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(color(for: event.kind))
                                .frame(width: 42, alignment: .leading)

                            Text(event.message)
                                .font(.callout)
                                .textSelection(.enabled)
                        }
                        .padding(.vertical, 3)
                    }
                }
            }
            .navigationTitle("Ambient Music")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            if !didAnalyzeIntentSurface {
                didAnalyzeIntentSurface = true
                trigger.analyzeIntentSurface()
            }

            let process = ProcessInfo.processInfo
            if let userActivityIndex = process.arguments.firstIndex(of: "--user-activity"),
               process.arguments.indices.contains(userActivityIndex + 1) {
                trigger.launchAmbientMusicUserActivity(
                    moodID: process.arguments[userActivityIndex + 1]
                )
                return
            }

            if process.arguments.contains("--direct-player-probe") {
                trigger.probeDirectAdaptiveMusicPlayer()
                return
            }

            if process.arguments.contains("--playback-path-probe") {
                trigger.probePlaybackConstructionPath()
                return
            }

            if process.arguments.contains("--unsafe-direct-play") {
                trigger.attemptDirectPrivatePlayback()
                return
            }

            if process.arguments.contains("--direct-player-pause") {
                trigger.probeDirectAdaptiveMusicPlayer(callPause: true)
                return
            }

            let shouldAutoTrigger = process.arguments.contains("--auto-trigger")
                || process.environment["AMBIENT_AUTO_TRIGGER"] == "1"
            guard shouldAutoTrigger, !didAutoTrigger else {
                return
            }
            didAutoTrigger = true
            trigger.runFullAttempt()
        }
    }

    private func factRow(title: String, value: String, symbol: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: symbol)
                .font(.title3)
                .foregroundStyle(.tint)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                Text(value.isEmpty ? "None" : value)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .textSelection(.enabled)
            }
        }
        .padding(.vertical, 4)
    }

    private func moodRow(_ mood: AmbientMusicIntentSurface.Mood) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: mood.isPublicScene ? "music.quarternote.3" : "person.crop.circle")
                .font(.title3)
                .foregroundStyle(.tint)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 4) {
                Text(mood.title)
                    .font(.headline)
                Text(mood.id)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .textSelection(.enabled)
                if let configurationIntent = mood.configurationIntent {
                    Text(configurationIntent)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textSelection(.enabled)
                }
            }
        }
        .padding(.vertical, 4)
    }

    private func actionRow(_ action: AmbientMusicIntentSurface.Action) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(action.title)
                        .font(.headline)
                    Text(action.id)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .textSelection(.enabled)
                }

                Spacer()

                if action.id == "ToggleMusicIntent" {
                    Text("playback")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.green)
                } else {
                    Text("config")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.orange)
                }
            }

            ForEach(action.parameters) { parameter in
                HStack(alignment: .firstTextBaseline) {
                    Text(parameter.name)
                        .font(.caption.weight(.semibold))
                        .frame(width: 112, alignment: .leading)
                    Text(parameter.typeDescription + (parameter.isOptional ? "?" : ""))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    if parameter.hasDynamicOptions {
                        Text("dynamic")
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(.blue)
                    }
                }
            }
        }
        .padding(.vertical, 5)
    }

    private func statusRow(title: String, value: String, symbol: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: symbol)
                .font(.title3)
                .foregroundStyle(.tint)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                Text(value)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .textSelection(.enabled)
            }
        }
        .padding(.vertical, 4)
    }

    private func color(for kind: TriggerEvent.Kind) -> Color {
        switch kind {
        case .info:
            .secondary
        case .success:
            .green
        case .warning:
            .orange
        case .failure:
            .red
        }
    }
}
