import SwiftUI

struct ContentView: View {
    @State private var selection: PaletteColor = PaletteColor.all.first!

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Palette Picker Style")
                .font(.largeTitle.weight(.bold))

            Text("Default Picker rendering for a palette-like set of color options.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Menu {
                Picker("Palette", selection: $selection) {
                    ForEach(PaletteColor.all) { swatch in
                        Label {
                            Text(swatch.name)
                        } icon: {
                            Circle()
                                .fill(swatch.color)
                                .frame(width: 16, height: 16)
                        }
                        .tag(swatch)
                    }
                }
                .pickerStyle(.palette)
            } label: {
                Label("Choose Color", systemImage: "paintpalette")
                    .font(.headline)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(.secondary.opacity(0.15))
                    )
            }

            HStack(spacing: 12) {
                Circle()
                    .fill(selection.color)
                    .frame(width: 18, height: 18)
                Text("Selected: \(selection.name)")
                    .font(.headline)
            }

            Spacer()
        }
        .padding(24)
    }
}

private struct PaletteColor: Identifiable, Hashable, Equatable {
    let id = UUID()
    let name: String
    let color: Color

    static let all: [PaletteColor] = [
        PaletteColor(name: "Coral", color: Color(red: 0.97, green: 0.45, blue: 0.38)),
        PaletteColor(name: "Sunflower", color: Color(red: 0.98, green: 0.78, blue: 0.24)),
        PaletteColor(name: "Mint", color: Color(red: 0.35, green: 0.78, blue: 0.62)),
        PaletteColor(name: "Sky", color: Color(red: 0.30, green: 0.62, blue: 0.90)),
        PaletteColor(name: "Indigo", color: Color(red: 0.33, green: 0.38, blue: 0.83)),
        PaletteColor(name: "Plum", color: Color(red: 0.63, green: 0.38, blue: 0.74)),
        PaletteColor(name: "Rose", color: Color(red: 0.92, green: 0.32, blue: 0.53)),
        PaletteColor(name: "Charcoal", color: Color(red: 0.22, green: 0.22, blue: 0.25))
    ]
}

#Preview {
    ContentView()
}
