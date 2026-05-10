//
//  ContentView.swift
//  DemoHelloMini
//
//  Created by yojee on 5/9/26.
//

import SwiftUI

struct ContentView: View {
    @State private var angle = 25.0
    @GestureState private var dragTranslation: CGFloat = 0

    private var liveAngle: Double {
        normalizedAngle(angle + Double(dragTranslation) * 0.55)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header
                stageCard
                controlsCard
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 28)
            .frame(maxWidth: 620)
            .frame(maxWidth: .infinity)
        }
        .background(Color(uiColor: .systemGroupedBackground))
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Text("Mac mini")
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .foregroundStyle(.primary)

                StatusPill(text: "360°")
            }

            HStack(spacing: 10) {
                Image(systemName: "rotate.3d")
                    .font(.callout.weight(.semibold))
                    .foregroundStyle(Color.accentColor)

                Text(currentFace(for: liveAngle))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Mac mini 360 度查看器，当前\(currentFace(for: liveAngle))")
    }

    private var stageCard: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(uiColor: .systemBackground))
                .shadow(color: .black.opacity(0.07), radius: 14, y: 6)

            MacMini360Drawing(angle: liveAngle)
                .padding(.horizontal, 16)
                .padding(.vertical, 26)
                .gesture(rotationGesture)
                .accessibilityLabel("Mac mini")
                .accessibilityValue("\(Int(liveAngle.rounded())) 度")
                .accessibilityAdjustableAction { direction in
                    switch direction {
                    case .increment:
                        angle = normalizedAngle(angle + 15)
                    case .decrement:
                        angle = normalizedAngle(angle - 15)
                    @unknown default:
                        break
                    }
                }

            AngleBadge(angle: liveAngle)
                .padding(16)
        }
        .frame(minHeight: 300)
    }

    private var controlsCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Label("旋转", systemImage: "dial.medium")
                    .font(.headline)

                Spacer()

                Text("\(Int(liveAngle.rounded()))°")
                    .font(.headline.monospacedDigit())
                    .foregroundStyle(.secondary)
            }

            Slider(
                value: Binding(
                    get: { liveAngle },
                    set: { angle = normalizedAngle($0) }
                ),
                in: 0...359
            ) {
                Text("角度")
            } minimumValueLabel: {
                Text("0°")
            } maximumValueLabel: {
                Text("360°")
            }

            HStack(spacing: 10) {
                ForEach(AnglePreset.allCases) { preset in
                    Button {
                        withAnimation(.easeOut(duration: 0.22)) {
                            angle = preset.angle
                        }
                    } label: {
                        Label(preset.title, systemImage: preset.symbol)
                            .labelStyle(.titleAndIcon)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.regular)
                }
            }

            Divider()

            HStack(spacing: 12) {
                Label(currentFace(for: liveAngle), systemImage: "viewfinder")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)

                Spacer()

                Button {
                    withAnimation(.easeOut(duration: 0.25)) {
                        angle = 25
                    }
                } label: {
                    Label("重置", systemImage: "arrow.counterclockwise")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(uiColor: .systemBackground))
        )
    }

    private var rotationGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .updating($dragTranslation) { value, state, _ in
                state = value.translation.width
            }
            .onEnded { value in
                angle = normalizedAngle(angle + Double(value.translation.width) * 0.55)
            }
    }
}

private struct MacMini360Drawing: View {
    let angle: Double

    var body: some View {
        Canvas { context, size in
            MacMiniRenderer(angle: angle, size: size).draw(in: &context)
        }
        .aspectRatio(1.35, contentMode: .fit)
    }
}

private struct MacMiniRenderer {
    private let angle: Double
    private let size: CGSize
    private let width: CGFloat = 238
    private let depth: CGFloat = 172
    private let height: CGFloat = 48
    private let tilt: CGFloat = 0.24

    init(angle: Double, size: CGSize) {
        self.angle = angle
        self.size = size
    }

    func draw(in context: inout GraphicsContext) {
        let footprint = superellipsePointSamples(count: 112)
        let topPath = path(for: footprint, y: 0)
        let bottomPath = path(for: footprint, y: height)

        drawShadow(in: &context)
        drawSides(from: footprint, in: &context)

        context.fill(
            topPath,
            with: .linearGradient(
                Gradient(colors: [
                    Color(red: 0.98, green: 0.985, blue: 0.985),
                    Color(red: 0.86, green: 0.875, blue: 0.89)
                ]),
                startPoint: CGPoint(x: size.width * 0.26, y: size.height * 0.22),
                endPoint: CGPoint(x: size.width * 0.80, y: size.height * 0.58)
            )
        )

        drawTopHighlight(in: &context)
        drawLogo(in: &context)
        drawFaceDetails(in: &context)

        context.stroke(bottomPath, with: .color(.black.opacity(0.08)), lineWidth: lineWidth(1.1))
        context.stroke(
            topPath,
            with: .linearGradient(
                Gradient(colors: [.white.opacity(0.72), .black.opacity(0.16)]),
                startPoint: CGPoint(x: size.width * 0.22, y: size.height * 0.24),
                endPoint: CGPoint(x: size.width * 0.78, y: size.height * 0.62)
            ),
            lineWidth: lineWidth(1.4)
        )
    }

    private func drawShadow(in context: inout GraphicsContext) {
        let shadowRect = CGRect(
            x: size.width * 0.17,
            y: size.height * 0.70,
            width: size.width * 0.66,
            height: size.height * 0.16
        )

        context.fill(
            Path(ellipseIn: shadowRect),
            with: .radialGradient(
                Gradient(colors: [
                    Color.black.opacity(0.22),
                    Color.black.opacity(0.025)
                ]),
                center: CGPoint(x: shadowRect.midX, y: shadowRect.midY),
                startRadius: lineWidth(6),
                endRadius: shadowRect.width * 0.52
            )
        )
    }

    private func drawSides(from footprint: [ModelPoint], in context: inout GraphicsContext) {
        let strips = footprint.indices.map { index -> SideStrip in
            let nextIndex = (index + 1) % footprint.count
            let start = footprint[index]
            let end = footprint[nextIndex]
            let midAngle = atan2((start.z + end.z) * 0.5 / (depth * 0.5), (start.x + end.x) * 0.5 / (width * 0.5))
            let normal = ModelPoint(x: cos(midAngle), z: sin(midAngle))
            let facing = rotatedDepth(x: normal.x, z: normal.z)
            let centerDepth = rotatedDepth(x: (start.x + end.x) * 0.5, z: (start.z + end.z) * 0.5)

            var path = Path()
            path.move(to: project(start, y: 0))
            path.addLine(to: project(end, y: 0))
            path.addLine(to: project(end, y: height))
            path.addLine(to: project(start, y: height))
            path.closeSubpath()

            return SideStrip(path: path, facing: facing, depth: centerDepth)
        }
        .filter { $0.facing > 0.015 }
        .sorted { $0.depth < $1.depth }

        for strip in strips {
            let light = 0.73 + min(max(strip.facing, 0), 1) * 0.12
            context.fill(
                strip.path,
                with: .linearGradient(
                    Gradient(colors: [
                        Color(red: Double(light), green: Double(light + 0.01), blue: Double(light + 0.025)),
                        Color(red: Double(light - 0.14), green: Double(light - 0.13), blue: Double(light - 0.11))
                    ]),
                    startPoint: CGPoint(x: size.width * 0.5, y: size.height * 0.38),
                    endPoint: CGPoint(x: size.width * 0.5, y: size.height * 0.76)
                )
            )
        }
    }

    private func drawTopHighlight(in context: inout GraphicsContext) {
        let inset: CGFloat = 20
        let highlight = superellipsePointSamples(count: 96, inset: inset)
        let path = path(for: highlight, y: -0.5)
        context.fill(
            path,
            with: .linearGradient(
                Gradient(colors: [
                    Color.white.opacity(0.50),
                    Color.white.opacity(0.06)
                ]),
                startPoint: CGPoint(x: size.width * 0.30, y: size.height * 0.26),
                endPoint: CGPoint(x: size.width * 0.74, y: size.height * 0.58)
            )
        )
    }

    private func drawLogo(in context: inout GraphicsContext) {
        let logoScale: CGFloat = 0.48
        var appleBody = Path()
        func logoPoint(_ x: CGFloat, _ z: CGFloat) -> CGPoint {
            project(ModelPoint(x: x * logoScale, z: z * logoScale), y: -1)
        }

        appleBody.move(to: logoPoint(0, -37))
        appleBody.addCurve(to: logoPoint(-25, -47), control1: logoPoint(-8, -45), control2: logoPoint(-18, -49))
        appleBody.addCurve(to: logoPoint(-51, -27), control1: logoPoint(-38, -45), control2: logoPoint(-48, -38))
        appleBody.addCurve(to: logoPoint(-54, 22), control1: logoPoint(-64, -10), control2: logoPoint(-62, 10))
        appleBody.addCurve(to: logoPoint(-32, 54), control1: logoPoint(-47, 39), control2: logoPoint(-40, 50))
        appleBody.addCurve(to: logoPoint(-12, 48), control1: logoPoint(-23, 60), control2: logoPoint(-18, 50))
        appleBody.addCurve(to: logoPoint(12, 48), control1: logoPoint(-4, 43), control2: logoPoint(4, 43))
        appleBody.addCurve(to: logoPoint(33, 54), control1: logoPoint(20, 50), control2: logoPoint(26, 60))
        appleBody.addCurve(to: logoPoint(56, 22), control1: logoPoint(45, 51), control2: logoPoint(53, 38))
        appleBody.addCurve(to: logoPoint(47, -15), control1: logoPoint(61, 5), control2: logoPoint(56, -8))
        appleBody.addCurve(to: logoPoint(23, -29), control1: logoPoint(40, -23), control2: logoPoint(32, -28))
        appleBody.addCurve(to: logoPoint(0, -37), control1: logoPoint(14, -31), control2: logoPoint(8, -31))
        appleBody.closeSubpath()

        var leaf = Path()
        leaf.move(to: logoPoint(8, -53))
        leaf.addCurve(to: logoPoint(41, -76), control1: logoPoint(15, -69), control2: logoPoint(28, -77))
        leaf.addCurve(to: logoPoint(32, -48), control1: logoPoint(43, -61), control2: logoPoint(38, -52))
        leaf.addCurve(to: logoPoint(8, -53), control1: logoPoint(23, -45), control2: logoPoint(14, -47))
        leaf.closeSubpath()

        context.fill(appleBody, with: .color(Color.black.opacity(0.23)))
        context.fill(leaf, with: .color(Color.black.opacity(0.23)))

        let biteCenter = project(ModelPoint(x: 24 * logoScale, z: -16 * logoScale), y: -0.8)
        context.fill(
            Path(ellipseIn: CGRect(x: biteCenter.x - 4.8, y: biteCenter.y - 4.8, width: 9.6, height: 9.6)),
            with: .color(Color(red: 0.91, green: 0.92, blue: 0.93).opacity(0.78))
        )
    }

    private func drawFaceDetails(in context: inout GraphicsContext) {
        drawFrontDetails(in: &context)
        drawBackDetails(in: &context)
    }

    private func drawFrontDetails(in context: inout GraphicsContext) {
        let facing = rotatedDepth(x: 0, z: 1)
        guard facing > 0.18 else { return }

        let left = project(ModelPoint(x: -width * 0.30, z: depth * 0.50), y: height * 0.72)
        let right = project(ModelPoint(x: width * 0.30, z: depth * 0.50), y: height * 0.72)
        var seam = Path()
        seam.move(to: left)
        seam.addQuadCurve(
            to: right,
            control: project(ModelPoint(x: 0, z: depth * 0.51), y: height * 0.82)
        )
        context.stroke(seam, with: .color(Color.black.opacity(0.12 * facing)), lineWidth: lineWidth(1.1))

        let ledCenter = project(ModelPoint(x: width * 0.34, z: depth * 0.50), y: height * 0.70)
        context.fill(
            Path(ellipseIn: CGRect(x: ledCenter.x - lineWidth(2.8), y: ledCenter.y - lineWidth(2.8), width: lineWidth(5.6), height: lineWidth(5.6))),
            with: .color(Color(red: 0.48, green: 0.84, blue: 0.55).opacity(0.95 * facing))
        )
    }

    private func drawBackDetails(in context: inout GraphicsContext) {
        let facing = rotatedDepth(x: 0, z: -1)
        guard facing > 0.20 else { return }

        let y = height * 0.62
        let z = -depth * 0.50
        let portXs: [CGFloat] = [-70, -48, -20, 8, 34, 58]

        for (index, x) in portXs.enumerated() {
            let center = project(ModelPoint(x: x, z: z), y: y)
            let portWidth = lineWidth(index < 2 ? 12 : 16)
            let portHeight = lineWidth(index < 2 ? 9 : 10)
            let rect = CGRect(
                x: center.x - portWidth * 0.5,
                y: center.y - portHeight * 0.5,
                width: portWidth,
                height: portHeight
            )
            let corner = lineWidth(index < 2 ? 2 : 3)
            context.fill(
                Path(roundedRect: rect, cornerRadius: corner),
                with: .color(Color.black.opacity(0.36 * facing))
            )
            context.stroke(
                Path(roundedRect: rect, cornerRadius: corner),
                with: .color(Color.white.opacity(0.16 * facing)),
                lineWidth: lineWidth(0.65)
            )
        }

        let power = project(ModelPoint(x: 82, z: z), y: y - 1)
        context.stroke(
            Path(ellipseIn: CGRect(x: power.x - lineWidth(5), y: power.y - lineWidth(5), width: lineWidth(10), height: lineWidth(10))),
            with: .color(Color.black.opacity(0.35 * facing)),
            lineWidth: lineWidth(1.4)
        )
    }

    private func path(for points: [ModelPoint], y: CGFloat) -> Path {
        var path = Path()
        guard let first = points.first else { return path }
        path.move(to: project(first, y: y))
        for point in points.dropFirst() {
            path.addLine(to: project(point, y: y))
        }
        path.closeSubpath()
        return path
    }

    private func superellipsePointSamples(count: Int, inset: CGFloat = 0) -> [ModelPoint] {
        let a = max(1, width * 0.5 - inset)
        let b = max(1, depth * 0.5 - inset)
        let exponent = 0.44

        return (0..<count).map { index in
            let t = CGFloat(index) / CGFloat(count) * .pi * 2
            let cosT = cos(t)
            let sinT = sin(t)
            let x = a * signedPower(cosT, exponent)
            let z = b * signedPower(sinT, exponent)
            return ModelPoint(x: x, z: z)
        }
    }

    private func signedPower(_ value: CGFloat, _ exponent: CGFloat) -> CGFloat {
        let sign: CGFloat = value >= 0 ? 1 : -1
        return sign * CGFloat(pow(Double(abs(value)), Double(exponent)))
    }

    private func project(_ point: ModelPoint, y: CGFloat) -> CGPoint {
        let radians = CGFloat(angle / 180 * .pi)
        let rotatedX = point.x * cos(radians) - point.z * sin(radians)
        let rotatedZ = point.x * sin(radians) + point.z * cos(radians)
        let scale = drawingScale

        return CGPoint(
            x: size.width * 0.5 + rotatedX * scale,
            y: size.height * 0.40 + y * scale + rotatedZ * tilt * scale
        )
    }

    private func rotatedDepth(x: CGFloat, z: CGFloat) -> CGFloat {
        let radians = CGFloat(angle / 180 * .pi)
        return x * sin(radians) + z * cos(radians)
    }

    private var drawingScale: CGFloat {
        min(size.width / 340, size.height / 240)
    }

    private func lineWidth(_ value: CGFloat) -> CGFloat {
        max(0.75, value * drawingScale)
    }
}

private struct ModelPoint {
    var x: CGFloat
    var z: CGFloat
}

private struct SideStrip {
    var path: Path
    var facing: CGFloat
    var depth: CGFloat
}

private struct AngleBadge: View {
    let angle: Double

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "arrow.triangle.2.circlepath")
            Text("\(Int(angle.rounded()))°")
                .monospacedDigit()
        }
        .font(.caption.weight(.semibold))
        .foregroundStyle(Color(red: 0.04, green: 0.48, blue: 0.47))
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(
            Capsule(style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
        )
    }
}

private struct StatusPill: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .foregroundStyle(Color(red: 0.04, green: 0.48, blue: 0.47))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule(style: .continuous)
                    .fill(Color(uiColor: .secondarySystemGroupedBackground))
            )
    }
}

private enum AnglePreset: CaseIterable, Identifiable {
    case front
    case right
    case back
    case left

    var id: Self { self }

    var title: String {
        switch self {
        case .front:
            return "正面"
        case .right:
            return "右侧"
        case .back:
            return "背面"
        case .left:
            return "左侧"
        }
    }

    var angle: Double {
        switch self {
        case .front:
            return 0
        case .right:
            return 90
        case .back:
            return 180
        case .left:
            return 270
        }
    }

    var symbol: String {
        switch self {
        case .front:
            return "rectangle"
        case .right:
            return "rectangle.lefthalf.inset.filled"
        case .back:
            return "rectangle.dashed"
        case .left:
            return "rectangle.righthalf.inset.filled"
        }
    }
}

private func normalizedAngle(_ value: Double) -> Double {
    let angle = value.truncatingRemainder(dividingBy: 360)
    return angle >= 0 ? angle : angle + 360
}

private func currentFace(for angle: Double) -> String {
    switch normalizedAngle(angle) {
    case 315..<360, 0..<45:
        return "正面"
    case 45..<135:
        return "右侧"
    case 135..<225:
        return "背面"
    default:
        return "左侧"
    }
}

private struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
