//
//  ContentView.swift
//  DemoAVRoute
//
//  Created by beforeold on 3/20/26.
//

import AVKit
import SwiftUI

struct ContentView: View {
  @State private var logs: [String] = [
    "Ready",
  ]

  var body: some View {
    NavigationView {
      ScrollView {
        VStack(alignment: .leading, spacing: 20) {
          Text("AVRoutePickerView Demo")
            .font(.title2.weight(.semibold))

          Text("Compare the plain control with the same control inside a parent drag gesture.")
            .font(.subheadline)
            .foregroundStyle(.secondary)

          RouteScenarioCard(
            title: "Plain",
            subtitle: "No parent gesture.",
            mode: .none,
            onEvent: appendLog,
          )

          RouteScenarioCard(
            title: "Parent .gesture",
            subtitle: "Matches the original full-screen player drag setup.",
            mode: .exclusiveDragGesture,
            onEvent: appendLog,
          )

          RouteScenarioCard(
            title: "Parent .simultaneousGesture",
            subtitle: "Lets the embedded UIKit route picker compete for touches.",
            mode: .simultaneousDragGesture,
            onEvent: appendLog,
          )

          VStack(alignment: .leading, spacing: 8) {
            Text("Event Log")
              .font(.headline)

            VStack(alignment: .leading, spacing: 6) {
              ForEach(Array(logs.enumerated()), id: \.offset) { _, log in
                Text(log)
                  .font(.caption.monospaced())
                  .frame(maxWidth: .infinity, alignment: .leading)
              }
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
          }
        }
        .padding(20)
      }
      .navigationTitle("DemoAVRoute")
    }
  }

  private func appendLog(_ message: String) {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss.SSS"
    let prefix = formatter.string(from: Date())

    logs.insert("[\(prefix)] \(message)", at: 0)
    logs = Array(logs.prefix(12))
  }
}

private struct RouteScenarioCard: View {
  let title: String
  let subtitle: String
  let mode: GestureMode
  let onEvent: (String) -> Void

  @State private var dragDistance: CGFloat = 0

  var body: some View {
    Group {
      switch mode {
      case .none:
        cardContent
      case .exclusiveDragGesture:
        cardContent.gesture(dragGesture)
      case .simultaneousDragGesture:
        cardContent.simultaneousGesture(dragGesture)
      }
    }
  }

  private var cardContent: some View {
    VStack(alignment: .leading, spacing: 14) {
      Text(title)
        .font(.headline)

      Text(subtitle)
        .font(.subheadline)
        .foregroundStyle(.secondary)

      HStack(spacing: 12) {
        DemoRoutePickerView(
          onWillBeginPresentingRoutes: {
            onEvent("\(title): route picker will begin presenting routes")
          },
          onDidEndPresentingRoutes: {
            onEvent("\(title): route picker did end presenting routes")
          },
        )
        .frame(width: 44, height: 44)

        Text("Drag distance: \(Int(dragDistance))")
          .font(.footnote.monospacedDigit())
          .foregroundStyle(.secondary)
      }

      Text("Try tapping the route button and dragging inside this card.")
        .font(.footnote)
        .foregroundStyle(.secondary)
    }
    .padding(16)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color(uiColor: .secondarySystemBackground))
    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
  }

  private var dragGesture: some Gesture {
    DragGesture()
      .onChanged { value in
        dragDistance = value.translation.height
        onEvent("\(title): drag changed \(Int(value.translation.height))")
      }
      .onEnded { value in
        dragDistance = 0
        onEvent("\(title): drag ended \(Int(value.translation.height))")
      }
  }
}

private enum GestureMode {
  case none
  case exclusiveDragGesture
  case simultaneousDragGesture
}

private struct DemoRoutePickerView: UIViewRepresentable {
  let onWillBeginPresentingRoutes: () -> Void
  let onDidEndPresentingRoutes: () -> Void

  func makeCoordinator() -> Coordinator {
    Coordinator(
      onWillBeginPresentingRoutes: onWillBeginPresentingRoutes,
      onDidEndPresentingRoutes: onDidEndPresentingRoutes,
    )
  }

  func makeUIView(context: Context) -> AVRoutePickerView {
    let routePickerView = AVRoutePickerView()
    routePickerView.delegate = context.coordinator
    routePickerView.tintColor = .systemBlue
    routePickerView.activeTintColor = .systemGreen
    return routePickerView
  }

  func updateUIView(_ uiView: AVRoutePickerView, context: Context) {
    context.coordinator.onWillBeginPresentingRoutes = onWillBeginPresentingRoutes
    context.coordinator.onDidEndPresentingRoutes = onDidEndPresentingRoutes
  }

  final class Coordinator: NSObject, AVRoutePickerViewDelegate {
    var onWillBeginPresentingRoutes: () -> Void
    var onDidEndPresentingRoutes: () -> Void

    init(
      onWillBeginPresentingRoutes: @escaping () -> Void,
      onDidEndPresentingRoutes: @escaping () -> Void,
    ) {
      self.onWillBeginPresentingRoutes = onWillBeginPresentingRoutes
      self.onDidEndPresentingRoutes = onDidEndPresentingRoutes
    }

    func routePickerViewWillBeginPresentingRoutes(_ routePickerView: AVRoutePickerView) {
      onWillBeginPresentingRoutes()
    }

    func routePickerViewDidEndPresentingRoutes(_ routePickerView: AVRoutePickerView) {
      onDidEndPresentingRoutes()
    }
  }
}

#Preview {
  ContentView()
}
