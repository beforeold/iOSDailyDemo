import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "sparkles")
                .font(.system(size: 44, weight: .semibold))
                .foregroundStyle(.tint)

            Text("DemoHelloWorld")
                .font(.title.bold())

            Text("New demo project")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}
