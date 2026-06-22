import SwiftUI
import UniformTypeIdentifiers

/// Top section — the two file entry points, side by side:
///
/// • **Import**: `.fileImporter` for `.txt` + `.lrc`, then re-verify the picked
///   file's real UTType (identity, not conformance).
/// • **Write**: `.fileExporter` that writes random `.txt` or `.lrc` content to a
///   folder the user chooses in Files. The chosen `contentType` decides the
///   saved file's extension — the same extension/UTType binding the
///   verification sections below prove.
struct FileActionsSection: View {
  /// The three picker entry points — each maps to a different
  /// `allowedContentTypes`. Selecting one before presenting the importer is
  /// what makes the file dialog enable/disable files accordingly.
  enum ImportOption: String, CaseIterable, Identifiable {
    case plainText
    case lrc
    case both

    var id: String { rawValue }

    var title: String {
      switch self {
      case .plainText: return ".plainText only"
      case .lrc: return ".lrc only"
      case .both: return "[.plainText, .lrc]"
      }
    }

    var systemImage: String {
      switch self {
      case .plainText: return "doc.text"
      case .lrc: return "music.note.list"
      case .both: return "doc.on.doc"
      }
    }

    var allowedContentTypes: [UTType] {
      switch self {
      case .plainText: return [.plainText]
      case .lrc: return [.lrc]
      case .both: return [.plainText, .lrc]
      }
    }
  }

  // Import state
  @State private var isImporting = false
  /// Which menu entry triggered the importer that is about to present.
  @State private var activeImport: ImportOption = .both
  @State private var importResult: PickResult?

  // Export state
  @State private var isExporting = false
  @State private var pendingDocument: TextFileDocument?
  @State private var pendingContentType: UTType = .plainText
  @State private var pendingFilename = "sample"
  @State private var exportSeed = 1
  @State private var exportResult: String?

  var body: some View {
    Section {
      importMenu
      writeButtons

      if let importResult {
        Divider()
        importResultView(importResult)
      }
      if let exportResult {
        Label(exportResult, systemImage: "checkmark.seal")
          .font(.caption)
          .foregroundStyle(.green)
      }
    } header: {
      Text("Files · import & write")
    } footer: {
      Text("Import menu offers three allowedContentTypes: .plainText only, .lrc only, or both — try a .txt against the .lrc-only entry to see it disabled. Write saves random content; its contentType sets the extension.")
    }
  }

  // MARK: - Import entry

  /// A menu offering one entry per `ImportOption`. Picking an item sets
  /// `activeImport` (so the importer uses that option's `allowedContentTypes`)
  /// and then presents the file dialog.
  private var importMenu: some View {
    Menu {
      ForEach(ImportOption.allCases) { option in
        Button {
          activeImport = option
          isImporting = true
        } label: {
          Label(option.title, systemImage: option.systemImage)
        }
      }
    } label: {
      Label("Import a file…", systemImage: "square.and.arrow.down")
    }
    .fileImporter(
      isPresented: $isImporting,
      allowedContentTypes: activeImport.allowedContentTypes,
      allowsMultipleSelection: false
    ) { outcome in
      handleImport(outcome)
    }
  }

  // MARK: - Write entries

  private var writeButtons: some View {
    VStack(alignment: .leading, spacing: 8) {
      Button {
        beginExport(contentType: .plainText, ext: "txt",
              text: RandomContent.plainText(seed: exportSeed))
      } label: {
        Label("Write random .txt to Files…", systemImage: "square.and.arrow.up")
      }
      // .borderless makes each Button its own hit target. Without it, two
      // Buttons stacked in a List row merge into one tap area and only one
      // action fires.
      .buttonStyle(.borderless)

      Button {
        beginExport(contentType: .lrc, ext: "lrc",
              text: RandomContent.lrc(seed: exportSeed))
      } label: {
        Label("Write random .lrc to Files…", systemImage: "square.and.arrow.up")
      }
      .buttonStyle(.borderless)
    }
    .fileExporter(
      isPresented: $isExporting,
      document: pendingDocument,
      contentType: pendingContentType,
      defaultFilename: pendingFilename
    ) { outcome in
      handleExport(outcome)
    }
  }

  // MARK: - Import result

  @ViewBuilder
  private func importResultView(_ result: PickResult) -> some View {
    switch result {
    case let .failure(message):
      Label(message, systemImage: "xmark.octagon")
        .font(.caption)
        .foregroundStyle(.red)

    case let .success(file):
      VStack(alignment: .leading, spacing: 6) {
        Text(file.name)
          .font(.subheadline.bold())
          .lineLimit(1)
          .truncationMode(.middle)

        labeledRow("via entry", activeImport.title)
        labeledRow("resolved UTType", file.resolvedIdentifier ?? "unknown")
        labeledRow("extension", file.fileExtension.map { ".\($0)" } ?? "none")

        HStack(spacing: 6) {
          verdictBadge(
            ok: file.matchedType != nil,
            label: file.matchedType.map { "== \($0)" } ?? "no exact match"
          )
          if file.conformsToPlainText {
            verdictBadge(ok: nil, label: "conforms .plainText")
          }
        }
      }
      .padding(.vertical, 2)
    }
  }

  private func labeledRow(_ title: String, _ value: String) -> some View {
    HStack {
      Text(title)
        .font(.caption2)
        .foregroundStyle(.secondary)
      Spacer()
      Text(value)
        .font(.caption.monospaced())
        .foregroundStyle(.tint)
        .lineLimit(1)
        .truncationMode(.middle)
    }
  }

  /// `ok == nil` renders a neutral (orange) informational badge.
  private func verdictBadge(ok: Bool?, label: String) -> some View {
    let color: Color = ok == nil ? .orange : (ok! ? .green : .red)
    return Text(label)
      .font(.caption2.monospaced().bold())
      .padding(.horizontal, 8)
      .padding(.vertical, 2)
      .background(color.opacity(0.18))
      .foregroundStyle(color)
      .clipShape(Capsule())
  }

  // MARK: - Import handling

  private func handleImport(_ outcome: Result<[URL], Error>) {
    switch outcome {
    case let .failure(error):
      importResult = .failure(error.localizedDescription)
    case let .success(urls):
      guard let url = urls.first else {
        importResult = .failure("No file selected")
        return
      }
      importResult = .success(PickedFile(url: url))
    }
  }

  // MARK: - Export handling

  private func beginExport(contentType: UTType, ext: String, text: String) {
    pendingDocument = TextFileDocument(text: text)
    pendingContentType = contentType
    pendingFilename = "demo-\(exportSeed).\(ext)"
    exportResult = nil
    isExporting = true
  }

  private func handleExport(_ outcome: Result<URL, Error>) {
    switch outcome {
    case let .success(url):
      exportResult = "Saved \(url.lastPathComponent)"
      exportSeed += 1 // next write differs
    case let .failure(error):
      // User cancelling the sheet also surfaces here as a CocoaError.
      exportResult = nil
      importResult = .failure(error.localizedDescription)
    }
    pendingDocument = nil
  }

  // MARK: - Models

  private enum PickResult {
    case success(PickedFile)
    case failure(String)
  }

  private struct PickedFile {
    let name: String
    let fileExtension: String?
    /// The file's *real* content type, read from its resource values.
    let resolvedType: UTType?

    init(url: URL) {
      name = url.lastPathComponent
      let ext = url.pathExtension
      fileExtension = ext.isEmpty ? nil : ext
      // Security-scoped access is needed to read attributes of a
      // user-selected file outside the app sandbox.
      let didStart = url.startAccessingSecurityScopedResource()
      defer { if didStart { url.stopAccessingSecurityScopedResource() } }
      resolvedType = try? url.resourceValues(forKeys: [.contentTypeKey]).contentType
    }

    var resolvedIdentifier: String? { resolvedType?.identifier }

    /// The first allowed type the picked file's real type is `==` to,
    /// rendered as its code symbol. Demonstrates identity, not conformance.
    var matchedType: String? {
      switch resolvedType {
      case .plainText: return ".plainText"
      case .lrc: return ".lrc"
      default: return nil
      }
    }

    /// Loose check — passes for .txt, .lrc, and any conforming subtype.
    var conformsToPlainText: Bool {
      resolvedType?.conforms(to: .plainText) ?? false
    }
  }
}
