//
//  RadarView.swift
//  SwiftUIDemo
//
//  Created by 王 巍 on 2019/08/20.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import SwiftUI

struct RadarView: View {
    let values: [Int]
    let color: Color
    let max: Int
    let progress: CGFloat
    let shouldAnimate: Bool

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Hexagon(
                    values: Array(repeating: self.max, count: 6),
                    max: self.max,
                    progress: self.progress
                )
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [6,3]))
                    .foregroundColor(self.color.opacity(0.5))
                    .animation(self.shouldAnimate ? Animation.linear(duration: 1).delay(0.2) : nil)
                Hexagon(
                    values: self.values,
                    max: self.max,
                    progress: self.progress
                )
                    .fill(self.linearGradient)
                    .animation(self.shouldAnimate ? Animation.linear(duration: 1.5).delay(0.2) : nil)
            }
            .frame(
                width: min(proxy.size.width, proxy.size.height),
                height: min(proxy.size.width, proxy.size.height)
            )
        }
    }

    var linearGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [color, color.opacity(0.1)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing)
    }
}

struct Hexagon: Shape {

    let values: [Int]
    let max: Int
    var progress: CGFloat

    func path(in rect: CGRect) -> Path {
        Path { path in
            let points = self.points(in: rect)
            path.move(to: points.first!)
            for p in points.dropFirst() {
                path.addLine(to: p)
            }
            path.closeSubpath()
        }
        .trimmedPath(from: 0, to: progress)
    }

    var animatableData: CGFloat {
        set { progress = newValue }
        get { progress }
    }

    func points(in rect: CGRect) -> [CGPoint] {
        zip(
            self.values,
            [0, 60, 120, 180, 240, 300].map { Angle.degrees($0) }
        ).map {
            convert(value: $0.0, angle: $0.1, in: rect)
        }
    }

    func convert(value: Int, angle: Angle, in rect: CGRect) -> CGPoint {
        let x = 0.5 * rect.width * (1 + CGFloat(value) / CGFloat(max) * CGFloat(sin(angle.radians)))
        let y = 0.5 * rect.height * (1 - CGFloat(value) / CGFloat(max) * CGFloat(cos(angle.radians)))
        return .init(x: x, y: y)
    }
}

#if DEBUG
struct RadarView_Previews: PreviewProvider {
    static var previews: some View {
        RadarView(
            values: [165,129,148,176,152,140],
            color: .red,
            max: 200,
            progress: 1.0,
            shouldAnimate: true
        )
        .frame(width: 300, height: 200)
    }
}
#endif
