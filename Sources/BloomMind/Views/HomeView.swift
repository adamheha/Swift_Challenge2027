import SwiftUI

struct HomeView: View {
    @Binding var checkInState: CheckInState
    let onStartCheckIn: () -> Void

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var isPreviewingDemoWeek = false
    @State private var isSoundscapeEnabled = false

    private var pageSpacing: CGFloat {
        dynamicTypeSize.isAccessibilitySize ? 22 : 24
    }

    private var gardenDisplayState: CheckInState {
        isPreviewingDemoWeek ? checkInState.demoWeekPreviewState() : checkInState
    }

    var body: some View {
        ViewThatFits(in: .horizontal) {
            wideLayout
            compactLayout
        }
        .bloomPage(maxWidth: 980, padding: 32)
        .navigationTitle("Today")
        .onChange(of: checkInState.completedCheckIns) { _, _ in
            isPreviewingDemoWeek = false
        }
        .onChange(of: checkInState.gardenMoods) { _, _ in
            isPreviewingDemoWeek = false
        }
        .onChange(of: checkInState.gardenSeeds) { _, _ in
            isPreviewingDemoWeek = false
        }
    }

    private var wideLayout: some View {
        HStack(alignment: .top, spacing: 24) {
            VStack(spacing: pageSpacing) {
                heroSection
                sensorySection
                dailyActionSection
            }
            .frame(minWidth: 360, maxWidth: 450)

            VStack(spacing: pageSpacing) {
                gardenSection
            }
            .frame(minWidth: 420, maxWidth: 520)
        }
    }

    private var compactLayout: some View {
        VStack(spacing: pageSpacing) {
            heroSection
            sensorySection
            gardenSection
            dailyActionSection
        }
    }

    private var heroSection: some View {
        StormToBloomHeroView(
            isCompleteToday: checkInState.hasCompletedCheckInToday(),
            latestMood: gardenDisplayState.gardenMoodsThisWeek.last,
            progressPercent: gardenDisplayState.bloomProgressPercent,
            completedCount: gardenDisplayState.completedCheckInsThisWeek,
            goalCount: CheckInState.weeklyCheckInGoal,
            prompt: checkInState.todayPrompt,
            snapshot: gardenDisplayState.weatherObservatorySnapshot,
            seeds: gardenDisplayState.gardenSeedsThisWeek
        )
    }

    private var sensorySection: some View {
        VStack(spacing: 12) {
            WeatherInstrumentPanelView(
                readings: SensoryObservatory.weatherInstruments(
                    for: gardenDisplayState.gardenSeedsThisWeek,
                    completedCount: gardenDisplayState.completedCheckInsThisWeek,
                    totalCount: CheckInState.weeklyCheckInGoal
                ),
                tint: gardenDisplayState.gardenSeedsThisWeek.last?.mood.tint ?? .green
            )

            SoundscapeConsoleView(
                profile: SensoryObservatory.soundscape(for: gardenDisplayState.gardenSeedsThisWeek),
                tint: gardenDisplayState.gardenSeedsThisWeek.last?.mood.tint ?? .green,
                isEnabled: $isSoundscapeEnabled
            )
        }
    }

    private var gardenSection: some View {
        VStack(spacing: pageSpacing) {
            EmotionGardenView(
                title: CheckInState.gardenPreviewTitle,
                seeds: gardenDisplayState.gardenSeedsThisWeek,
                totalPlots: CheckInState.weeklyCheckInGoal,
                progressText: gardenDisplayState.gardenProgressText,
                accessibilityValue: gardenDisplayState.gardenAccessibilityValue
            )

            if gardenDisplayState.isWeeklyBloomUnlocked {
                WeeklyBloomPayoffView(
                    payoff: gardenDisplayState.weeklyBloomPayoff,
                    seeds: gardenDisplayState.gardenSeedsThisWeek
                )
            }

            WeekReviewCardView(review: gardenDisplayState.weeklyReview)
        }
    }

    private var dailyActionSection: some View {
        VStack(spacing: pageSpacing) {
            TodayStatusView(
                isComplete: checkInState.hasCompletedCheckInToday(),
                title: checkInState.todayStatusTitle,
                detail: checkInState.todayStatusDetail
            )

            OriginLineView()

            if !gardenDisplayState.gardenSeedsThisWeek.isEmpty {
                TomorrowSeedCardView(
                    prompt: gardenDisplayState.returnTomorrowPrompt,
                    tint: gardenDisplayState.gardenSeedsThisWeek.last?.mood.tint ?? .green
                )
            }

            if isPreviewingDemoWeek {
                DemoPreviewNoticeView()

                AwardDemoTheatreView(
                    tint: gardenDisplayState.weeklyBloomPayoff.dominantMood?.tint ?? .green
                )
            }

            primaryActionButton
            demoWeekButton
        }
    }

    private var primaryActionButton: some View {
        Button {
            isPreviewingDemoWeek = false
            onStartCheckIn()
        } label: {
            Label(
                checkInState.primaryActionTitle,
                systemImage: "sparkles"
            )
                .font(.headline)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .accessibilityHint(checkInState.primaryActionAccessibilityHint)
    }

    private var demoWeekButton: some View {
        Button {
            withAnimation(.spring(response: 0.42, dampingFraction: 0.82)) {
                isPreviewingDemoWeek.toggle()
            }
        } label: {
            Label(
                isPreviewingDemoWeek ? CheckInState.showMyWeekActionTitle : CheckInState.previewDemoWeekActionTitle,
                systemImage: isPreviewingDemoWeek ? "person.crop.circle" : "play.circle"
            )
                .font(.headline)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .controlSize(.large)
        .accessibilityHint(
            isPreviewingDemoWeek
                ? CheckInState.showMyWeekActionAccessibilityHint
                : CheckInState.previewDemoWeekActionAccessibilityHint
        )
    }
}

private struct WeatherInstrumentPanelView: View {
    let readings: [WeatherInstrumentReading]
    let tint: Color

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: dynamicTypeSize.isAccessibilitySize ? 180 : 132), spacing: 8)]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Weather instruments", systemImage: "gauge")
                .font(.subheadline.bold())
                .foregroundStyle(tint)
                .fixedSize(horizontal: false, vertical: true)

            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(readings) { reading in
                    WeatherInstrumentReadingView(
                        reading: reading,
                        tint: tint
                    )
                }
            }
        }
        .padding(12)
        .background(tint.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(tint.opacity(0.18), lineWidth: 1)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Weather instruments")
    }
}

private struct WeatherInstrumentReadingView: View {
    let reading: WeatherInstrumentReading
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: reading.symbolName)
                .font(.headline.bold())
                .foregroundStyle(tint)
                .accessibilityHidden(true)

            Text(reading.title)
                .font(.caption.bold())
                .fixedSize(horizontal: false, vertical: true)

            Text(reading.value)
                .font(.title3.bold())
                .foregroundStyle(tint)
                .lineLimit(1)
                .minimumScaleFactor(0.75)

            Text(reading.detail)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, minHeight: 118, alignment: .topLeading)
        .padding(10)
        .background(tint.opacity(0.07), in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(tint.opacity(0.14), lineWidth: 1)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(reading.title)
        .accessibilityValue("\(reading.value). \(reading.detail)")
    }
}

private struct SoundscapeConsoleView: View {
    let profile: SoundscapeProfile
    let tint: Color
    @Binding var isEnabled: Bool

    @State private var lastPlayedEvent: SensorySoundEvent?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "waveform")
                    .font(.subheadline.bold())
                    .foregroundStyle(tint)
                    .frame(width: 24)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 3) {
                    Text(profile.title)
                        .font(.subheadline.bold())
                        .fixedSize(horizontal: false, vertical: true)

                    Text(profile.detail)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .layoutPriority(1)
            }

            SoundscapeWaveformView(
                events: profile.events,
                tint: tint,
                isEnabled: isEnabled,
                lastPlayedEvent: lastPlayedEvent
            )
            .frame(height: 56)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(tint.opacity(0.18), lineWidth: 1)
            }

            Toggle(isOn: $isEnabled) {
                Label("Local sound", systemImage: isEnabled ? "speaker.wave.2" : "speaker.slash")
                    .font(.caption.bold())
                    .fixedSize(horizontal: false, vertical: true)
            }
            .toggleStyle(.switch)

            HStack(spacing: 8) {
                ForEach(profile.events) { event in
                    Button {
                        lastPlayedEvent = event
                        if isEnabled {
                            SensorySoundEngine.play(event)
                        }
                    } label: {
                        Label(event.title, systemImage: event.symbolName)
                            .font(.caption.bold())
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    .tint(tint)
                    .accessibilityHint(isEnabled ? event.detail : "Turn on Local sound to play this cue. The waveform still shows the rhythm visually.")
                }
            }
        }
        .padding(12)
        .background(tint.opacity(0.07), in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(tint.opacity(0.16), lineWidth: 1)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(profile.title)
        .accessibilityValue(profile.accessibilityValue)
    }
}

private struct SoundscapeWaveformView: View {
    let events: [SensorySoundEvent]
    let tint: Color
    let isEnabled: Bool
    let lastPlayedEvent: SensorySoundEvent?

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                drawWaveform(
                    in: &context,
                    size: size,
                    time: reduceMotion ? 0 : timeline.date.timeIntervalSinceReferenceDate
                )
            }
        }
        .background {
            LinearGradient(
                colors: [
                    tint.opacity(0.14),
                    Color.blue.opacity(0.07),
                    Color.orange.opacity(0.06)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }

    private func drawWaveform(
        in context: inout GraphicsContext,
        size: CGSize,
        time: TimeInterval
    ) {
        let width = max(size.width, 1)
        let height = max(size.height, 1)
        let midY = height * 0.5
        let eventCount = max(events.count, 1)
        let columns = 28

        for index in 0..<columns {
            let x = width * (CGFloat(index) + 0.5) / CGFloat(columns)
            let event = events[index % eventCount]
            let phase = Double(index) * 0.48 + time * (isEnabled ? 2.0 : 0.6)
            let eventBoost = event == lastPlayedEvent ? CGFloat(1.0) : CGFloat(0.65)
            let amplitude = (8 + CGFloat((sin(phase) + 1) * 12)) * eventBoost
            let lineHeight = isEnabled ? amplitude : amplitude * 0.42

            var bar = Path()
            bar.move(to: CGPoint(x: x, y: midY - lineHeight))
            bar.addLine(to: CGPoint(x: x, y: midY + lineHeight))
            context.stroke(
                bar,
                with: .color(tint.opacity(event == lastPlayedEvent ? 0.86 : 0.42)),
                style: StrokeStyle(lineWidth: 3, lineCap: .round)
            )
        }
    }
}

private struct DemoPreviewNoticeView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "eye")
                .font(.title3)
                .foregroundStyle(.blue)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 3) {
                Text(CheckInState.demoWeekPreviewTitle)
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)

                Text("\(CheckInState.demoWeekPreviewDetail) This guided award demo shows storm, emotional physics, garden X-Ray, time-lapse, and Weekly Bloom in one path.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding(14)
        .bloomCardBackground(tint: .blue)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(CheckInState.demoWeekPreviewTitle)
        .accessibilityValue("\(CheckInState.demoWeekPreviewDetail) This guided award demo shows storm, emotional physics, garden X-Ray, time-lapse, and Weekly Bloom.")
    }
}

private struct AwardDemoTheatreView: View {
    let tint: Color

    private let beats = [
        AwardDemoBeat(title: "Observatory", detail: "The week changes the sky before the first tap.", systemImage: "scope"),
        AwardDemoBeat(title: "Live storm", detail: "Typing makes private pressure visible as safe weather.", systemImage: "tornado"),
        AwardDemoBeat(title: "Surgery table", detail: "Fragments are pulled into Now, Later, or Let go.", systemImage: "hand.draw"),
        AwardDemoBeat(title: "Planting ritual", detail: "The seed is dragged into soil and grows from the chosen lane.", systemImage: "camera.macro"),
        AwardDemoBeat(title: "Garden X-Ray", detail: "Roots, buds, and wind show the consequence layer.", systemImage: "scope"),
        AwardDemoBeat(title: "Week shape", detail: "Seven days become an emotional landscape.", systemImage: "map"),
        AwardDemoBeat(title: "Artifact", detail: "The completed week is crafted and saved as a private specimen.", systemImage: "archivebox")
    ]

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 128), spacing: 8)]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Award demo theatre", systemImage: "play.rectangle")
                .font(.subheadline.bold())
                .foregroundStyle(tint)
                .fixedSize(horizontal: false, vertical: true)

            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(Array(beats.enumerated()), id: \.offset) { index, beat in
                    AwardDemoBeatView(
                        index: index + 1,
                        beat: beat,
                        tint: tint
                    )
                }
            }
        }
        .padding(12)
        .background(tint.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(tint.opacity(0.18), lineWidth: 1)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Award demo theatre")
    }
}

private struct AwardDemoBeat: Equatable {
    let title: String
    let detail: String
    let systemImage: String
}

private struct AwardDemoBeatView: View {
    let index: Int
    let beat: AwardDemoBeat
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Text("\(index)")
                    .font(.caption2.bold())
                    .monospacedDigit()
                    .foregroundStyle(.white)
                    .frame(width: 20, height: 20)
                    .background(tint, in: Circle())

                Image(systemName: beat.systemImage)
                    .font(.caption.bold())
                    .foregroundStyle(tint)
                    .accessibilityHidden(true)
            }

            Text(beat.title)
                .font(.caption.bold())
                .fixedSize(horizontal: false, vertical: true)

            Text(beat.detail)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, minHeight: 98, alignment: .topLeading)
        .padding(9)
        .background(tint.opacity(0.07), in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(tint.opacity(0.14), lineWidth: 1)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(index). \(beat.title)")
        .accessibilityValue(beat.detail)
    }
}

private struct OriginLineView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "quote.opening")
                .font(.subheadline.bold())
                .foregroundStyle(.green)
                .frame(width: 22)
                .accessibilityHidden(true)

            Text(CheckInState.originLine)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .layoutPriority(1)
        }
        .padding(12)
        .bloomCardBackground(tint: .green)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("BloomMind origin")
        .accessibilityValue(CheckInState.originLine)
    }
}

private struct TomorrowSeedCardView: View {
    let prompt: String
    let tint: Color

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "calendar.badge.clock")
                .font(.subheadline.bold())
                .foregroundStyle(tint)
                .frame(width: 22)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text("Tomorrow's tiny seed")
                    .font(.subheadline.bold())
                    .fixedSize(horizontal: false, vertical: true)

                Text(prompt)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .layoutPriority(1)
        }
        .padding(12)
        .bloomCardBackground(tint: tint)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Tomorrow's tiny seed")
        .accessibilityValue(prompt)
    }
}

private struct WeekReviewCardView: View {
    let review: GardenWeekReview

    private var accentColor: Color {
        review.accentMood?.tint ?? .green
    }

    private var iconName: String {
        review.accentMood?.symbolName ?? "sparkles"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: iconName)
                    .font(.title3.bold())
                    .foregroundStyle(accentColor)
                    .frame(width: 28, height: 28)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 4) {
                    Text(review.title)
                        .font(.headline)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(review.detail)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .layoutPriority(1)

                Spacer(minLength: 0)
            }

            ProgressView(
                value: Double(review.completedCount),
                total: Double(max(review.totalCount, 1))
            )
            .tint(accentColor)
            .accessibilityHidden(true)
        }
        .padding(14)
        .bloomCardBackground(tint: accentColor)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(review.title)
        .accessibilityValue(review.accessibilityValue)
    }
}

private struct TodayStatusView: View {
    let isComplete: Bool
    let title: String
    let detail: String

    @ScaledMetric(relativeTo: .title3) private var iconSize: CGFloat = 22

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: isComplete ? "checkmark.circle.fill" : "lock.shield")
                .font(.system(size: iconSize, weight: .regular))
                .foregroundStyle(isComplete ? .green : .blue)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .layoutPriority(1)

            Spacer()
        }
        .padding(14)
        .bloomCardBackground(tint: isComplete ? .green : .blue)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(title)
        .accessibilityValue(detail)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                HomeView(
                    checkInState: .constant(CheckInState()),
                    onStartCheckIn: {}
                )
            }
            .previewDisplayName("Home - Fresh")

            NavigationStack {
                HomeView(
                    checkInState: .constant(
                        CheckInState(
                            completedCheckIns: 3,
                            lastCompletedAt: Date()
                        )
                    ),
                    onStartCheckIn: {}
                )
            }
            .previewDisplayName("Home - Completed Today")

            NavigationStack {
                HomeView(
                    checkInState: .constant(
                        CheckInState(completedCheckIns: CheckInState.weeklyCheckInGoal)
                    ),
                    onStartCheckIn: {}
                )
            }
            .previewDisplayName("Home - Full Garden")

            NavigationStack {
                HomeView(
                    checkInState: .constant(HomeViewPreviewState.fullReview),
                    onStartCheckIn: {}
                )
            }
            .previewLayout(.fixed(width: 1024, height: 768))
            .previewDisplayName("Home - iPad Review")
        }
    }
}

private enum HomeViewPreviewState {
    static var fullReview: CheckInState {
        CheckInState().demoWeekPreviewState()
    }
}
