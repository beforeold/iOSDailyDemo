import SwiftUI
import UniformTypeIdentifiers

/// A trivial plain-text document used by `.fileExporter` to write a file.
///
/// The interesting bit for this demo is `writableContentTypes`: it advertises
/// BOTH `.plainText` (.txt) and our exported `.lrc`. The `contentType` passed
/// to `.fileExporter` picks which one — and thus which extension the saved
/// file gets. That extension/UTType binding is exactly what the verification
/// sections above prove.
struct TextFileDocument: FileDocument {
  /// Both writable types share the same plain-text payload — only the
  /// declared UTType (and therefore the file extension) differs.
  static let writableContentTypes: [UTType] = [.plainText, .lrc]
  static let readableContentTypes: [UTType] = [.plainText, .lrc]

  var text: String

  init(text: String) {
    self.text = text
  }

  init(configuration: ReadConfiguration) throws {
    guard let data = configuration.file.regularFileContents,
      let string = String(data: data, encoding: .utf8) else {
      throw CocoaError(.fileReadCorruptFile)
    }
    text = string
  }

  func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
    FileWrapper(regularFileWithContents: Data(text.utf8))
  }
}

/// Generates throwaway sample content so each export is visibly different.
enum RandomContent {
  /// A short block of plain text. `seed` varies the output without needing
  /// `Date`/`random` (kept deterministic-friendly for previews/tests).
  static func plainText(seed: Int) -> String {
    let lines = [
      "DemoUTTypeText sample file",
      "Generated entry #\(seed)",
      "UTType.plainText → public.plain-text",
      "The quick brown fox jumps over the lazy dog.",
    ]
    return lines.joined(separator: "\n") + "\n"
  }

  /// A minimal LRC lyrics body with timestamp tags, so the `.lrc` we write is
  /// actually shaped like a real lyrics file.
  static func lrc(seed: Int) -> String {
    let base = seed % 60
    func stamp(_ offset: Int) -> String {
      let total = base + offset
      let m = (total / 60) % 100
      let s = total % 60
      return String(format: "[%02d:%02d.00]", m, s)
    }
    return """
    [ti:Demo Lyrics #\(seed)]
    [ar:DemoUTTypeText]
    [by:exported com.example.demouttypetext.lrc]
    \(stamp(0))First line of the song
    \(stamp(4))Second line keeps going
    \(stamp(8))And the chorus comes around

    """
  }
}
