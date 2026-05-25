import SwiftUI
import UIKit
import UniformTypeIdentifiers

private struct PasteboardSnapshotAlert: Identifiable {
    let id = UUID()
    let source: String
    let changeCount: Int
    let message: String
    let date: Date
}

@MainActor
private final class PasteboardMonitor: ObservableObject {
    @Published var changeCount: Int
    @Published var currentSnapshotAlert: PasteboardSnapshotAlert?
    @Published var lastObservedText = "No changes observed"

    private var baselineChangeCount: Int

    init(pasteboard: UIPasteboard = .general) {
        let currentChangeCount = pasteboard.changeCount
        baselineChangeCount = currentChangeCount
        changeCount = currentChangeCount
    }

    func handlePasteboardChanged(source: String, pasteboard: UIPasteboard = .general) {
        let currentChangeCount = pasteboard.changeCount
        guard currentChangeCount != baselineChangeCount else { return }

        baselineChangeCount = currentChangeCount
        changeCount = currentChangeCount

        presentCurrentPasteboardSnapshot(
            source: source,
            changeCount: currentChangeCount,
            pasteboard: pasteboard
        )
    }

    func refreshBaseline(pasteboard: UIPasteboard = .general) {
        let currentChangeCount = pasteboard.changeCount
        baselineChangeCount = currentChangeCount
        changeCount = currentChangeCount
    }

    func presentCurrentPasteboardSnapshot(
        source: String,
        changeCount: Int? = nil,
        pasteboard: UIPasteboard = .general
    ) {
        let currentChangeCount = changeCount ?? pasteboard.changeCount
        let eventDate = Date()
        currentSnapshotAlert = PasteboardSnapshotAlert(
            source: source,
            changeCount: currentChangeCount,
            message: snapshotMessage(for: pasteboard),
            date: eventDate
        )
        lastObservedText = eventDate.formatted(date: .omitted, time: .standard)
    }

    private func snapshotMessage(for pasteboard: UIPasteboard) -> String {
        """
        String:
        \(stringMessage(for: pasteboard.string))

        File:
        \(fileMessage(for: firstFileURL(in: pasteboard)))
        """
    }

    private func firstFileURL(in pasteboard: UIPasteboard) -> URL? {
        if let fileURL = pasteboard.urls?.first(where: \.isFileURL) {
            return fileURL
        }

        for item in pasteboard.items {
            guard let value = item[UTType.fileURL.identifier] else { continue }

            if let url = value as? URL, url.isFileURL {
                return url
            }

            if let string = value as? String,
               let url = URL(string: string),
               url.isFileURL {
                return url
            }

            if let data = value as? Data,
               let string = String(data: data, encoding: .utf8),
               let url = URL(string: string.trimmingCharacters(in: .whitespacesAndNewlines)),
               url.isFileURL {
                return url
            }
        }

        return nil
    }

    private func fileMessage(for fileURL: URL?) -> String {
        guard let fileURL else {
            return "Current pasteboard has no file URL value."
        }

        let didStartAccessing = fileURL.startAccessingSecurityScopedResource()
        defer {
            if didStartAccessing {
                fileURL.stopAccessingSecurityScopedResource()
            }
        }

        var lines = [
            "Name: \(fileURL.lastPathComponent)",
            "Path: \(fileURL.path)",
        ]

        do {
            let values = try fileURL.resourceValues(forKeys: [
                .fileSizeKey,
                .isDirectoryKey,
                .typeIdentifierKey,
            ])

            if let isDirectory = values.isDirectory {
                lines.append("Kind: \(isDirectory ? "Directory" : "File")")
            }

            if let typeIdentifier = values.typeIdentifier {
                lines.append("Type: \(typeIdentifier)")
            }

            if let fileSize = values.fileSize {
                lines.append(
                    "Size: \(ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file))"
                )
            }
        } catch {
            lines.append("Metadata: unavailable from this app sandbox")
        }

        return lines.joined(separator: "\n")
    }

    private func stringMessage(for string: String?) -> String {
        guard let string else {
            return "Current pasteboard has no string value."
        }

        guard !string.isEmpty else {
            return "Current pasteboard string is empty."
        }

        let maximumAlertLength = 800
        guard string.count > maximumAlertLength else {
            return string
        }

        let preview = String(string.prefix(maximumAlertLength))
        return "\(preview)\n\n... truncated to \(maximumAlertLength) characters"
    }
}

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var monitor = PasteboardMonitor()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    header
                    statusCard
                    controlsCard
                }
                .padding(20)
                .frame(maxWidth: 560, alignment: .leading)
                .frame(maxWidth: .infinity)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("Pasteboard Monitor")
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIPasteboard.changedNotification,
                object: UIPasteboard.general
            )
        ) { _ in
            monitor.handlePasteboardChanged(source: "changedNotification")
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIPasteboard.removedNotification,
                object: UIPasteboard.general
            )
        ) { _ in
            monitor.handlePasteboardChanged(source: "removedNotification")
        }
        .onChange(of: scenePhase) { newPhase in
            guard newPhase == .active else { return }
            monitor.handlePasteboardChanged(source: "scenePhase.active")
        }
        .alert(item: $monitor.currentSnapshotAlert) { alert in
            Alert(
                title: Text("Pasteboard Contents"),
                message: Text(
                    "changeCount: \(alert.changeCount)\nsource: \(alert.source)\n\n\(alert.message)"
                ),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: "doc.on.clipboard")
                .font(.system(size: 34, weight: .semibold))
                .foregroundStyle(.blue)

            Text("UIPasteboard Change Alert")
                .font(.system(.title2, design: .default, weight: .bold))

            Text("Foreground pasteboard changes show the current string and first file URL in an alert.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }

    private var statusCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label("Current change count", systemImage: "number")
                .font(.headline)

            Text("\(monitor.changeCount)")
                .font(.system(size: 44, weight: .bold, design: .rounded))
                .monospacedDigit()

            Divider()

            HStack {
                Label("Last alert", systemImage: "bell.badge")
                    .foregroundStyle(.secondary)
                Spacer(minLength: 16)
                Text(monitor.lastObservedText)
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline)
        }
        .padding(20)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private var controlsCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Observer", systemImage: "eye")
                .font(.headline)

            Text("Notifications: UIPasteboard.changedNotification and UIPasteboard.removedNotification")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Button {
                monitor.refreshBaseline()
            } label: {
                Label("Reset Baseline", systemImage: "arrow.clockwise")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding(20)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
