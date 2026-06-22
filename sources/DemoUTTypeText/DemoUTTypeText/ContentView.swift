import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationStack {
      List {
        FileActionsSection()
        rawValuesSection
        equalitySection
      }
      .navigationTitle("UTType Text")
      .navigationBarTitleDisplayMode(.inline)
    }
  }

  // MARK: - Section 1: raw values

  private var rawValuesSection: some View {
    Section {
      ForEach(UTTypeProbe.textRawValues) { row in
        VStack(alignment: .leading, spacing: 4) {
          HStack {
            Text(row.symbol)
              .font(.subheadline.monospaced().bold())
            Spacer()
            // Two conformance facts in one row: the broad ancestor (.text) and
            // the narrower subtype (.plainText). .lrc lights both → it is a
            // plain-text subtype, which is *why* a [.plainText] picker accepts it.
            if row.conformsToPlainText {
              conformsTag(".plainText", highlighted: true)
            }
            if row.conformsToText {
              conformsTag(".text", highlighted: false)
            }
          }
          Text(row.identifier)
            .font(.caption.monospaced())
            .foregroundStyle(.tint)
            .textSelection(.enabled)

          HStack(spacing: 12) {
            if let ext = row.filenameExtension {
              Label(".\(ext)", systemImage: "doc")
            }
            if let mime = row.mimeType {
              Label(mime, systemImage: "network")
            }
          }
          .font(.caption2)
          .foregroundStyle(.secondary)
        }
        .padding(.vertical, 2)
      }
    } header: {
      Text("1 · rawValue (identifier) of text UTTypes")
    } footer: {
      Text("UTType.identifier is the \"raw value\" string Apple registers for each declared type.")
    }
  }

  // MARK: - Section 2: equality

  private var equalitySection: some View {
    Section {
      ForEach(UTTypeProbe.equalityChecks) { row in
        VStack(alignment: .leading, spacing: 6) {
          HStack {
            Text(row.description)
              .font(.subheadline.bold())
            Spacer()
            resultBadge(row)
          }

          Text("\(row.lhsExpression)  ==  \(row.rhsExpression)")
            .font(.caption.monospaced())
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)

          HStack(spacing: 6) {
            identifierChip(row.lhsIdentifier)
            Image(systemName: row.isEqual ? "equal" : "notequal")
              .font(.caption2)
              .foregroundStyle(row.isEqual ? .green : .secondary)
            identifierChip(row.rhsIdentifier)
          }
        }
        .padding(.vertical, 2)
      }
    } header: {
      Text("2 · equality of UTTypes from different constructors")
    } footer: {
      Text(UTTypeProbe.allEqualityChecksPass
        ? "✅ All equality checks matched expectations."
        : "⚠️ Some checks did not match expectations.")
        .foregroundStyle(UTTypeProbe.allEqualityChecksPass ? .green : .orange)
    }
  }

  /// Badge whose colour distinguishes `==` (green, filled) from `!=` (neutral,
  /// outlined). A failed expectation overrides both with a red alert ring so an
  /// unexpected result still stands out.
  private func resultBadge(_ row: UTTypeProbe.EqualityRow) -> some View {
    let unexpected = !row.matchesExpectation
    // Base tint by equality; red only when the result is a surprise.
    let tint: Color = unexpected ? .red : (row.isEqual ? .green : .secondary)
    return Text(row.isEqual ? "==" : "!=")
      .font(.caption.monospaced().bold())
      .padding(.horizontal, 8)
      .padding(.vertical, 2)
      .foregroundStyle(tint)
      .background {
        Capsule()
          // Equal → filled chip; not-equal → hollow chip (fill only on ==).
          .fill(row.isEqual ? tint.opacity(0.18) : Color.clear)
          .overlay(
            Capsule().strokeBorder(tint.opacity(unexpected ? 0.9 : 0.5),
                                   lineWidth: row.isEqual ? 0 : 1)
          )
      }
  }

  private func identifierChip(_ identifier: String?) -> some View {
    Text(identifier ?? "nil")
      .font(.caption2.monospaced())
      .lineLimit(1)
      .truncationMode(.middle)
      .padding(.horizontal, 6)
      .padding(.vertical, 2)
      .background(Color.secondary.opacity(0.12))
      .clipShape(RoundedRectangle(cornerRadius: 4))
  }

  /// A small "conforms <type>" tag. The narrower, more interesting fact
  /// (.plainText) is highlighted green; the broad ancestor (.text) stays muted.
  private func conformsTag(_ type: String, highlighted: Bool) -> some View {
    Text("conforms \(type)")
      .font(.caption2)
      .padding(.horizontal, 6)
      .padding(.vertical, 2)
      .background((highlighted ? Color.green : Color.secondary).opacity(0.15))
      .foregroundStyle(highlighted ? Color.green : Color.secondary)
      .clipShape(Capsule())
  }
}

#Preview {
  ContentView()
}
