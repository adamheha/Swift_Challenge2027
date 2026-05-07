import SwiftUI

struct PressureStormView: View {
    let intensity: Double
    let resolvedMood: Mood?
    let showsLabels: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.colorScheme) private var colorScheme

    private var clampedIntensity: Double {
        min(max(intensity, 0), 1)
    }

    private var isResolved: Bool {
        resolvedMood != nil
    }

    private var baseTint: Color {
        resolvedMood?.tint ?? Color(red: 0.15, green: 0.72, blue: 0.88)
    }

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                drawStorm(
                    in: &context,
                    size: size,
                    time: reduceMotion ? 0 : timeline.date.timeIntervalSinceReferenceDate
                )
            }
        }
        .background {
            LinearGradient(
                colors: backgroundColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(isResolved ? "Resolved pressure storm" : "Pressure storm")
        .accessibilityValue(isResolved ? "The storm has become a mood-colored bloom." : "Thought fragments are moving around the center.")
    }

    private var backgroundColors: [Color] {
        if colorScheme == .dark {
            return [
                Color(red: 0.03, green: 0.06, blue: 0.09),
                Color(red: 0.08, green: 0.10, blue: 0.17),
                Color(red: 0.02, green: 0.12, blue: 0.11)
            ]
        }

        return [
            Color(red: 0.06, green: 0.10, blue: 0.14),
            Color(red: 0.09, green: 0.13, blue: 0.23),
            Color(red: 0.04, green: 0.19, blue: 0.17)
        ]
    }

    private func drawStorm(
        in context: inout GraphicsContext,
        size: CGSize,
        time: TimeInterval
    ) {
        let center = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        let shortestSide = max(min(size.width, size.height), 1)
        let resolvedPull = isResolved ? 0.34 : 1
        let labelSize = max(11, min(15, size.width / 34))

        drawCenterGlow(in: &context, center: center, shortestSide: shortestSide)
        drawOrbitTrails(in: &context, center: center, shortestSide: shortestSide, time: time)

        for particle in StormParticle.samples {
            let speed = particle.speed * (isResolved ? 0.22 : 1)
            let angle = particle.angle + (time * speed)
            let radius = shortestSide * particle.radius * resolvedPull
            let wave = sin((time * particle.waveSpeed) + particle.angle) * shortestSide * particle.wave
            let point = CGPoint(
                x: center.x + cos(angle) * radius + cos(angle * 0.5) * wave,
                y: center.y + sin(angle) * radius + sin(angle * 0.7) * wave
            )
            let color = isResolved ? baseTint : particle.color
            let opacity = particle.opacity * (0.24 + clampedIntensity * 0.76)
            let dotSize = shortestSide * particle.size * (isResolved ? 0.72 : 1)

            context.fill(
                Path(ellipseIn: CGRect(
                    x: point.x - dotSize / 2,
                    y: point.y - dotSize / 2,
                    width: dotSize,
                    height: dotSize
                )),
                with: .color(color.opacity(opacity))
            )

            guard showsLabels, size.width >= 260 else {
                continue
            }

            var labelContext = context
            labelContext.opacity = isResolved ? 0.32 : opacity
            labelContext.draw(
                Text(particle.label)
                    .font(.system(size: labelSize, weight: .semibold, design: .rounded))
                    .foregroundStyle(color.opacity(isResolved ? 0.72 : 0.9)),
                at: CGPoint(x: point.x + particle.labelOffset.width, y: point.y + particle.labelOffset.height)
            )
        }

        drawSeed(in: &context, center: center, shortestSide: shortestSide)
    }

    private func drawCenterGlow(
        in context: inout GraphicsContext,
        center: CGPoint,
        shortestSide: CGFloat
    ) {
        let glowSize = shortestSide * (isResolved ? 0.64 : 0.48)
        let glowRect = CGRect(
            x: center.x - glowSize / 2,
            y: center.y - glowSize / 2,
            width: glowSize,
            height: glowSize
        )

        context.fill(
            Path(ellipseIn: glowRect),
            with: .color(baseTint.opacity(isResolved ? 0.26 : 0.14))
        )
    }

    private func drawOrbitTrails(
        in context: inout GraphicsContext,
        center: CGPoint,
        shortestSide: CGFloat,
        time: TimeInterval
    ) {
        let trailColors = [
            Color(red: 0.35, green: 0.86, blue: 1.00),
            Color(red: 1.00, green: 0.62, blue: 0.20),
            Color(red: 0.80, green: 0.55, blue: 1.00)
        ]

        for index in trailColors.indices {
            var path = Path()
            let direction = index.isMultiple(of: 2) ? 1.0 : -1.0
            let phase = time * (isResolved ? 0.12 : 0.42) * direction + Double(index) * 0.7
            let baseRadius = shortestSide * (isResolved ? 0.16 + CGFloat(index) * 0.036 : 0.25 + CGFloat(index) * 0.08)
            let opacity = isResolved ? 0.16 : 0.13 + clampedIntensity * 0.18

            for step in 0...116 {
                let progress = Double(step) / 116
                let angle = progress * Double.pi * 2 + phase
                let ripple = sin(progress * Double.pi * 6 + time + Double(index)) * shortestSide * (isResolved ? 0.004 : 0.014)
                let radius = baseRadius + ripple
                let point = CGPoint(
                    x: center.x + cos(angle) * radius,
                    y: center.y + sin(angle) * radius * 0.72
                )

                if step == 0 {
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }
            }

            context.stroke(
                path,
                with: .color((isResolved ? baseTint : trailColors[index]).opacity(opacity)),
                style: StrokeStyle(
                    lineWidth: isResolved ? 1.4 : 1.7,
                    lineCap: .round,
                    lineJoin: .round,
                    dash: isResolved ? [6, 16] : [10, 14]
                )
            )
        }
    }

    private func drawSeed(
        in context: inout GraphicsContext,
        center: CGPoint,
        shortestSide: CGFloat
    ) {
        let seedSize = shortestSide * (isResolved ? 0.20 : 0.13)
        let seedRect = CGRect(
            x: center.x - seedSize / 2,
            y: center.y - seedSize / 2,
            width: seedSize,
            height: seedSize
        )

        context.fill(
            Path(ellipseIn: seedRect),
            with: .color(baseTint.opacity(isResolved ? 0.92 : 0.52))
        )

        context.stroke(
            Path(ellipseIn: seedRect.insetBy(dx: -6, dy: -6)),
            with: .color(Color.white.opacity(isResolved ? 0.42 : 0.2)),
            lineWidth: 1.4
        )
    }
}

struct StormToBloomHeroView: View {
    let isCompleteToday: Bool
    let latestMood: Mood?
    let progressPercent: Int
    let completedCount: Int
    let goalCount: Int
    let prompt: String

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var heroHeight: CGFloat {
        dynamicTypeSize.isAccessibilitySize ? 360 : 300
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            PressureStormView(
                intensity: isCompleteToday ? 0.36 : 0.92,
                resolvedMood: isCompleteToday ? latestMood ?? .calm : nil,
                showsLabels: !isCompleteToday
            )

            LinearGradient(
                colors: [
                    Color.black.opacity(0.78),
                    Color.black.opacity(0.24),
                    Color.black.opacity(0.02)
                ],
                startPoint: .bottom,
                endPoint: .top
            )
            .allowsHitTesting(false)

            VStack(alignment: .leading, spacing: 12) {
                Text(isCompleteToday ? "A seed is already growing." : "Turn the storm into a seed.")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .shadow(color: .black.opacity(0.5), radius: 8, x: 0, y: 3)

                Text(prompt)
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.82))
                    .fixedSize(horizontal: false, vertical: true)

                HStack(spacing: 10) {
                    Label("\(progressPercent)%", systemImage: "camera.macro")
                    Text("\(completedCount)/\(goalCount)")
                }
                .font(.caption.bold())
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(Color.white.opacity(0.16), in: Capsule())
            }
            .padding(22)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: heroHeight)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.white.opacity(0.18), lineWidth: 1)
        }
        .shadow(color: Color.black.opacity(0.18), radius: 22, x: 0, y: 14)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(isCompleteToday ? "A seed is already growing" : "Turn the storm into a seed")
        .accessibilityValue("\(progressPercent) percent, \(completedCount) of \(goalCount) check-ins complete")
    }
}

struct CheckInStormPreviewView: View {
    let selectedMood: Mood?
    let reflectionText: String

    private var intensity: Double {
        let reflectionProgress = min(Double(reflectionText.count) / Double(CheckInState.reflectionCharacterLimit), 1)
        let selectedMoodRelief = selectedMood == nil ? 0 : 0.22
        return max(0.28, 0.9 - reflectionProgress * 0.34 - selectedMoodRelief)
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            PressureStormView(
                intensity: intensity,
                resolvedMood: selectedMood,
                showsLabels: selectedMood == nil
            )

            LinearGradient(
                colors: [
                    Color.black.opacity(0.74),
                    Color.black.opacity(0.18),
                    Color.black.opacity(0.02)
                ],
                startPoint: .bottom,
                endPoint: .top
            )
            .allowsHitTesting(false)

            VStack(alignment: .leading, spacing: 6) {
                Text(selectedMood == nil ? "Name the weather." : "\(selectedMood?.rawValue ?? "Mood") found.")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.45), radius: 6, x: 0, y: 2)

                Text(selectedMood == nil ? "Tap the closest mood, then give one sentence to the storm." : "The storm is already starting to gather into one seed.")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.82))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(16)
        }
        .frame(minHeight: 190)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(selectedMood == nil ? "Name the weather" : "\(selectedMood?.rawValue ?? "Mood") found")
    }
}

private struct StormParticle {
    let label: String
    let angle: Double
    let radius: CGFloat
    let size: CGFloat
    let speed: Double
    let wave: CGFloat
    let waveSpeed: Double
    let opacity: Double
    let color: Color
    let labelOffset: CGSize

    static let samples: [StormParticle] = [
        StormParticle(label: "deadline", angle: 0.2, radius: 0.38, size: 0.026, speed: 0.52, wave: 0.025, waveSpeed: 1.5, opacity: 0.78, color: Color(red: 1.00, green: 0.62, blue: 0.20), labelOffset: CGSize(width: 18, height: -10)),
        StormParticle(label: "grades", angle: 1.0, radius: 0.42, size: 0.019, speed: -0.44, wave: 0.020, waveSpeed: 1.1, opacity: 0.64, color: Color(red: 0.52, green: 0.75, blue: 1.00), labelOffset: CGSize(width: -28, height: -18)),
        StormParticle(label: "messages", angle: 2.0, radius: 0.30, size: 0.022, speed: 0.62, wave: 0.026, waveSpeed: 1.7, opacity: 0.70, color: Color(red: 0.80, green: 0.55, blue: 1.00), labelOffset: CGSize(width: -18, height: 18)),
        StormParticle(label: "what if", angle: 2.8, radius: 0.46, size: 0.017, speed: -0.58, wave: 0.018, waveSpeed: 1.2, opacity: 0.62, color: Color(red: 0.55, green: 0.95, blue: 0.78), labelOffset: CGSize(width: 14, height: 12)),
        StormParticle(label: "too much", angle: 3.6, radius: 0.34, size: 0.030, speed: 0.46, wave: 0.030, waveSpeed: 1.4, opacity: 0.82, color: Color(red: 1.00, green: 0.43, blue: 0.46), labelOffset: CGSize(width: -34, height: -14)),
        StormParticle(label: "practice", angle: 4.4, radius: 0.40, size: 0.018, speed: -0.50, wave: 0.020, waveSpeed: 1.8, opacity: 0.60, color: Color(red: 1.00, green: 0.86, blue: 0.35), labelOffset: CGSize(width: 18, height: 10)),
        StormParticle(label: "future", angle: 5.2, radius: 0.26, size: 0.023, speed: 0.72, wave: 0.024, waveSpeed: 1.6, opacity: 0.72, color: Color(red: 0.35, green: 0.86, blue: 1.00), labelOffset: CGSize(width: -24, height: 15)),
        StormParticle(label: "finish", angle: 5.9, radius: 0.44, size: 0.020, speed: -0.38, wave: 0.016, waveSpeed: 1.0, opacity: 0.64, color: Color(red: 0.68, green: 1.00, blue: 0.48), labelOffset: CGSize(width: 12, height: -18))
    ]
}
