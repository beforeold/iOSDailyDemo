import Foundation
import UniformTypeIdentifiers

/// Verification logic for UTType raw values and equality.
///
/// Two questions this demo answers:
/// 1. What is the `rawValue` (`identifier`) of the text-family UTTypes?
/// 2. When you construct a UTType through different routes (identifier string,
///    file extension, MIME type, declared-vs-dynamic), are the results `==`?
enum UTTypeProbe {

  // MARK: - 1. Raw values of text-family UTTypes

  struct RawValueRow: Identifiable {
    let id = UUID()
    /// The Swift property used to reach the type, e.g. `.plainText`.
    let symbol: String
    /// `UTType.identifier` — what Apple calls the "raw value" of the type.
    let identifier: String
    /// The preferred filename extension, if the type declares one.
    let filenameExtension: String?
    /// The preferred MIME type, if the type declares one.
    let mimeType: String?
    /// Whether the type conforms to `.text` (the broad text ancestor).
    let conformsToText: Bool
    /// Whether the type conforms to `.plainText` (a *narrower* subtype of
    /// `.text`). True for .lrc/.json/.swiftSource…, false for .rtf/.html/.xml.
    let conformsToPlainText: Bool
  }

  static func makeRawValueRow(_ symbol: String, _ type: UTType) -> RawValueRow {
    RawValueRow(
      symbol: symbol,
      identifier: type.identifier,
      filenameExtension: type.preferredFilenameExtension,
      mimeType: type.preferredMIMEType,
      conformsToText: type.conforms(to: .text),
      conformsToPlainText: type.conforms(to: .plainText)
    )
  }

  /// The text-family system types, paired with the symbol you'd write in code.
  static let textRawValues: [RawValueRow] = [
    makeRawValueRow(".text", .text),
    makeRawValueRow(".plainText", .plainText),
    makeRawValueRow(".utf8PlainText", .utf8PlainText),
    makeRawValueRow(".utf16PlainText", .utf16PlainText),
    makeRawValueRow(".utf16ExternalPlainText", .utf16ExternalPlainText),
    makeRawValueRow(".delimitedText", .delimitedText),
    makeRawValueRow(".commaSeparatedText", .commaSeparatedText),
    makeRawValueRow(".tabSeparatedText", .tabSeparatedText),
    makeRawValueRow(".rtf", .rtf),
    makeRawValueRow(".html", .html),

    makeRawValueRow(".xml", .xml),
    makeRawValueRow(".json", .json),
    makeRawValueRow(".sourceCode", .sourceCode),
    makeRawValueRow(".swiftSource", .swiftSource),
    makeRawValueRow(".log", .text),
    // Our app-exported type for .lrc lyrics (see UTType+LRC.swift).
    makeRawValueRow(".lrc (exported)", .lrc),
  ]

  // MARK: - 2. Equality of UTTypes built via different constructors

  struct EqualityRow: Identifiable {
    let id = UUID()
    /// Plain-English description of what is being compared.
    let description: String
    /// Left operand as code.
    let lhsExpression: String
    /// Right operand as code.
    let rhsExpression: String
    /// Resolved identifiers, so you can see *why* the result is what it is.
    let lhsIdentifier: String?
    let rhsIdentifier: String?
    /// The `==` result.
    let isEqual: Bool
    /// Whether we expected them to be equal — used to flag surprises.
    let expectedEqual: Bool

    var matchesExpectation: Bool { isEqual == expectedEqual }
  }

  static func makeEqualityRow(
    _ description: String,
    lhs: (String, UTType?),
    rhs: (String, UTType?),
    expectedEqual: Bool
  ) -> EqualityRow {
    EqualityRow(
      description: description,
      lhsExpression: lhs.0,
      rhsExpression: rhs.0,
      lhsIdentifier: lhs.1?.identifier,
      rhsIdentifier: rhs.1?.identifier,
      isEqual: lhs.1 == rhs.1,
      expectedEqual: expectedEqual
    )
  }

  static let equalityChecks: [EqualityRow] = [
    // Identifier string round-trips back to the same declared type.
    makeEqualityRow(
      "Identifier string vs static constant",
      lhs: ("UTType(\"public.plain-text\")", UTType("public.plain-text")),
      rhs: (".plainText", .plainText),
      expectedEqual: true
    ),
    // The exported-type initializer fails (returns nil) for an unknown id and
    // can be coerced to a *dynamic* type. Here we use the importing init that
    // looks up the declared type by identifier.
    makeEqualityRow(
      "importedAs declared id vs static constant",
      lhs: ("UTType(importedAs: \"public.text\")", UTType(importedAs: "public.text")),
      rhs: (".text", .text),
      expectedEqual: true
    ),
    // Constructing from a filename extension resolves to the declared type.
    makeEqualityRow(
      "From .txt extension vs .plainText",
      lhs: ("UTType(filenameExtension: \"txt\")", UTType(filenameExtension: "txt")),
      rhs: (".plainText", .plainText),
      expectedEqual: true
    ),
    // Constructing from a MIME type resolves to the declared type.
    makeEqualityRow(
      "From text/html MIME vs .html",
      lhs: ("UTType(mimeType: \"text/html\")", UTType(mimeType: "text/html")),
      rhs: (".html", .html),
      expectedEqual: true
    ),
    // JSON identifier round-trip.
    makeEqualityRow(
      "From .json extension vs .json",
      lhs: ("UTType(filenameExtension: \"json\")", UTType(filenameExtension: "json")),
      rhs: (".json", .json),
      expectedEqual: true
    ),
    // Different concrete types are NOT equal (sanity check).
    makeEqualityRow(
      "Different types are not equal",
      lhs: (".plainText", .plainText),
      rhs: (".rtf", .rtf),
      expectedEqual: false
    ),
    // A type and its supertype are NOT equal even though one conforms to the
    // other — equality is identifier identity, not conformance.
    makeEqualityRow(
      ".plainText vs .text (conforms ≠ equal)",
      lhs: (".plainText", .plainText),
      rhs: (".text", .text),
      expectedEqual: false
    ),
    // An unknown extension with no declared type produces a *dynamic* UTType.
    // Two dynamic types built from the same unknown extension are equal,
    // because the dynamic identifier is derived deterministically.
    makeEqualityRow(
      "Two dynamic types from same unknown ext",
      lhs: (
        "UTType(filenameExtension: \"madeupext\")",
        UTType(filenameExtension: "madeupext")
      ),
      rhs: (
        "UTType(filenameExtension: \"madeupext\")",
        UTType(filenameExtension: "madeupext")
      ),
      expectedEqual: true
    ),
    // A dynamic type is NOT equal to the static .plainText.
    makeEqualityRow(
      "Dynamic unknown type vs .plainText",
      lhs: (
        "UTType(filenameExtension: \"madeupext\")",
        UTType(filenameExtension: "madeupext")
      ),
      rhs: (".plainText", .plainText),
      expectedEqual: false
    ),
    // Our EXPORTED .lrc type resolves from its declared identifier, so the
    // .lrc symbol and a lookup of that identifier are the same type.
    makeEqualityRow(
      "Exported .lrc vs its identifier",
      lhs: (".lrc", .lrc),
      rhs: (
        "UTType(\"com.example.demouttypetext.lrc\")",
        UTType("com.example.demouttypetext.lrc")
      ),
      expectedEqual: true
    ),
    // Because .lrc is DECLARED (in Info.plist), constructing from the .lrc
    // extension resolves to our exported type — NOT a dynamic dyn.* type.
    makeEqualityRow(
      "From .lrc extension vs exported .lrc",
      lhs: ("UTType(filenameExtension: \"lrc\")", UTType(filenameExtension: "lrc")),
      rhs: (".lrc", .lrc),
      expectedEqual: true
    ),
    // .lrc conforms to .plainText (we declared it so) but is a distinct
    // type — conformance, again, is not equality.
    makeEqualityRow(
      ".lrc vs .plainText (conforms ≠ equal)",
      lhs: (".lrc", .lrc),
      rhs: (".plainText", .plainText),
      expectedEqual: false
    ),
  ]

  /// True when every equality check resolved as expected.
  static var allEqualityChecksPass: Bool {
    equalityChecks.allSatisfy(\.matchesExpectation)
  }
}
