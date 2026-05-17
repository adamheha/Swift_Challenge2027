import SwiftUI

struct HomeView: View {
    @Binding var checkInState: CheckInState
    @Binding var shouldStartDemoDirector: Bool
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

    private var gardenTimeTone: TimeOfDayGardenTone {
        BloomMindJourney.timeOfDayGardenTone(
            hasCompletedToday: checkInState.hasCompletedCheckInToday(),
            completedCount: gardenDisplayState.completedCheckInsThisWeek,
            totalCount: CheckInState.weeklyCheckInGoal
        )
    }

    var body: some View {
        ViewThatFits(in: .horizontal) {
            wideLayout
            compactLayout
        }
        .bloomPage(maxWidth: 980, padding: 32)
        .navigationTitle("Today")
        .onAppear {
            if shouldStartDemoDirector {
                isPreviewingDemoWeek = true
                shouldStartDemoDirector = false
            }
        }
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

            IdeaCycleStudioView(
                cycles: BloomMindIdeaCycles.completedCycles(),
                tint: gardenDisplayState.gardenSeedsThisWeek.last?.mood.tint ?? .green
            )
        }
    }

    private var gardenSection: some View {
        VStack(spacing: pageSpacing) {
            GardenTimeToneView(
                tone: gardenTimeTone,
                tint: gardenDisplayState.gardenSeedsThisWeek.last?.mood.tint ?? .green
            )

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
                    seeds: gardenDisplayState.gardenSeedsThisWeek,
                    onCarrySeedSelected: { line in
                        if !isPreviewingDemoWeek {
                            checkInState.carrySeedLine = line
                        }
                    }
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

            if gardenDisplayState.isWeeklyBloomUnlocked {
                CarrySeedLensView(
                    line: gardenDisplayState.returnTomorrowPrompt,
                    tint: gardenDisplayState.weeklyBloomPayoff.dominantMood?.tint ?? .green
                )
            }

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

private struct IdeaCycleStudioView: View {
    let cycles: [IdeaCycleStage]
    let tint: Color

    @State private var selectedCycleID: String?

    private var selectedCycle: IdeaCycleStage? {
        let fallback = cycles.first
        guard let selectedCycleID else {
            return fallback
        }
        return cycles.first { $0.id == selectedCycleID } ?? fallback
    }

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 132), spacing: 8)]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 10) {
                Label("Idea cycle studio", systemImage: "wand.and.stars")
                    .font(.subheadline.bold())
                    .foregroundStyle(tint)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()

                Text("\(BloomMindIdeaCycles.totalIdeaCount) sparks")
                    .font(.caption.bold())
                    .foregroundStyle(tint)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(tint.opacity(0.12), in: Capsule())
            }

            IdeaCycleResonanceView(
                resonance: BloomMindIdeaCycles.resonance(for: cycles),
                tint: tint
            )

            if cycles.count > 1 {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(cycles) { cycle in
                            Button {
                                withAnimation(.spring(response: 0.34, dampingFraction: 0.86)) {
                                    selectedCycleID = cycle.id
                                }
                            } label: {
                                Text(cycle.title.replacingOccurrences(of: "Round ", with: "R"))
                                    .font(.caption.bold())
                                    .lineLimit(1)
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                            .tint(cycle.id == selectedCycle?.id ? tint : .secondary)
                        }
                    }
                }
            }

            if let selectedCycle {
                VStack(alignment: .leading, spacing: 6) {
                    Text(selectedCycle.title)
                        .font(.headline)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(selectedCycle.focus)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(selectedCycle.implementedResult)
                        .font(.caption.bold())
                        .foregroundStyle(tint)
                        .fixedSize(horizontal: false, vertical: true)
                }

                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(selectedCycle.sparks) { spark in
                        IdeaSparkCardView(spark: spark, tint: tint)
                    }
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
        .accessibilityLabel("Idea cycle studio")
    }
}

private struct IdeaCycleResonanceView: View {
    let resonance: IdeaCycleResonance
    let tint: Color

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: resonance.symbolName)
                .font(.headline.bold())
                .foregroundStyle(tint)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 3) {
                Text(resonance.title)
                    .font(.caption.bold())
                    .fixedSize(horizontal: false, vertical: true)

                Text(resonance.detail)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(10)
        .background(tint.opacity(0.06), in: RoundedRectangle(cornerRadius: 8))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(resonance.title)
        .accessibilityValue(resonance.detail)
    }
}

private struct IdeaSparkCardView: View {
    let spark: IdeaCycleSpark
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: spark.symbolName)
                    .font(.caption.bold())
                    .foregroundStyle(tint)
                    .accessibilityHidden(true)

                Text(spark.dimension)
                    .font(.caption2.bold())
                    .foregroundStyle(tint)
                    .lineLimit(1)
            }

            Text(spark.title)
                .font(.caption.bold())
                .fixedSize(horizontal: false, vertical: true)

            Text(spark.detail)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, minHeight: 118, alignment: .topLeading)
        .padding(10)
        .background(tint.opacity(0.06), in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(tint.opacity(0.14), lineWidth: 1)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(spark.title)
        .accessibilityValue("\(spark.dimension). \(spark.detail)")
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

                Text("\(CheckInState.demoWeekPreviewDetail) The director mode walks through origin, live storm, wordless check-in, storm surgery, planting, Week Film, and the private museum.")
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
        .accessibilityValue("\(CheckInState.demoWeekPreviewDetail) The director mode walks through origin, live storm, wordless check-in, storm surgery, planting, Week Film, and the private museum.")
    }
}

private struct AwardDemoTheatreView: View {
    let tint: Color

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var activeStepIndex = 0
    @State private var isDirectorPlaying = false

    private let steps = BloomMindJourney.guidedAwardDemoSteps()

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 120), spacing: 8)]
    }

    private var activeStep: GuidedDemoStep {
        steps[min(max(activeStepIndex, 0), steps.count - 1)]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 10) {
                Label("Award demo director", systemImage: "play.rectangle")
                    .font(.subheadline.bold())
                    .foregroundStyle(tint)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()

                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.86)) {
                        isDirectorPlaying.toggle()
                    }
                } label: {
                    Label(isDirectorPlaying ? "Pause" : "Play", systemImage: isDirectorPlaying ? "pause.fill" : "play.fill")
                        .font(.caption.bold())
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .tint(tint)
            }

            GuidedDemoSpotlightView(
                step: activeStep,
                index: activeStepIndex + 1,
                total: steps.count,
                tint: tint
            )

            HStack(alignment: .top, spacing: 8) {
                Text("Demo reflection")
                    .font(.caption.bold())
                    .foregroundStyle(tint)

                Text(BloomMindJourney.demoReflection)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(10)
            .background(tint.opacity(0.07), in: RoundedRectangle(cornerRadius: 8))

            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                    GuidedDemoStepButton(
                        index: index + 1,
                        step: step,
                        tint: tint,
                        isActive: index == activeStepIndex
                    ) {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.86)) {
                            activeStepIndex = index
                            isDirectorPlaying = false
                        }
                    }
                }
            }

            HStack(spacing: 8) {
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.86)) {
                        activeStepIndex = max(activeStepIndex - 1, 0)
                        isDirectorPlaying = false
                    }
                } label: {
                    Label("Back", systemImage: "chevron.left")
                        .font(.caption.bold())
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .disabled(activeStepIndex == 0)

                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.86)) {
                        advanceSpotlight()
                        isDirectorPlaying = false
                    }
                } label: {
                    Label("Next beat", systemImage: "chevron.right")
                        .font(.caption.bold())
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
                .disabled(activeStepIndex == steps.count - 1)
            }
        }
        .padding(12)
        .background(tint.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(tint.opacity(0.18), lineWidth: 1)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Award demo director")
        .onReceive(Timer.publish(every: 2.3, on: .main, in: .common).autoconnect()) { _ in
            guard isDirectorPlaying, !reduceMotion else {
                return
            }

            withAnimation(.spring(response: 0.35, dampingFraction: 0.86)) {
                advanceSpotlight()
                if activeStepIndex == steps.count - 1 {
                    isDirectorPlaying = false
                }
            }
        }
    }

    private func advanceSpotlight() {
        activeStepIndex = min(activeStepIndex + 1, steps.count - 1)
    }
}

private struct GuidedDemoSpotlightView: View {
    let step: GuidedDemoStep
    let index: Int
    let total: Int
    let tint: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(tint.opacity(0.16))
                    .frame(width: 56, height: 56)

                Image(systemName: step.systemImage)
                    .font(.title3.bold())
                    .foregroundStyle(tint)
            }
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 6) {
                Text("Beat \(index) of \(total)")
                    .font(.caption.monospacedDigit().bold())
                    .foregroundStyle(tint)

                Text(step.title)
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)

                Text(step.detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                Text(step.caption)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(tint)
                    .fixedSize(horizontal: false, vertical: true)

                Label(step.instruction, systemImage: "light.beacon.max")
                    .font(.caption.bold())
                    .fixedSize(horizontal: false, vertical: true)
            }
            .layoutPriority(1)
        }
        .padding(12)
        .background(tint.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(tint.opacity(0.26), lineWidth: 1)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Demo beat \(index) of \(total): \(step.title)")
        .accessibilityValue("\(step.detail) \(step.instruction)")
    }
}

private struct GuidedDemoStepButton: View {
    let index: Int
    let step: GuidedDemoStep
    let tint: Color
    let isActive: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Text("\(index)")
                        .font(.caption2.bold())
                        .monospacedDigit()
                        .foregroundStyle(isActive ? .white : tint)
                        .frame(width: 20, height: 20)
                        .background(isActive ? tint : tint.opacity(0.10), in: Circle())

                    Image(systemName: step.systemImage)
                        .font(.caption.bold())
                        .foregroundStyle(tint)
                        .accessibilityHidden(true)
                }

                Text(step.title)
                    .font(.caption.bold())
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)

                Text(step.detail)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, minHeight: 104, alignment: .topLeading)
            .padding(9)
            .background((isActive ? tint : Color.secondary).opacity(isActive ? 0.12 : 0.06), in: RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke((isActive ? tint : Color.secondary).opacity(isActive ? 0.28 : 0.12), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(index). \(step.title)")
        .accessibilityValue(step.detail)
        .accessibilityHint("Shows this guided demo beat.")
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

private struct GardenTimeToneView: View {
    let tone: TimeOfDayGardenTone
    let tint: Color

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: tone.symbolName)
                .font(.subheadline.bold())
                .foregroundStyle(tint)
                .frame(width: 22)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(tone.title)
                    .font(.subheadline.bold())
                    .fixedSize(horizontal: false, vertical: true)

                Text(tone.detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .layoutPriority(1)
        }
        .padding(12)
        .bloomCardBackground(tint: tint)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(tone.title)
        .accessibilityValue(tone.detail)
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

private struct CarrySeedLensView: View {
    let line: String
    let tint: Color

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        TimelineView(.animation) { timeline in
            let pulse = reduceMotion ? 0.5 : (sin(timeline.date.timeIntervalSinceReferenceDate * 1.4) + 1) / 2

            HStack(alignment: .center, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(tint.opacity(0.12 + pulse * 0.08))
                        .frame(width: 58, height: 58)

                    Circle()
                        .stroke(tint.opacity(0.42), lineWidth: 1.4)
                        .frame(width: 44 + CGFloat(pulse) * 8, height: 44 + CGFloat(pulse) * 8)

                    Image(systemName: "circle.hexagongrid.fill")
                        .font(.title3.bold())
                        .foregroundStyle(tint)
                }
                .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Carry seed on the lens")
                        .font(.subheadline.bold())
                        .fixedSize(horizontal: false, vertical: true)

                    Text(line)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .layoutPriority(1)
            }
            .padding(12)
            .background(tint.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(tint.opacity(0.20), lineWidth: 1)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Carry seed on the lens")
        .accessibilityValue(line)
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
                    shouldStartDemoDirector: .constant(false),
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
                    shouldStartDemoDirector: .constant(false),
                    onStartCheckIn: {}
                )
            }
            .previewDisplayName("Home - Completed Today")

            NavigationStack {
                HomeView(
                    checkInState: .constant(
                        CheckInState(completedCheckIns: CheckInState.weeklyCheckInGoal)
                    ),
                    shouldStartDemoDirector: .constant(false),
                    onStartCheckIn: {}
                )
            }
            .previewDisplayName("Home - Full Garden")

            NavigationStack {
                HomeView(
                    checkInState: .constant(HomeViewPreviewState.fullReview),
                    shouldStartDemoDirector: .constant(false),
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
