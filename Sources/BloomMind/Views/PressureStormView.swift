import SwiftUI

struct PressureStormView: View {
    let intensity: Double
    let resolvedMood: Mood?
    let showsLabels: Bool
    let liveKeywords: [String]
    let liveTheme: ReflectionTheme

    init(
        intensity: Double,
        resolvedMood: Mood?,
        showsLabels: Bool,
        liveKeywords: [String] = [],
        liveTheme: ReflectionTheme = .general
    ) {
        self.intensity = intensity
        self.resolvedMood = resolvedMood
        self.showsLabels = showsLabels
        self.liveKeywords = liveKeywords
        self.liveTheme = liveTheme
    }

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.colorScheme) private var colorScheme

    private var clampedIntensity: Double {
        let liveLift = min(Double(liveKeywords.count) * 0.035, 0.16)
        return min(max(intensity + liveLift, 0), 1)
    }

    private var isResolved: Bool {
        resolvedMood != nil
    }

    private var baseTint: Color {
        resolvedMood?.tint ?? liveTheme.stormTint
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
        .accessibilityValue(stormAccessibilityValue)
    }

    private var stormAccessibilityValue: String {
        if isResolved {
            return "The storm has become a mood-colored bloom."
        }

        guard !liveKeywords.isEmpty else {
            return "Thought fragments are moving around the center."
        }

        return "\(liveTheme.displayName) storm with live fragments: \(liveKeywords.joined(separator: ", "))."
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

        let particles = StormParticle.samples + StormParticle.liveSamples(for: liveKeywords, themeTint: liveTheme.stormTint)

        for particle in particles {
            let speed = particle.speed * (isResolved ? 0.22 : 1) * (0.78 + clampedIntensity * 0.42)
            let angle = particle.angle + (time * speed)
            let radius = shortestSide * particle.radius * resolvedPull
            let wave = sin((time * particle.waveSpeed * (0.8 + clampedIntensity * 0.5)) + particle.angle) * shortestSide * particle.wave
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
    let snapshot: WeatherObservatorySnapshot
    let seeds: [GardenSeed]

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var heroHeight: CGFloat {
        dynamicTypeSize.isAccessibilitySize ? 440 : 360
    }

    private var observatoryTint: Color {
        snapshot.dominantMood?.tint ?? latestMood?.tint ?? .green
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            PressureStormView(
                intensity: isCompleteToday ? 0.36 : 0.92,
                resolvedMood: isCompleteToday ? latestMood ?? .calm : nil,
                showsLabels: !isCompleteToday
            )

            WeatherObservatoryLensView(
                snapshot: snapshot,
                seeds: seeds,
                tint: observatoryTint
            )
            .padding(16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            .allowsHitTesting(false)

            VStack(alignment: .leading) {
                HStack {
                    Label("Inner weather observatory", systemImage: "sparkles")
                        .font(.caption.bold())
                        .foregroundStyle(.white.opacity(0.88))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 7)
                        .background(Color.white.opacity(0.14), in: Capsule())
                        .shadow(color: .black.opacity(0.30), radius: 4, x: 0, y: 2)

                    Spacer()
                }

                Spacer()
            }
            .padding(16)
            .allowsHitTesting(false)

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
                Text(snapshot.title)
                    .font(.caption.bold())
                    .foregroundStyle(observatoryTint.opacity(0.95))
                    .textCase(.uppercase)
                    .fixedSize(horizontal: false, vertical: true)

                Text(isCompleteToday ? "A seed is already growing." : "Turn the storm into weather.")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .shadow(color: .black.opacity(0.5), radius: 8, x: 0, y: 3)

                Text(snapshot.skyLine)
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.82))
                    .fixedSize(horizontal: false, vertical: true)

                Text(isCompleteToday ? "The garden remembers the shape, not the private words." : prompt)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.72))
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
        .accessibilityLabel(isCompleteToday ? "A seed is already growing" : "Weather Observatory")
        .accessibilityValue("\(snapshot.accessibilityValue) \(progressPercent) percent, \(completedCount) of \(goalCount) check-ins complete")
    }
}

private struct WeatherObservatoryLensView: View {
    let snapshot: WeatherObservatorySnapshot
    let seeds: [GardenSeed]
    let tint: Color

    var body: some View {
        VStack(alignment: .trailing, spacing: 10) {
            ObservatoryLensCanvasView(
                snapshot: snapshot,
                seeds: seeds,
                tint: tint
            )
            .frame(width: 156, height: 156)
            .accessibilityHidden(true)

            VStack(alignment: .trailing, spacing: 6) {
                Text(snapshot.detail)
                    .font(.caption.bold())
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.trailing)
                    .fixedSize(horizontal: false, vertical: true)

                Text(snapshot.lensLine)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(.white.opacity(0.76))
                    .multilineTextAlignment(.trailing)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)

                WeatherLayerRackView(
                    layers: snapshot.pressureLayers,
                    tint: tint
                )
            }
            .frame(maxWidth: 230, alignment: .trailing)
            .padding(10)
            .background(Color.black.opacity(0.30), in: RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white.opacity(0.18), lineWidth: 1)
            }
        }
    }
}

private struct ObservatoryLensCanvasView: View {
    let snapshot: WeatherObservatorySnapshot
    let seeds: [GardenSeed]
    let tint: Color

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                drawLens(
                    in: &context,
                    size: size,
                    time: reduceMotion ? 0 : timeline.date.timeIntervalSinceReferenceDate
                )
            }
        }
    }

    private func drawLens(
        in context: inout GraphicsContext,
        size: CGSize,
        time: TimeInterval
    ) {
        let width = max(size.width, 1)
        let height = max(size.height, 1)
        let center = CGPoint(x: width * 0.5, y: height * 0.5)
        let radius = min(width, height) * 0.42
        let pulse = CGFloat((sin(time * 0.8) + 1) / 2)
        let lensRect = CGRect(
            x: center.x - radius,
            y: center.y - radius,
            width: radius * 2,
            height: radius * 2
        )

        context.fill(
            Path(ellipseIn: lensRect),
            with: .radialGradient(
                Gradient(colors: [
                    tint.opacity(0.34 + pulse * 0.08),
                    Color.white.opacity(0.12),
                    Color.black.opacity(0.18)
                ]),
                center: center,
                startRadius: 4,
                endRadius: radius
            )
        )

        for ring in 0..<3 {
            let inset = CGFloat(ring) * 18
            context.stroke(
                Path(ellipseIn: lensRect.insetBy(dx: inset, dy: inset)),
                with: .color(Color.white.opacity(0.24 - Double(ring) * 0.04)),
                style: StrokeStyle(lineWidth: ring == 0 ? 2.2 : 1.1, lineCap: .round)
            )
        }

        let layerCount = max(snapshot.pressureLayers.count, 1)
        for index in 0..<layerCount {
            let angle = (Double(index) / Double(layerCount)) * .pi * 2 + time * 0.08
            let end = CGPoint(
                x: center.x + cos(angle) * radius * 0.86,
                y: center.y + sin(angle) * radius * 0.86
            )
            var spoke = Path()
            spoke.move(to: center)
            spoke.addLine(to: end)
            context.stroke(
                spoke,
                with: .color(Color.white.opacity(0.12)),
                style: StrokeStyle(lineWidth: 1, lineCap: .round)
            )
        }

        for (index, seed) in seeds.prefix(7).enumerated() {
            let seedCount = Double(max(seeds.count, 1))
            let orbitIndex = Double(index)
            let orbitOffset = time * 0.04
            let angle = (orbitIndex / seedCount) * Double.pi * 2 - Double.pi / 2 + orbitOffset
            let radiusStep = CGFloat(index % 3) * 0.12
            let pointRadius = radius * (0.46 + radiusStep)
            let point = CGPoint(
                x: center.x + cos(angle) * pointRadius,
                y: center.y + sin(angle) * pointRadius
            )
            let dotSize = CGFloat(8 + index % 3 * 2)
            context.fill(
                Path(ellipseIn: CGRect(
                    x: point.x - dotSize / 2,
                    y: point.y - dotSize / 2,
                    width: dotSize,
                    height: dotSize
                )),
                with: .color(seed.mood.tint.opacity(0.86))
            )
        }

        context.fill(
            Path(ellipseIn: CGRect(x: center.x - 11, y: center.y - 11, width: 22, height: 22)),
            with: .color(tint.opacity(0.88))
        )
        context.stroke(
            Path(ellipseIn: CGRect(x: center.x - 18, y: center.y - 18, width: 36, height: 36)),
            with: .color(Color.white.opacity(0.34)),
            lineWidth: 1.2
        )
    }
}

private struct WeatherLayerRackView: View {
    let layers: [PressureLayer]
    let tint: Color

    var body: some View {
        HStack(spacing: 5) {
            ForEach(layers.prefix(4)) { layer in
                Image(systemName: layer.symbolName)
                    .font(.caption2.bold())
                    .foregroundStyle(.white)
                    .frame(width: 24, height: 24)
                    .background(tint.opacity(0.32), in: Circle())
                    .accessibilityLabel(layer.title)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Pressure layers")
        .accessibilityValue(layers.map(\.title).joined(separator: ", "))
    }
}

struct CheckInStormPreviewView: View {
    let selectedMood: Mood?
    let reflectionText: String

    private var profile: LiveStormProfile {
        LocalActionEngine.liveStormProfile(
            selectedMood: selectedMood,
            reflectionText: reflectionText,
            characterLimit: CheckInState.reflectionCharacterLimit
        )
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            PressureStormView(
                intensity: profile.intensity,
                resolvedMood: selectedMood,
                showsLabels: true,
                liveKeywords: profile.keywords,
                liveTheme: profile.theme
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

                Text(profile.caption)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.82))
                    .fixedSize(horizontal: false, vertical: true)

                LiveStormWordRowView(
                    keywords: profile.keywords,
                    tint: selectedMood?.tint ?? profile.theme.stormTint
                )
            }
            .padding(16)
        }
        .frame(minHeight: 190)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(selectedMood == nil ? "Name the weather" : "\(selectedMood?.rawValue ?? "Mood") found")
        .accessibilityValue(profile.accessibilityValue)
    }
}

private struct LiveStormWordRowView: View {
    let keywords: [String]
    let tint: Color

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 7) {
                chips
            }

            VStack(alignment: .leading, spacing: 6) {
                chips
            }
        }
        .accessibilityHidden(true)
    }

    @ViewBuilder
    private var chips: some View {
        ForEach(Array(keywords.prefix(4).enumerated()), id: \.offset) { _, keyword in
            Text(keyword)
                .font(.caption2.bold())
                .foregroundStyle(.white)
                .lineLimit(1)
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background(tint.opacity(0.42), in: Capsule())
                .overlay {
                    Capsule()
                        .stroke(Color.white.opacity(0.18), lineWidth: 1)
                }
        }
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

    static func liveSamples(for keywords: [String], themeTint: Color) -> [StormParticle] {
        keywords.prefix(5).enumerated().map { index, keyword in
            let indexDouble = Double(index)
            return StormParticle(
                label: keyword,
                angle: 0.65 + indexDouble * 1.17,
                radius: 0.23 + CGFloat(index % 3) * 0.075,
                size: 0.020 + CGFloat(index % 2) * 0.006,
                speed: (index.isMultiple(of: 2) ? 0.70 : -0.64) + indexDouble * 0.035,
                wave: 0.026 + CGFloat(index % 2) * 0.006,
                waveSpeed: 1.15 + indexDouble * 0.16,
                opacity: 0.78,
                color: themeTint.opacity(0.95),
                labelOffset: CGSize(
                    width: index.isMultiple(of: 2) ? 16 : -32,
                    height: index.isMultiple(of: 2) ? -16 : 17
                )
            )
        }
    }
}

private extension ReflectionTheme {
    var stormTint: Color {
        switch self {
        case .school:
            Color(red: 0.42, green: 0.72, blue: 1.00)
        case .friendship:
            Color(red: 0.88, green: 0.50, blue: 0.86)
        case .rest:
            Color(red: 0.42, green: 0.60, blue: 1.00)
        case .pressure:
            Color(red: 1.00, green: 0.48, blue: 0.22)
        case .uncertainty:
            Color(red: 0.70, green: 0.54, blue: 1.00)
        case .general:
            Color(red: 0.15, green: 0.72, blue: 0.88)
        }
    }
}
