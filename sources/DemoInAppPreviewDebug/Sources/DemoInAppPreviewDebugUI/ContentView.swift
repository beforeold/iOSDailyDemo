import OSLog
import SwiftUI

public struct ContentView: View {
    private static let logger = Logger(
        subsystem: "com.example.demoinapppreviewdebug",
        category: "InAppPreview"
    )

    @State private var selectedMode = PreviewMode.preview
    @State private var logEntries: [DebugEvent] = [
        DebugEvent(kind: .info, title: "App launched", detail: "Waiting for simulator inspection")
    ]
    @State private var runCount = 0
    @State private var showsRecoverableIssue = false
    @State private var birdIsUp = false

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    modePicker
                    statusCard
                    actionCard
                    checklistCard
                    logCard
                }
                .padding(20)
                .frame(maxWidth: 640)
                .frame(maxWidth: .infinity)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "bird.fill")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.blue)
                        .offset(y: birdIsUp ? -4 : 4)
                        .animation(
                            .easeInOut(duration: 0.7).repeatForever(autoreverses: true),
                            value: birdIsUp
                        )
                        .accessibilityHidden(true)
                }

                ToolbarItem(placement: .principal) {
                    Text("Fifth Title Hot Reload")
                        .font(.headline)
                }
            }
        }
        .onAppear {
            Self.logger.info("DemoInAppPreviewDebug appeared")
            birdIsUp = true
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Build iOS Apps Lab", systemImage: "iphone.gen3")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.tint)
                .accessibilityIdentifier("lab-header-label")

            Text("Fifth title hot reload checkpoint")
                .font(.title2.weight(.bold))
                .foregroundStyle(.primary)

            Text("Use this isolated demo to verify simulator mirroring, UI inspection, taps, screenshots, and console log capture.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }

    private var modePicker: some View {
        Picker("Mode", selection: $selectedMode) {
            ForEach(PreviewMode.allCases) { mode in
                Label(mode.title, systemImage: mode.symbol)
                    .tag(mode)
            }
        }
        .pickerStyle(.segmented)
        .accessibilityIdentifier("mode-picker")
    }

    private var statusCard: some View {
        Card {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(selectedMode.title)
                            .font(.headline)
                        Text(selectedMode.subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    StatusPill(
                        title: showsRecoverableIssue ? "Needs review" : "Ready",
                        symbol: showsRecoverableIssue ? "exclamationmark.triangle.fill" : "checkmark.circle.fill",
                        tint: showsRecoverableIssue ? .orange : .teal
                    )
                    .accessibilityIdentifier("status-pill")
                }

                Divider()

                HStack(spacing: 12) {
                    MetricTile(title: "Runs", value: "\(runCount)", symbol: "play.circle")
                    MetricTile(title: "Events", value: "\(logEntries.count)", symbol: "list.bullet.rectangle")
                }
            }
        }
        .accessibilityIdentifier("status-card")
    }

    private var actionCard: some View {
        Card {
            VStack(alignment: .leading, spacing: 16) {
                Text("Debug Actions")
                    .font(.headline)

                Button {
                    runCount += 1
                    showsRecoverableIssue = false
                    appendEvent(kind: .success, title: "UI check passed", detail: "Run \(runCount) completed")
                    Self.logger.info("UI check passed, run \(self.runCount)")
                } label: {
                    Label("Pass UI Check", systemImage: "checkmark.seal.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .accessibilityIdentifier("pass-ui-check-button")

                HStack(spacing: 12) {
                    Button {
                        appendEvent(kind: .info, title: "Debug event recorded", detail: selectedMode.title)
                        Self.logger.debug("Manual debug event in mode \(self.selectedMode.title)")
                    } label: {
                        Label("Record Event", systemImage: "waveform")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    .accessibilityIdentifier("record-event-button")

                    Button {
                        showsRecoverableIssue.toggle()
                        appendEvent(
                            kind: showsRecoverableIssue ? .warning : .success,
                            title: showsRecoverableIssue ? "Recoverable issue shown" : "Issue cleared",
                            detail: showsRecoverableIssue ? "Use screenshots or logs to inspect" : "Back to ready state"
                        )
                        Self.logger.warning("Recoverable issue toggled: \(self.showsRecoverableIssue)")
                    } label: {
                        Label(showsRecoverableIssue ? "Clear Issue" : "Show Issue", systemImage: "ladybug.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    .accessibilityIdentifier("toggle-issue-button")
                }
            }
        }
        .accessibilityIdentifier("action-card")
    }

    private var checklistCard: some View {
        Card {
            VStack(alignment: .leading, spacing: 14) {
                Text("Plugin Test Checklist")
                    .font(.headline)

                ChecklistRow(
                    title: "Preview stream renders the simulator",
                    isComplete: true
                )
                ChecklistRow(
                    title: "UI inspector can find named controls",
                    isComplete: runCount > 0 || logEntries.count > 1
                )
                ChecklistRow(
                    title: "Screenshots capture issue state changes",
                    isComplete: showsRecoverableIssue
                )
                ChecklistRow(
                    title: "Console logs include user actions",
                    isComplete: logEntries.count > 2
                )
            }
        }
        .accessibilityIdentifier("checklist-card")
    }

    private var logCard: some View {
        Card {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Debug Log")
                        .font(.headline)

                    Spacer()

                    Button {
                        logEntries.removeAll()
                        appendEvent(kind: .info, title: "Log reset", detail: "Manual cleanup")
                        Self.logger.info("Debug log reset")
                    } label: {
                        Label("Reset", systemImage: "arrow.clockwise")
                            .labelStyle(.iconOnly)
                    }
                    .buttonStyle(.bordered)
                    .accessibilityLabel("Reset log")
                    .accessibilityIdentifier("reset-log-button")
                }

                ForEach(logEntries.prefix(4)) { event in
                    DebugEventRow(event: event)
                }
            }
        }
        .accessibilityIdentifier("debug-log-card")
    }

    private func appendEvent(kind: DebugEvent.Kind, title: String, detail: String) {
        logEntries.insert(
            DebugEvent(kind: kind, title: title, detail: detail),
            at: 0
        )
    }
}

private enum PreviewMode: String, CaseIterable, Identifiable {
    case preview
    case debug
    case test

    var id: Self { self }

    var title: String {
        switch self {
        case .preview:
            "Preview"
        case .debug:
            "Debugger"
        case .test:
            "Test"
        }
    }

    var subtitle: String {
        switch self {
        case .preview:
            "Confirm the in-app browser mirror is live."
        case .debug:
            "Capture logs and inspect visible UI state."
        case .test:
            "Exercise stable buttons and checklist states."
        }
    }

    var symbol: String {
        switch self {
        case .preview:
            "rectangle.on.rectangle"
        case .debug:
            "stethoscope"
        case .test:
            "checklist"
        }
    }
}

private struct DebugEvent: Identifiable {
    enum Kind {
        case info
        case success
        case warning

        var tint: Color {
            switch self {
            case .info:
                .blue
            case .success:
                .teal
            case .warning:
                .orange
            }
        }

        var symbol: String {
            switch self {
            case .info:
                "info.circle.fill"
            case .success:
                "checkmark.circle.fill"
            case .warning:
                "exclamationmark.triangle.fill"
            }
        }
    }

    let id = UUID()
    let kind: Kind
    let title: String
    let detail: String
}

private struct Card<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            content
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.separator).opacity(0.35), lineWidth: 1)
        }
    }
}

private struct StatusPill: View {
    let title: String
    let symbol: String
    let tint: Color

    var body: some View {
        Label(title, systemImage: symbol)
            .font(.caption.weight(.semibold))
            .foregroundStyle(tint)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(tint.opacity(0.12), in: Capsule())
    }
}

private struct MetricTile: View {
    let title: String
    let value: String
    let symbol: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: symbol)
                .font(.title3)
                .foregroundStyle(.tint)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.title3.weight(.bold))
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 10))
    }
}

private struct ChecklistRow: View {
    let title: String
    let isComplete: Bool

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: isComplete ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(isComplete ? .teal : .secondary)
                .font(.body.weight(.semibold))

            Text(title)
                .font(.subheadline)
                .foregroundStyle(.primary)

            Spacer(minLength: 0)
        }
    }
}

private struct DebugEventRow: View {
    let event: DebugEvent

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: event.kind.symbol)
                .foregroundStyle(event.kind.tint)
                .frame(width: 22)

            VStack(alignment: .leading, spacing: 3) {
                Text(event.title)
                    .font(.subheadline.weight(.semibold))
                Text(event.detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    ContentView()
}
