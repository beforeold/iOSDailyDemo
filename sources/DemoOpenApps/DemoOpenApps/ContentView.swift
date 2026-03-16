//
//  ContentView.swift
//  DemoOpenApps
//
//  Created by beforeold on 3/16/26.
//

import SwiftUI
import UIKit

private struct SocialApp: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let iconName: String
    let tint: Color
    let deepLink: URL
    let appStoreURL: URL
}

struct ContentView: View {
    @State private var unavailableApp: SocialApp?

    private let socialApps: [SocialApp] = [
        SocialApp(
            name: "Telegram",
            description: "Open the Telegram app via tg://",
            iconName: "paperplane.fill",
            tint: Color(red: 0.16, green: 0.61, blue: 0.98),
            deepLink: URL(string: "tg://")!,
            appStoreURL: URL(string: "https://apps.apple.com/app/telegram-messenger/id686449807")!
        ),
        SocialApp(
            name: "WhatsApp",
            description: "Open the WhatsApp app via whatsapp://",
            iconName: "message.fill",
            tint: Color(red: 0.10, green: 0.74, blue: 0.38),
            deepLink: URL(string: "whatsapp://")!,
            appStoreURL: URL(string: "https://apps.apple.com/us/app/whatsapp-messenger/id310633997")!
        ),
        SocialApp(
            name: "SHAREit",
            description: "Open the SHAREit app via shareit://",
            iconName: "arrow.left.arrow.right.circle.fill",
            tint: Color(red: 0.96, green: 0.49, blue: 0.17),
            deepLink: URL(string: "shareit://")!,
            appStoreURL: URL(string: "https://apps.apple.com/us/app/shareit-connect-transfer/id725215120")!
        )
    ]

    var body: some View {
        NavigationView {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Social List")
                            .font(.title2.weight(.semibold))
                        Text("Tap an item to open the corresponding app. If the app is not installed, the demo will offer App Store fallback.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 6)
                    .listRowBackground(Color.clear)
                }

                Section("Apps") {
                    ForEach(socialApps) { app in
                        Button {
                            open(app)
                        } label: {
                            SocialAppRow(app: app)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .navigationTitle("Open Apps Demo")
            .listStyle(.insetGrouped)
            .alert("App Unavailable", isPresented: unavailableAlertBinding, presenting: unavailableApp) { app in
                Button("Open App Store") {
                    UIApplication.shared.open(app.appStoreURL)
                }
                Button("Cancel", role: .cancel) {}
            } message: { app in
                Text("\(app.name) is not available on this device or its URL scheme could not be opened.")
            }
        }
        .navigationViewStyle(.stack)
    }

    private var unavailableAlertBinding: Binding<Bool> {
        Binding(
            get: { unavailableApp != nil },
            set: { shouldShow in
                if !shouldShow {
                    unavailableApp = nil
                }
            }
        )
    }

    private func open(_ app: SocialApp) {
        UIApplication.shared.open(app.deepLink, options: [:]) { success in
            if !success {
                unavailableApp = app
            }
        }
    }
}

private struct SocialAppRow: View {
    let app: SocialApp

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(app.tint)

                Image(systemName: app.iconName)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .frame(width: 44, height: 44)

            VStack(alignment: .leading, spacing: 4) {
                Text(app.name)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(app.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "arrow.up.forward.app.fill")
                .foregroundStyle(app.tint)
                .font(.system(size: 18, weight: .semibold))
        }
        .padding(.vertical, 6)
        .contentShape(Rectangle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
