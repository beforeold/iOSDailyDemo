import SwiftUI

struct ContentView: View {
    @State private var tapCount = 0
    @State private var greetingIndex = 0

    private let greetings = ["Hello", "Welcome", "Nice Tap"]

    private var currentGreeting: String {
        "\(greetings[greetingIndex]), DemoHelloWorld"
    }

    private var counterText: String {
        tapCount == 1 ? "Tapped 1 time" : "Tapped \(tapCount) times"
    }

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                greetingCard
                controls
            }
            .padding(24)
            .frame(maxWidth: 420)
        }
    }

    private var greetingCard: some View {
        VStack(spacing: 14) {
            Image(systemName: "sparkles")
                .font(.system(size: 44, weight: .semibold))
                .foregroundStyle(Color(red: 0, green: 0.34, blue: 0.72))
                .accessibilityLabel("Sparkle")

            Text(currentGreeting)
                .font(.title2.bold())
                .multilineTextAlignment(.center)
                .accessibilityIdentifier("greetingLabel")

            Text(counterText)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(tapCount == 0 ? .secondary : Color(red: 0.04, green: 0.5, blue: 0.49))
                .accessibilityIdentifier("counterLabel")
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }

    private var controls: some View {
        HStack(spacing: 12) {
            Button {
                advanceGreeting()
            } label: {
                Label("Tap", systemImage: "hand.tap.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PrimaryDemoButtonStyle())
            .accessibilityIdentifier("tapButton")

            Button {
                reset()
            } label: {
                Label("Reset", systemImage: "arrow.counterclockwise")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(SecondaryDemoButtonStyle())
            .accessibilityIdentifier("resetButton")
        }
    }

    private func advanceGreeting() {
        tapCount += 1
        greetingIndex = (greetingIndex + 1) % greetings.count
    }

    private func reset() {
        tapCount = 0
        greetingIndex = 0
    }
}

private struct PrimaryDemoButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, minHeight: 52)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(red: 0, green: 0.34, blue: 0.72))
            )
            .opacity(configuration.isPressed ? 0.85 : 1)
    }
}

private struct SecondaryDemoButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.semibold))
            .foregroundStyle(Color(.systemBlue))
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, minHeight: 52)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(.tertiarySystemGroupedBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color(.systemBlue).opacity(0.35), lineWidth: 1)
            )
            .opacity(configuration.isPressed ? 0.75 : 1)
    }
}
