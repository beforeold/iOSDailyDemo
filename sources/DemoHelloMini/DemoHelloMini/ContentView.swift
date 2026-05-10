//
//  ContentView.swift
//  DemoHelloMini
//
//  Created by yojee on 5/9/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 28) {
            MacMiniDrawing()
                .frame(width: 300, height: 210)
                .accessibilityLabel("A drawn image of a Mac mini")

            Text("Hello, Mac mini!")
                .font(.title.bold())
                .foregroundStyle(.primary)
        }
        .padding(36)
    }
}

struct MacMiniDrawing: View {
    var body: some View {
        Canvas { context, size in
            let canvasSize = CGSize(width: 320, height: 220)
            let scale = min(size.width / canvasSize.width, size.height / canvasSize.height)
            let origin = CGPoint(
                x: (size.width - canvasSize.width * scale) / 2,
                y: (size.height - canvasSize.height * scale) / 2
            )

            func point(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
                CGPoint(x: origin.x + x * scale, y: origin.y + y * scale)
            }

            func rect(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
                CGRect(
                    x: origin.x + x * scale,
                    y: origin.y + y * scale,
                    width: width * scale,
                    height: height * scale
                )
            }

            func roundedRect(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat, _ radius: CGFloat) -> Path {
                Path(roundedRect: rect(x, y, width, height), cornerRadius: radius * scale)
            }

            let shadow = Path(ellipseIn: rect(52, 162, 216, 30))
            context.fill(
                shadow,
                with: .radialGradient(
                    Gradient(colors: [
                        Color.black.opacity(0.22),
                        Color.black.opacity(0.03)
                    ]),
                    center: point(160, 178),
                    startRadius: 6 * scale,
                    endRadius: 112 * scale
                )
            )

            let body = roundedRect(40, 48, 240, 126, 30)
            context.fill(
                body,
                with: .linearGradient(
                    Gradient(colors: [
                        Color(red: 0.96, green: 0.97, blue: 0.97),
                        Color(red: 0.77, green: 0.79, blue: 0.81)
                    ]),
                    startPoint: point(64, 56),
                    endPoint: point(252, 174)
                )
            )

            let topHighlight = roundedRect(52, 58, 216, 82, 24)
            context.fill(
                topHighlight,
                with: .linearGradient(
                    Gradient(colors: [
                        Color.white.opacity(0.66),
                        Color.white.opacity(0.10)
                    ]),
                    startPoint: point(70, 58),
                    endPoint: point(250, 144)
                )
            )

            let frontFace = roundedRect(48, 114, 224, 54, 20)
            context.fill(
                frontFace,
                with: .linearGradient(
                    Gradient(colors: [
                        Color.white.opacity(0.08),
                        Color.black.opacity(0.10)
                    ]),
                    startPoint: point(160, 112),
                    endPoint: point(160, 174)
                )
            )

            var frontLine = Path()
            frontLine.move(to: point(70, 151))
            frontLine.addQuadCurve(to: point(250, 151), control: point(160, 158))
            context.stroke(frontLine, with: .color(Color.black.opacity(0.12)), lineWidth: 1.2 * scale)

            context.fill(
                Path(ellipseIn: rect(237, 145, 5, 5)),
                with: .color(Color(red: 0.45, green: 0.80, blue: 0.55).opacity(0.92))
            )

            context.stroke(
                body,
                with: .linearGradient(
                    Gradient(colors: [
                        Color.white.opacity(0.72),
                        Color.black.opacity(0.18)
                    ]),
                    startPoint: point(58, 52),
                    endPoint: point(270, 176)
                ),
                lineWidth: 1.4 * scale
            )

            let logoColor = Color(red: 0.33, green: 0.34, blue: 0.36).opacity(0.34)
            var appleBody = Path()
            appleBody.move(to: point(160, 88))
            appleBody.addCurve(to: point(147, 83), control1: point(156, 84), control2: point(151, 82))
            appleBody.addCurve(to: point(134, 93), control1: point(141, 84), control2: point(136, 88))
            appleBody.addCurve(to: point(133, 118), control1: point(128, 101), control2: point(129, 111))
            appleBody.addCurve(to: point(144, 134), control1: point(137, 127), control2: point(140, 132))
            appleBody.addCurve(to: point(154, 131), control1: point(148, 137), control2: point(151, 132))
            appleBody.addCurve(to: point(166, 131), control1: point(158, 128), control2: point(162, 128))
            appleBody.addCurve(to: point(176, 134), control1: point(170, 132), control2: point(172, 137))
            appleBody.addCurve(to: point(188, 118), control1: point(181, 132), control2: point(186, 126))
            appleBody.addCurve(to: point(183, 100), control1: point(191, 110), control2: point(188, 104))
            appleBody.addCurve(to: point(171, 93), control1: point(180, 97), control2: point(175, 94))
            appleBody.addCurve(to: point(160, 88), control1: point(167, 92), control2: point(164, 91))
            appleBody.closeSubpath()
            context.fill(appleBody, with: .color(logoColor))

            var leaf = Path()
            leaf.move(to: point(164, 80))
            leaf.addCurve(to: point(181, 69), control1: point(167, 72), control2: point(174, 68))
            leaf.addCurve(to: point(176, 84), control1: point(181, 77), control2: point(178, 82))
            leaf.addCurve(to: point(164, 80), control1: point(172, 85), control2: point(167, 83))
            leaf.closeSubpath()
            context.fill(leaf, with: .color(logoColor))

            let bite = Path(ellipseIn: rect(178, 97, 12, 12))
            context.fill(bite, with: .color(Color(red: 0.88, green: 0.89, blue: 0.90).opacity(0.72)))
        }
        .aspectRatio(320.0 / 220.0, contentMode: .fit)
    }
}

#Preview {
    ContentView()
}
