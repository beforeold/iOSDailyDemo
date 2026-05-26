import SwiftUI

struct ContentView: View {
    private enum Field: Hashable {
        case first
        case second
    }

    @State private var firstValue = ""
    @State private var secondValue = ""
    @State private var resultText = "No result yet"
    @State private var resultTone: ResultTone = .neutral
    @FocusState private var focusedField: Field?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header
                calculatorCard
                resultCard
            }
            .frame(maxWidth: 520)
            .padding(20)
            .frame(maxWidth: .infinity)
        }
        .background(Color(uiColor: .systemGroupedBackground))
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Addition Calculator", systemImage: "plus.forwardslash.minus")
                .font(.title.bold())

            Text("Enter two values, then add them with one tap.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .padding(.top, 12)
    }

    private var calculatorCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            numberField(
                title: "First number",
                text: $firstValue,
                field: .first,
                identifier: "firstNumberField"
            )

            numberField(
                title: "Second number",
                text: $secondValue,
                field: .second,
                identifier: "secondNumberField"
            )

            HStack(spacing: 12) {
                Button {
                    addNumbers()
                } label: {
                    Label("Add", systemImage: "plus")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .accessibilityIdentifier("addButton")

                Button {
                    clear()
                } label: {
                    Label("Clear", systemImage: "xmark")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .accessibilityIdentifier("clearButton")
            }
        }
        .padding(20)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private var resultCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Result")
                .font(.headline)

            Text(resultText)
                .font(.system(.title2, design: .rounded).weight(.semibold))
                .foregroundStyle(resultTone.color)
                .accessibilityIdentifier("resultLabel")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private func numberField(
        title: String,
        text: Binding<String>,
        field: Field,
        identifier: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline.weight(.semibold))

            TextField("0", text: text)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
                .font(.title3.monospacedDigit())
                .focused($focusedField, equals: field)
                .accessibilityIdentifier(identifier)
        }
    }

    private func addNumbers() {
        focusedField = nil

        guard let firstNumber = Double(firstValue),
              let secondNumber = Double(secondValue) else {
            resultText = "Enter two valid numbers."
            resultTone = .error
            return
        }

        resultText = format(firstNumber + secondNumber)
        resultTone = .success
    }

    private func clear() {
        firstValue = ""
        secondValue = ""
        resultText = "No result yet"
        resultTone = .neutral
        focusedField = .first
    }

    private func format(_ value: Double) -> String {
        if value.rounded() == value {
            return String(Int(value))
        }

        return String(format: "%.2f", value)
    }
}

private enum ResultTone {
    case neutral
    case success
    case error

    var color: Color {
        switch self {
        case .neutral:
            return .secondary
        case .success:
            return Color(uiColor: .systemTeal)
        case .error:
            return Color(uiColor: .systemRed)
        }
    }
}
