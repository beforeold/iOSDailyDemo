import UniformTypeIdentifiers

extension UTType {
  /// LRC lyrics file (`.lrc`).
  ///
  /// `.lrc` has no Apple-declared system type, so this app *exports* its own
  /// type in Info.plist (`UTExportedTypeDeclarations`) conforming to
  /// `public.plain-text`. `importedAs:` looks that declaration up by
  /// identifier — meaning `.lrc == UTType("com.example.demouttypetext.lrc")`.
  ///
  /// Because we declared `conformsTo public.plain-text`, `.lrc.conforms(to:
  /// .plainText)` is `true` — unlike the dynamic `dyn.*` type you'd get from
  /// `UTType(filenameExtension: "lrc")` with no declaration.
  static let lrc = UTType(importedAs: "com.example.demouttypetext.lrc")
}
