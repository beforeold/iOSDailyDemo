import SwiftUI

struct ContentView: View {
  var body: some View {
    TabView {
      ServerDashboardView()
        .tabItem {
          Label("Server", systemImage: "terminal")
        }

      JumpGameView()
        .tabItem {
          Label("Jump", systemImage: "gamecontroller.fill")
        }
    }
  }
}

private struct ServerDashboardView: View {
  @State private var isRunning = true
  @State private var latency = 84.0
  @State private var errorRate = 2.0
  @State private var requestCount = 128
  @State private var events = ServerEvent.seed

  private let primary = Color(red: 0.0, green: 0.341, blue: 0.722)
  private let tertiary = Color(red: 0.039, green: 0.498, blue: 0.49)

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(alignment: .leading, spacing: 20) {
          headerCard
          metricsGrid
          controlsCard
          eventsCard
        }
        .padding(20)
        .frame(maxWidth: 560)
        .frame(maxWidth: .infinity)
      }
      .background(Color(uiColor: .systemGroupedBackground))
      .navigationTitle("Server Sim")
    }
  }

  private var headerCard: some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack(alignment: .top) {
        VStack(alignment: .leading, spacing: 8) {
          Text("Local mock server")
            .font(.title2.weight(.bold))

          Text("Simulate endpoint status, latency, and recent responses without touching the network.")
            .font(.body)
            .foregroundStyle(.secondary)
        }

        Spacer()

        StatusPill(title: isRunning ? "Online" : "Paused", color: isRunning ? tertiary : .secondary)
      }

      HStack(spacing: 10) {
        Image(systemName: "terminal")
          .foregroundStyle(primary)

        Text("http://127.0.0.1:8080/api")
          .font(.callout.monospaced())
          .lineLimit(1)
          .minimumScaleFactor(0.75)
      }
      .padding(12)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
    .cardStyle()
  }

  private var metricsGrid: some View {
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
      MetricTile(title: "Requests", value: "\(requestCount)", symbol: "arrow.left.arrow.right", tint: primary)
      MetricTile(title: "Latency", value: "\(Int(latency)) ms", symbol: "speedometer", tint: tertiary)
      MetricTile(title: "Error Rate", value: "\(Int(errorRate))%", symbol: "exclamationmark.triangle", tint: .orange)
      MetricTile(title: "Health", value: isRunning ? "Healthy" : "Stopped", symbol: "waveform.path.ecg", tint: isRunning ? .green : .secondary)
    }
  }

  private var controlsCard: some View {
    VStack(alignment: .leading, spacing: 18) {
      HStack {
        Text("Controls")
          .font(.headline)

        Spacer()

        Button {
          toggleServer()
        } label: {
          Label(isRunning ? "Pause" : "Start", systemImage: isRunning ? "pause.fill" : "play.fill")
        }
        .buttonStyle(.bordered)
        .tint(primary)
      }

      VStack(spacing: 16) {
        SettingSlider(title: "Latency", value: $latency, range: 20...500, unit: "ms")
        SettingSlider(title: "Error Rate", value: $errorRate, range: 0...40, unit: "%")
      }

      HStack(spacing: 12) {
        Button {
          simulateRequest()
        } label: {
          Label("Send Ping", systemImage: "paperplane.fill")
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(primary)

        Button {
          spikeErrors()
        } label: {
          Label("Spike", systemImage: "bolt.fill")
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .tint(.orange)
      }
    }
    .cardStyle()
  }

  private var eventsCard: some View {
    VStack(alignment: .leading, spacing: 14) {
      HStack {
        Text("Recent Responses")
          .font(.headline)

        Spacer()

        Text("\(events.count) events")
          .font(.caption)
          .foregroundStyle(.secondary)
      }

      VStack(spacing: 0) {
        ForEach(events) { event in
          EventRow(event: event)

          if event.id != events.last?.id {
            Divider()
              .padding(.leading, 40)
          }
        }
      }
    }
    .cardStyle()
  }

  private func toggleServer() {
    isRunning.toggle()
    let event = ServerEvent(
      time: Date(),
      method: "SYS",
      route: isRunning ? "/server/start" : "/server/pause",
      code: isRunning ? 200 : 202,
      latency: 0
    )
    insert(event)
  }

  private func simulateRequest() {
    requestCount += 1

    let routes = ["/users", "/health", "/feed", "/upload"]
    let methods = ["GET", "POST", "PATCH"]
    let failed = Double.random(in: 0...100) < errorRate
    let code: Int

    if isRunning {
      code = failed ? [429, 500, 502].randomElement() ?? 500 : [200, 201, 204].randomElement() ?? 200
    } else {
      code = 503
    }

    let jitter = Int.random(in: -18...48)
    let event = ServerEvent(
      time: Date(),
      method: methods.randomElement() ?? "GET",
      route: routes.randomElement() ?? "/health",
      code: code,
      latency: max(8, Int(latency) + jitter)
    )

    insert(event)
  }

  private func spikeErrors() {
    errorRate = min(40, errorRate + 8)
    simulateRequest()
  }

  private func insert(_ event: ServerEvent) {
    withAnimation(.easeInOut(duration: 0.2)) {
      events.insert(event, at: 0)
      events = Array(events.prefix(6))
    }
  }
}

private struct MetricTile: View {
  let title: String
  let value: String
  let symbol: String
  let tint: Color

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Image(systemName: symbol)
        .font(.headline)
        .foregroundStyle(tint)

      VStack(alignment: .leading, spacing: 4) {
        Text(value)
          .font(.title3.weight(.bold))
          .lineLimit(1)
          .minimumScaleFactor(0.8)

        Text(title)
          .font(.caption)
          .foregroundStyle(.secondary)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .cardStyle()
  }
}

private struct SettingSlider: View {
  let title: String
  @Binding var value: Double
  let range: ClosedRange<Double>
  let unit: String

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Text(title)
          .font(.subheadline.weight(.semibold))

        Spacer()

        Text("\(Int(value)) \(unit)")
          .font(.caption.monospacedDigit())
          .foregroundStyle(.secondary)
      }

      Slider(value: $value, in: range, step: 1)
    }
  }
}

private struct StatusPill: View {
  let title: String
  let color: Color

  var body: some View {
    Label(title, systemImage: "circle.fill")
      .font(.caption.weight(.semibold))
      .foregroundStyle(color)
      .padding(.horizontal, 10)
      .padding(.vertical, 6)
      .background(Color(uiColor: .secondarySystemGroupedBackground), in: Capsule())
  }
}

private struct EventRow: View {
  let event: ServerEvent

  var body: some View {
    HStack(spacing: 12) {
      Text("\(event.code)")
        .font(.callout.weight(.bold).monospacedDigit())
        .foregroundStyle(event.codeColor)
        .frame(width: 40, alignment: .leading)

      VStack(alignment: .leading, spacing: 3) {
        Text("\(event.method) \(event.route)")
          .font(.subheadline.weight(.semibold))

        Text(event.time.formatted(date: .omitted, time: .shortened))
          .font(.caption)
          .foregroundStyle(.secondary)
      }

      Spacer()

      Text(event.latency == 0 ? "-" : "\(event.latency) ms")
        .font(.caption.monospacedDigit())
        .foregroundStyle(.secondary)
    }
    .padding(.vertical, 11)
  }
}

private struct ServerEvent: Identifiable {
  let id = UUID()
  let time: Date
  let method: String
  let route: String
  let code: Int
  let latency: Int

  var codeColor: Color {
    switch code {
    case 200..<300:
      return .green
    case 400..<500:
      return .orange
    default:
      return .red
    }
  }

  static var seed: [ServerEvent] {
    [
      ServerEvent(time: Date().addingTimeInterval(-24), method: "GET", route: "/health", code: 200, latency: 42),
      ServerEvent(time: Date().addingTimeInterval(-58), method: "POST", route: "/upload", code: 201, latency: 136),
      ServerEvent(time: Date().addingTimeInterval(-91), method: "GET", route: "/feed", code: 200, latency: 78)
    ]
  }
}

private extension View {
  func cardStyle() -> some View {
    padding(20)
      .background(Color(uiColor: .systemBackground), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
  }
}

private struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
