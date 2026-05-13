import SwiftUI

struct WeeklyBloomPayoffView: View {
    let payoff: WeeklyBloomPayoff
    let seeds: [GardenSeed]

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var reveal = false

    private var accentColor: Color {
        payoff.dominantMood?.tint ?? .green
    }

    private var sceneHeight: CGFloat {
        dynamicTypeSize.isAccessibilitySize ? 300 : 240
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header

            WeeklyBloomConstellationView(
                seeds: seeds,
                accentColor: accentColor,
                reveal: reveal || reduceMotion
            )
            .frame(height: sceneHeight)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(accentColor.opacity(0.34), lineWidth: 1)
            }

            WeeklyBloomTimeLapseView(
                seeds: seeds,
                tint: accentColor,
                reveal: reveal || reduceMotion
            )

            VStack(alignment: .leading, spacing: 10) {
                Text("Your week had a shape")
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)

                Text(payoff.story)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Divider()

            VStack(alignment: .leading, spacing: 12) {
                PayoffLineView(
                    title: "What the garden noticed",
                    systemImage: "lightbulb",
                    text: payoff.insight,
                    tint: accentColor
                )

                PayoffLineView(
                    title: payoff.literacyUnlock.title,
                    systemImage: "graduationcap",
                    text: payoff.literacyUnlock.detail,
                    tint: accentColor
                )

                PayoffLineView(
                    title: "Closing ritual",
                    systemImage: "quote.bubble",
                    text: payoff.closingLine,
                    tint: accentColor
                )

                PayoffLineView(
                    title: "Next week seed",
                    systemImage: "arrow.forward.circle",
                    text: payoff.nextWeekIntention,
                    tint: accentColor
                )
            }

            PressedBloomArchivePreviewView(
                seeds: seeds,
                tint: accentColor
            )

            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "lock.shield")
                    .font(.subheadline.bold())
                    .foregroundStyle(accentColor)
                    .accessibilityHidden(true)

                Text(payoff.privacyNote)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .bloomPanel(padding: 16)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(payoff.title)
        .accessibilityValue(payoff.accessibilityValue)
        .onAppear {
            guard !reduceMotion else {
                reveal = true
                return
            }

            withAnimation(.spring(response: 0.72, dampingFraction: 0.82).delay(0.08)) {
                reveal = true
            }
        }
        .onChange(of: seeds) { _, _ in
            guard !reduceMotion else {
                reveal = true
                return
            }

            reveal = false
            withAnimation(.spring(response: 0.72, dampingFraction: 0.82).delay(0.08)) {
                reveal = true
            }
        }
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(accentColor.opacity(0.16))

                Image(systemName: payoff.dominantLane?.symbolName ?? "sparkles")
                    .font(.title3.bold())
                    .foregroundStyle(accentColor)
                    .accessibilityHidden(true)
            }
            .frame(width: 50, height: 50)

            VStack(alignment: .leading, spacing: 4) {
                Text(payoff.title)
                    .font(.title2.bold())
                    .fixedSize(horizontal: false, vertical: true)

                Text(payoff.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .layoutPriority(1)

            Spacer(minLength: 0)
        }
    }
}

private struct WeeklyBloomTimeLapseView: View {
    let seeds: [GardenSeed]
    let tint: Color
    let reveal: Bool

    private var phases: [TimeLapsePhase] {
        [
            TimeLapsePhase(
                title: "Storm",
                detail: "The week began as moving pressure.",
                systemImage: "tornado",
                count: seeds.count
            ),
            TimeLapsePhase(
                title: "Seeds",
                detail: "\(seeds.count) moments were named.",
                systemImage: "circle.hexagongrid",
                count: seeds.count
            ),
            TimeLapsePhase(
                title: "World",
                detail: "\(laneSummary) shaped the garden.",
                systemImage: "map",
                count: seeds.count
            ),
            TimeLapsePhase(
                title: "Bloom",
                detail: "The week became one memory.",
                systemImage: "sparkles",
                count: seeds.count
            )
        ]
    }

    private var laneSummary: String {
        let roots = seeds.filter { $0.lane == .now }.count
        let buds = seeds.filter { $0.lane == .later }.count
        let air = seeds.filter { $0.lane == .release }.count
        return "\(roots) roots, \(buds) buds, \(air) winds"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Week time-lapse", systemImage: "timeline.selection")
                .font(.subheadline.bold())
                .foregroundStyle(tint)
                .fixedSize(horizontal: false, vertical: true)

            ViewThatFits(in: .horizontal) {
                HStack(spacing: 8) {
                    phaseCards
                }

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 128), spacing: 8)], spacing: 8) {
                    phaseCards
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Week time-lapse")
        .accessibilityValue(phases.map { "\($0.title): \($0.detail)" }.joined(separator: ". "))
    }

    @ViewBuilder
    private var phaseCards: some View {
        ForEach(Array(phases.enumerated()), id: \.offset) { index, phase in
            VStack(alignment: .leading, spacing: 7) {
                Image(systemName: phase.systemImage)
                    .font(.headline.bold())
                    .foregroundStyle(tint)
                    .accessibilityHidden(true)

                Text(phase.title)
                    .font(.caption.bold())
                    .foregroundStyle(.primary)

                Text(phase.detail)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
            .background(tint.opacity(reveal ? 0.10 + Double(index) * 0.018 : 0.04), in: RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(tint.opacity(reveal ? 0.22 : 0.08), lineWidth: 1)
            }
        }
    }
}

private struct TimeLapsePhase {
    let title: String
    let detail: String
    let systemImage: String
    let count: Int
}

private struct PayoffLineView: View {
    let title: String
    let systemImage: String
    let text: String
    let tint: Color

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: systemImage)
                .font(.subheadline.bold())
                .foregroundStyle(tint)
                .frame(width: 22)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline.bold())
                    .fixedSize(horizontal: false, vertical: true)

                Text(text)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .layoutPriority(1)
        }
    }
}

private struct PressedBloomArchivePreviewView: View {
    let seeds: [GardenSeed]
    let tint: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(tint.opacity(0.12))
                    .frame(width: 68, height: 82)

                ForEach(Array(seeds.prefix(7).enumerated()), id: \.offset) { index, seed in
                    Capsule()
                        .fill(seed.mood.tint.opacity(0.72))
                        .frame(width: 10, height: 28)
                        .rotationEffect(.degrees(Double(index) * 360 / Double(max(seeds.count, 1))))
                        .offset(y: -15)
                }

                Circle()
                    .fill(Color.white.opacity(0.68))
                    .frame(width: 14, height: 14)
            }
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 5) {
                Text("Past bloom preview")
                    .font(.subheadline.bold())
                    .fixedSize(horizontal: false, vertical: true)

                Text("At the end of a real week, this bloom can become a pressed flower in the archive instead of disappearing.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .layoutPriority(1)
        }
        .padding(12)
        .background(tint.opacity(0.09), in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(tint.opacity(0.18), lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Past bloom preview")
        .accessibilityValue("This completed bloom can become a pressed flower in the archive instead of disappearing.")
    }
}

private struct WeeklyBloomConstellationView: View {
    let seeds: [GardenSeed]
    let accentColor: Color
    let reveal: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                drawConstellation(
                    in: &context,
                    size: size,
                    time: reduceMotion ? 0 : timeline.date.timeIntervalSinceReferenceDate
                )
            }
        }
        .background {
            LinearGradient(
                colors: [
                    Color(red: 0.04, green: 0.09, blue: 0.12),
                    Color(red: 0.08, green: 0.12, blue: 0.20),
                    accentColor.opacity(0.22)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        .overlay(alignment: .bottomLeading) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Seven seeds, one bloom")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.45), radius: 5, x: 0, y: 2)

                Text("The week is remembered as growth, not private words.")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.78))
                    .fixedSize(horizontal: false, vertical: true)
                    .shadow(color: .black.opacity(0.4), radius: 4, x: 0, y: 2)
            }
            .padding(16)
        }
        .accessibilityHidden(true)
    }

    private func drawConstellation(
        in context: inout GraphicsContext,
        size: CGSize,
        time: TimeInterval
    ) {
        guard !seeds.isEmpty else {
            return
        }

        let width = max(size.width, 1)
        let height = max(size.height, 1)
        let center = CGPoint(x: width * 0.5, y: height * 0.48)
        let radiusX = width * 0.32
        let radiusY = height * 0.26
        let points = seeds.enumerated().map { index, seed in
            let progress = Double(index) / Double(max(seeds.count, 1))
            let angle = progress * Double.pi * 2 - Double.pi / 2
            let orbit = reduceMotion ? 0 : sin(time * 0.6 + Double(index)) * 4
            return WeeklyBloomPoint(
                seed: seed,
                position: CGPoint(
                    x: center.x + cos(angle) * radiusX,
                    y: center.y + sin(angle) * radiusY + orbit
                )
            )
        }

        var connection = Path()
        for (index, point) in points.enumerated() {
            if index == 0 {
                connection.move(to: point.position)
            } else {
                connection.addLine(to: point.position)
            }
        }
        if let first = points.first {
            connection.addLine(to: first.position)
        }

        context.stroke(
            connection,
            with: .color(Color.white.opacity(reveal ? 0.22 : 0.02)),
            style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round)
        )

        let centerGlowSize = min(width, height) * (reveal ? 0.34 : 0.12)
        context.fill(
            Path(ellipseIn: CGRect(
                x: center.x - centerGlowSize / 2,
                y: center.y - centerGlowSize / 2,
                width: centerGlowSize,
                height: centerGlowSize
            )),
            with: .color(accentColor.opacity(reveal ? 0.24 : 0.08))
        )

        drawCentralBloom(in: &context, center: center, size: min(width, height) * 0.18)

        for (index, point) in points.enumerated() {
            let delay = Double(index) * 0.05
            let localReveal = max(0, min(1, (reveal ? 1 : 0) - delay))
            drawSeedPoint(
                point,
                in: &context,
                localReveal: localReveal
            )
        }
    }

    private func drawCentralBloom(
        in context: inout GraphicsContext,
        center: CGPoint,
        size: CGFloat
    ) {
        let petalCount = 7
        for index in 0..<petalCount {
            var petal = Path()
            let angle = Double(index) / Double(petalCount) * Double.pi * 2
            let petalCenter = CGPoint(
                x: center.x + cos(angle) * size * 0.38,
                y: center.y + sin(angle) * size * 0.38
            )
            let rect = CGRect(
                x: petalCenter.x - size * 0.13,
                y: petalCenter.y - size * 0.28,
                width: size * 0.26,
                height: size * 0.56
            )
            petal.addEllipse(in: rect)
            context.fill(
                petal.rotation(.radians(angle), anchor: petalCenter),
                with: .color(accentColor.opacity(reveal ? 0.54 : 0.16))
            )
        }

        context.fill(
            Path(ellipseIn: CGRect(
                x: center.x - size * 0.18,
                y: center.y - size * 0.18,
                width: size * 0.36,
                height: size * 0.36
            )),
            with: .color(Color.white.opacity(reveal ? 0.72 : 0.20))
        )
    }

    private func drawSeedPoint(
        _ point: WeeklyBloomPoint,
        in context: inout GraphicsContext,
        localReveal: Double
    ) {
        let radius = CGFloat(8 + localReveal * 7)
        let mood = point.seed.mood

        context.fill(
            Path(ellipseIn: CGRect(
                x: point.position.x - radius,
                y: point.position.y - radius,
                width: radius * 2,
                height: radius * 2
            )),
            with: .color(mood.tint.opacity(0.42 + localReveal * 0.36))
        )

        context.stroke(
            Path(ellipseIn: CGRect(
                x: point.position.x - radius - 5,
                y: point.position.y - radius - 5,
                width: radius * 2 + 10,
                height: radius * 2 + 10
            )),
            with: .color(Color.white.opacity(0.10 + localReveal * 0.24)),
            lineWidth: 1
        )

        drawLaneMark(
            point.seed.lane,
            mood: mood,
            center: point.position,
            radius: radius,
            in: &context
        )
    }

    private func drawLaneMark(
        _ lane: GrowthLane,
        mood: Mood,
        center: CGPoint,
        radius: CGFloat,
        in context: inout GraphicsContext
    ) {
        switch lane {
        case .now:
            var root = Path()
            root.move(to: CGPoint(x: center.x, y: center.y + radius * 0.55))
            root.addQuadCurve(
                to: CGPoint(x: center.x - radius * 0.70, y: center.y + radius * 1.45),
                control: CGPoint(x: center.x - radius * 0.16, y: center.y + radius)
            )
            root.move(to: CGPoint(x: center.x, y: center.y + radius * 0.55))
            root.addQuadCurve(
                to: CGPoint(x: center.x + radius * 0.70, y: center.y + radius * 1.45),
                control: CGPoint(x: center.x + radius * 0.16, y: center.y + radius)
            )
            context.stroke(
                root,
                with: .color(mood.tint.opacity(0.42)),
                style: StrokeStyle(lineWidth: 1.4, lineCap: .round)
            )
        case .later:
            context.fill(
                Path(ellipseIn: CGRect(
                    x: center.x + radius * 0.44,
                    y: center.y - radius * 1.35,
                    width: radius * 0.78,
                    height: radius
                )),
                with: .color(mood.tint.opacity(0.38))
            )
        case .release:
            var wind = Path()
            wind.move(to: CGPoint(x: center.x - radius * 1.4, y: center.y - radius * 0.65))
            wind.addCurve(
                to: CGPoint(x: center.x + radius * 1.5, y: center.y - radius * 0.65),
                control1: CGPoint(x: center.x - radius * 0.5, y: center.y - radius * 1.20),
                control2: CGPoint(x: center.x + radius * 0.5, y: center.y - radius * 0.10)
            )
            context.stroke(
                wind,
                with: .color(mood.tint.opacity(0.42)),
                style: StrokeStyle(lineWidth: 1.3, lineCap: .round)
            )
        }
    }
}

private struct WeeklyBloomPoint {
    let seed: GardenSeed
    let position: CGPoint
}

private extension Path {
    func rotation(_ angle: Angle, anchor: CGPoint) -> Path {
        let transform = CGAffineTransform(translationX: anchor.x, y: anchor.y)
            .rotated(by: CGFloat(angle.radians))
            .translatedBy(x: -anchor.x, y: -anchor.y)
        return applying(transform)
    }
}

struct WeeklyBloomPayoffView_Previews: PreviewProvider {
    static var previews: some View {
        WeeklyBloomPayoffView(
            payoff: CheckInState().demoWeekPreviewState().weeklyBloomPayoff,
            seeds: CheckInState.demoGardenSeeds
        )
        .padding()
        .background(BloomBackground())
        .previewLayout(.fixed(width: 520, height: 720))
    }
}
