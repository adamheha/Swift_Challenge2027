import SwiftUI

struct OriginJourneyView: View {
    let onBeginJourney: () -> Void
    let onStartDemo: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var reveal = false

    private let beats = BloomMindJourney.originBeats()

    private var sceneHeight: CGFloat {
        dynamicTypeSize.isAccessibilitySize ? 320 : 260
    }

    var body: some View {
        VStack(spacing: 20) {
            OriginWeatherSceneView(
                beats: beats,
                reveal: reveal || reduceMotion
            )
            .frame(height: sceneHeight)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.green.opacity(0.22), lineWidth: 1)
            }
            .accessibilityHidden(true)

            VStack(spacing: 10) {
                Text("BloomMind")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)

                Text(CheckInState.openingOriginLine)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)

                Text("A private journey for turning one loud school-weather moment into a seed, a week, and a garden.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }

            LazyVGrid(columns: [GridItem(.adaptive(minimum: dynamicTypeSize.isAccessibilitySize ? 180 : 130), spacing: 10)], spacing: 10) {
                ForEach(beats) { beat in
                    OriginBeatCardView(beat: beat)
                }
            }

            ViewThatFits(in: .horizontal) {
                HStack(spacing: 10) {
                    originButtons
                }

                VStack(spacing: 10) {
                    originButtons
                }
            }
        }
        .bloomPage(maxWidth: 760, padding: 32)
        .onAppear {
            guard !reduceMotion else {
                reveal = true
                return
            }

            withAnimation(.spring(response: 0.8, dampingFraction: 0.84).delay(0.08)) {
                reveal = true
            }
        }
    }

    @ViewBuilder
    private var originButtons: some View {
        Button("Skip") {
            onBeginJourney()
        }
        .buttonStyle(.bordered)
        .controlSize(.large)
        .accessibilityHint("Skips the opening origin scene.")

        Button {
            onBeginJourney()
        } label: {
            Label("Begin Journey", systemImage: "sparkles")
                .font(.headline)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .accessibilityHint("Opens the Today screen.")

        Button {
            onStartDemo()
        } label: {
            Label("90-second Demo", systemImage: "play.rectangle")
                .font(.headline)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .controlSize(.large)
        .accessibilityHint("Opens the guided award demo path.")
    }
}

private struct OriginWeatherSceneView: View {
    let beats: [OriginSceneBeat]
    let reveal: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                drawScene(
                    in: &context,
                    size: size,
                    time: reduceMotion ? 0 : timeline.date.timeIntervalSinceReferenceDate
                )
            }
        }
        .background {
            LinearGradient(
                colors: [
                    Color.indigo.opacity(0.18),
                    Color.cyan.opacity(0.10),
                    Color.green.opacity(0.13)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    private func drawScene(
        in context: inout GraphicsContext,
        size: CGSize,
        time: TimeInterval
    ) {
        let width = max(size.width, 1)
        let height = max(size.height, 1)
        let center = CGPoint(x: width * 0.5, y: height * 0.46)
        let revealScale = reveal ? 1.0 : 0.001
        let pulse = CGFloat((sin(time * 0.9) + 1) / 2)
        let labels = ["exam", "club", "grade", "deadline", "message", "too much"]

        for index in labels.indices {
            let angle = (Double(index) / Double(labels.count)) * .pi * 2 + time * 0.16
            let radius = min(width, height) * (0.22 + CGFloat(index % 3) * 0.045) * revealScale
            let point = CGPoint(
                x: center.x + cos(angle) * radius,
                y: center.y + sin(angle) * radius * 0.68
            )
            let rect = CGRect(x: point.x - 35, y: point.y - 12, width: 70, height: 24)

            context.fill(
                Path(roundedRect: rect, cornerRadius: 7),
                with: .color(Color.white.opacity(0.56))
            )
            context.stroke(
                Path(roundedRect: rect, cornerRadius: 7),
                with: .color(Color.indigo.opacity(0.24)),
                lineWidth: 1
            )

            context.draw(
                Text(labels[index])
                    .font(.caption2.bold())
                    .foregroundStyle(Color.primary.opacity(0.76)),
                in: rect.insetBy(dx: 7, dy: 5)
            )
        }

        for ring in 0..<5 {
            let radius = min(width, height) * (0.14 + CGFloat(ring) * 0.055) * revealScale + pulse * 4
            context.stroke(
                Path(ellipseIn: CGRect(
                    x: center.x - radius,
                    y: center.y - radius,
                    width: radius * 2,
                    height: radius * 2
                )),
                with: .color(Color.blue.opacity(0.20 - Double(ring) * 0.025)),
                style: StrokeStyle(lineWidth: 1, lineCap: .round)
            )
        }

        let coreRadius = min(width, height) * 0.095 * revealScale
        let coreRect = CGRect(
            x: center.x - coreRadius,
            y: center.y - coreRadius,
            width: coreRadius * 2,
            height: coreRadius * 2
        )
        context.fill(
            Path(ellipseIn: coreRect),
            with: .radialGradient(
                Gradient(colors: [
                    Color.green.opacity(0.76),
                    Color.cyan.opacity(0.36),
                    Color.indigo.opacity(0.18)
                ]),
                center: center,
                startRadius: 2,
                endRadius: max(coreRadius, 1)
            )
        )

        let stem = Path { path in
            path.move(to: CGPoint(x: center.x, y: center.y + coreRadius * 0.65))
            path.addCurve(
                to: CGPoint(x: center.x, y: height * 0.78),
                control1: CGPoint(x: center.x - 14, y: center.y + 30),
                control2: CGPoint(x: center.x + 8, y: height * 0.66)
            )
        }
        context.stroke(
            stem,
            with: .color(Color.green.opacity(reveal ? 0.72 : 0)),
            style: StrokeStyle(lineWidth: 3, lineCap: .round)
        )

        context.draw(
            Text(BloomMindJourney.originLine)
                .font(.headline.bold())
                .foregroundStyle(Color.primary.opacity(reveal ? 0.88 : 0)),
            at: CGPoint(x: width * 0.5, y: height * 0.88),
            anchor: .center
        )
    }
}

private struct OriginBeatCardView: View {
    let beat: OriginSceneBeat

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Image(systemName: beat.symbolName)
                .font(.subheadline.bold())
                .foregroundStyle(.green)
                .accessibilityHidden(true)

            Text(beat.title)
                .font(.caption.bold())
                .fixedSize(horizontal: false, vertical: true)

            Text(beat.detail)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, minHeight: 96, alignment: .topLeading)
        .padding(10)
        .bloomCardBackground(tint: .green)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(beat.title)
        .accessibilityValue(beat.detail)
    }
}

struct OriginJourneyView_Previews: PreviewProvider {
    static var previews: some View {
        OriginJourneyView(
            onBeginJourney: {},
            onStartDemo: {}
        )
    }
}
