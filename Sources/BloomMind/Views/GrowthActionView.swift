import SwiftUI

struct GrowthActionView: View {
    @Binding var checkInState: CheckInState
    let onComplete: () -> Void

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var selectedLane: GrowthLane = .now
    @State private var isPlantingSeed = false

    private var selectedMood: Mood {
        checkInState.selectedMood ?? .unsure
    }

    private var suggestion: GrowthActionSuggestion {
        LocalActionEngine.suggestion(
            for: selectedMood,
            reflectionText: checkInState.trimmedReflectionText
        )
    }

    private var liveStormProfile: LiveStormProfile {
        checkInState.liveStormProfile
    }

    private var privacyRitual: ReflectionPrivacyRitual {
        checkInState.reflectionPrivacyRitual
    }

    private var pageSpacing: CGFloat {
        dynamicTypeSize.isAccessibilitySize ? 22 : 26
    }

    var body: some View {
        VStack(spacing: pageSpacing) {
            StepProgressView(currentStep: 3)
                .bloomPanel(padding: 12)

            PressureBloomTransformationView(
                mood: selectedMood,
                suggestion: suggestion,
                liveProfile: liveStormProfile
            )

            ReflectionPrivacyRitualView(
                ritual: privacyRitual,
                mood: selectedMood
            )

            StormSortingView(
                suggestion: suggestion,
                tint: selectedMood.tint,
                liveKeywords: liveStormProfile.keywords,
                selectedLane: $selectedLane
            )

            SeedCommitmentView(
                mood: selectedMood,
                suggestion: suggestion,
                selectedLane: selectedLane
            )

            if selectedLane == .now {
                FocusSproutView(
                    tint: selectedMood.tint,
                    actionText: suggestion.nowStep
                )
            }

            LocalActionExplanationView(
                suggestion: suggestion,
                tint: selectedMood.tint
            )

            if isPlantingSeed {
                SeedCollapseView(
                    tint: selectedMood.tint,
                    selectedLane: selectedLane
                )

                PlantingSeedView(tint: selectedMood.tint)
            }

            Spacer()

            SeedPlantingRitualButton(
                mood: selectedMood,
                selectedLane: selectedLane,
                isPlantingSeed: isPlantingSeed,
                action: plantSeed
            )
            .disabled(isPlantingSeed)
            .accessibilityHint(CheckInState.completeActionAccessibilityHint)
        }
        .bloomPage()
        .navigationTitle("Growth Action")
    }

    private func plantSeed() {
        guard !isPlantingSeed else {
            return
        }

        withAnimation(.spring(response: 0.36, dampingFraction: 0.78)) {
            isPlantingSeed = true
        }

        Task {
            try? await Task.sleep(nanoseconds: 900_000_000)

            await MainActor.run {
                checkInState.completeCheckIn(
                    lane: selectedLane,
                    theme: suggestion.theme
                )
                onComplete()
            }
        }
    }
}

private struct ReflectionPrivacyRitualView: View {
    let ritual: ReflectionPrivacyRitual
    let mood: Mood

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var revealFragments = false

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            PrivacyRitualParticleView(
                fragments: ritual.fragments,
                tint: mood.tint,
                isActive: revealFragments || reduceMotion
            )
            .frame(width: 78, height: 78)
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 7) {
                Label(ritual.title, systemImage: "lock.open")
                    .font(.subheadline.bold())
                    .foregroundStyle(mood.tint)
                    .fixedSize(horizontal: false, vertical: true)

                Text(ritual.detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                if !ritual.fragments.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(Array(ritual.fragments.enumerated()), id: \.offset) { _, fragment in
                                Text(fragment)
                                    .font(.caption2.bold())
                                    .foregroundStyle(mood.tint)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 5)
                                    .background(mood.tint.opacity(0.10), in: Capsule())
                            }
                        }
                    }
                }
            }
            .layoutPriority(1)
        }
        .padding(12)
        .background(mood.tint.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(mood.tint.opacity(0.18), lineWidth: 1)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(ritual.title)
        .accessibilityValue(ritual.accessibilityValue)
        .onAppear {
            guard !reduceMotion else {
                revealFragments = true
                return
            }

            withAnimation(.easeOut(duration: 0.8).delay(0.08)) {
                revealFragments = true
            }
        }
    }
}

private struct PrivacyRitualParticleView: View {
    let fragments: [String]
    let tint: Color
    let isActive: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                drawParticles(
                    in: &context,
                    size: size,
                    time: reduceMotion ? 0 : timeline.date.timeIntervalSinceReferenceDate
                )
            }
        }
    }

    private func drawParticles(
        in context: inout GraphicsContext,
        size: CGSize,
        time: TimeInterval
    ) {
        let width = max(size.width, 1)
        let height = max(size.height, 1)
        let center = CGPoint(x: width * 0.5, y: height * 0.5)
        let count = max(fragments.count, 3)

        context.fill(
            Path(ellipseIn: CGRect(x: width * 0.18, y: height * 0.18, width: width * 0.64, height: height * 0.64)),
            with: .color(tint.opacity(isActive ? 0.14 : 0.06))
        )

        for index in 0..<count {
            let angle = Double(index) / Double(count) * Double.pi * 2 + time * 0.55
            let radius = min(width, height) * (isActive ? 0.32 : 0.12)
            let point = CGPoint(
                x: center.x + CGFloat(cos(angle)) * radius,
                y: center.y + CGFloat(sin(angle)) * radius
            )
            let dotSize = CGFloat(7 + index % 3)
            context.fill(
                Path(ellipseIn: CGRect(
                    x: point.x - dotSize,
                    y: point.y - dotSize,
                    width: dotSize * 2,
                    height: dotSize * 2
                )),
                with: .color(tint.opacity(0.30 + Double(index % 3) * 0.12))
            )
        }

        context.draw(
            Text("shape")
                .font(.caption2.bold())
                .foregroundStyle(tint),
            at: center
        )
    }
}

private struct SeedPlantingRitualButton: View {
    let mood: Mood
    let selectedLane: GrowthLane
    let isPlantingSeed: Bool
    let action: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.isEnabled) private var isEnabled
    @State private var seedHover = false
    @State private var dragOffset: CGSize = .zero
    @State private var isDropReady = false

    var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 12) {
                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(soilGradient)
                        .frame(height: 74)
                        .overlay(alignment: .top) {
                            Capsule()
                                .fill(Color(red: 0.36, green: 0.24, blue: 0.14).opacity(isDropReady ? 0.52 : 0.32))
                                .frame(width: isDropReady ? 188 : 150, height: isDropReady ? 16 : 12)
                                .offset(y: 12)
                        }

                    LaneRitualMarkView(
                        lane: selectedLane,
                        tint: mood.tint,
                        isActive: isPlantingSeed
                    )
                    .frame(height: 64)
                    .padding(.bottom, 8)

                    ZStack {
                        Circle()
                            .fill(mood.tint.opacity(isDropReady ? 0.32 : 0.22))
                            .frame(width: isDropReady ? 82 : 74, height: isDropReady ? 82 : 74)

                        Image(systemName: isPlantingSeed ? "leaf.circle.fill" : selectedLane.symbolName)
                            .font(.title2.bold())
                            .foregroundStyle(mood.tint)
                            .accessibilityHidden(true)
                    }
                    .offset(seedOffset)
                    .shadow(color: mood.tint.opacity(isDropReady ? 0.34 : 0.22), radius: isDropReady ? 18 : 14, x: 0, y: 8)
                    .gesture(seedDragGesture)
                }
                .frame(maxWidth: .infinity)

                VStack(spacing: 4) {
                    Text(ritualTitle)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(isPlantingSeed ? selectedLane.gardenConsequenceDetail : "Drag the seed into the soil, or tap to plant. \(selectedLane.gardenConsequenceDetail) \(selectedLane.physicsDetail)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(14)
            .background(mood.tint.opacity(0.10), in: RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(mood.tint.opacity(isPlantingSeed ? 0.46 : 0.24), lineWidth: 1)
            }
        }
        .contentShape(RoundedRectangle(cornerRadius: 8))
        .onTapGesture(perform: triggerPlanting)
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel(isPlantingSeed ? "Seed entering the soil" : "Drag seed into the soil")
        .accessibilityValue(selectedLane.gardenConsequenceDetail)
        .accessibilityAction(named: "Plant seed") {
            triggerPlanting()
        }
        .onAppear {
            guard !reduceMotion else {
                seedHover = true
                return
            }

            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                seedHover = true
            }
        }
    }

    private var ritualTitle: String {
        if isPlantingSeed {
            return "Seed entering the soil"
        }

        return isDropReady ? "Release to plant the seed" : "Drag the seed into the soil"
    }

    private var seedOffset: CGSize {
        if isPlantingSeed {
            return CGSize(width: 0, height: 9)
        }

        let hoverY: CGFloat = seedHover ? -10 : -4
        return CGSize(
            width: dragOffset.width,
            height: dragOffset.height + hoverY
        )
    }

    private var seedDragGesture: some Gesture {
        DragGesture(minimumDistance: 4)
            .onChanged { value in
                guard isEnabled, !isPlantingSeed else {
                    return
                }

                dragOffset = CGSize(
                    width: min(max(value.translation.width, -90), 90),
                    height: min(max(value.translation.height, -44), 78)
                )
                isDropReady = value.translation.height > 34
            }
            .onEnded { value in
                guard isEnabled, !isPlantingSeed else {
                    resetDrag()
                    return
                }

                if value.translation.height > 42 {
                    triggerPlanting()
                } else {
                    withAnimation(.spring(response: 0.34, dampingFraction: 0.72)) {
                        resetDrag()
                    }
                }
            }
    }

    private func triggerPlanting() {
        guard isEnabled, !isPlantingSeed else {
            return
        }

        withAnimation(.spring(response: 0.32, dampingFraction: 0.74)) {
            dragOffset = .zero
            isDropReady = false
        }

        action()
    }

    private func resetDrag() {
        dragOffset = .zero
        isDropReady = false
    }

    private var soilGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 0.34, green: 0.23, blue: 0.14).opacity(0.32),
                mood.tint.opacity(0.12),
                Color(red: 0.18, green: 0.28, blue: 0.18).opacity(0.22)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

private struct LaneRitualMarkView: View {
    let lane: GrowthLane
    let tint: Color
    let isActive: Bool

    var body: some View {
        Canvas { context, size in
            let width = max(size.width, 1)
            let height = max(size.height, 1)
            let center = CGPoint(x: width * 0.5, y: height * 0.62)
            let opacity = isActive ? 0.50 : 0.26

            switch lane {
            case .now:
                for index in 0..<4 {
                    var root = Path()
                    let spread = CGFloat(index) / 3 - 0.5
                    root.move(to: center)
                    root.addQuadCurve(
                        to: CGPoint(x: center.x + spread * width * 0.44, y: height * 0.98),
                        control: CGPoint(x: center.x + spread * width * 0.16, y: height * 0.80)
                    )
                    context.stroke(
                        root,
                        with: .color(tint.opacity(opacity)),
                        style: StrokeStyle(lineWidth: 2, lineCap: .round)
                    )
                }
            case .later:
                for index in 0..<3 {
                    let x = width * (0.36 + CGFloat(index) * 0.14)
                    context.fill(
                        Path(ellipseIn: CGRect(x: x, y: height * 0.52, width: 22, height: 30)),
                        with: .color(tint.opacity(opacity))
                    )
                }
            case .release:
                for index in 0..<3 {
                    var wind = Path()
                    let y = height * (0.38 + CGFloat(index) * 0.16)
                    wind.move(to: CGPoint(x: width * 0.25, y: y))
                    wind.addCurve(
                        to: CGPoint(x: width * 0.74, y: y),
                        control1: CGPoint(x: width * 0.38, y: y - 12),
                        control2: CGPoint(x: width * 0.58, y: y + 12)
                    )
                    context.stroke(
                        wind,
                        with: .color(tint.opacity(opacity)),
                        style: StrokeStyle(lineWidth: 2, lineCap: .round)
                    )
                }
            }
        }
        .accessibilityHidden(true)
    }
}

private struct SeedCollapseView: View {
    let tint: Color
    let selectedLane: GrowthLane

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var progress = 0.0

    var body: some View {
        Canvas { context, size in
            drawCollapse(in: &context, size: size)
        }
        .frame(height: 92)
        .background(tint.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(tint.opacity(0.20), lineWidth: 1)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Sorted fragments becoming a seed")
        .accessibilityValue(selectedLane.commitmentLine)
        .onAppear {
            guard !reduceMotion else {
                progress = 1
                return
            }

            withAnimation(.easeInOut(duration: 0.72)) {
                progress = 1
            }
        }
    }

    private func drawCollapse(in context: inout GraphicsContext, size: CGSize) {
        let width = max(size.width, 1)
        let height = max(size.height, 1)
        let center = CGPoint(x: width * 0.5, y: height * 0.52)
        let starts: [CGPoint] = [
            CGPoint(x: width * 0.12, y: height * 0.28),
            CGPoint(x: width * 0.22, y: height * 0.76),
            CGPoint(x: width * 0.38, y: height * 0.18),
            CGPoint(x: width * 0.62, y: height * 0.78),
            CGPoint(x: width * 0.78, y: height * 0.24),
            CGPoint(x: width * 0.88, y: height * 0.68)
        ]

        for (index, start) in starts.enumerated() {
            let localProgress = min(max(progress - Double(index) * 0.035, 0), 1)
            let point = CGPoint(
                x: start.x + (center.x - start.x) * localProgress,
                y: start.y + (center.y - start.y) * localProgress
            )
            let radius = 5 + CGFloat(localProgress) * 2

            var path = Path()
            path.move(to: start)
            path.addLine(to: point)
            context.stroke(
                path,
                with: .color(tint.opacity(0.18 * (1 - localProgress))),
                lineWidth: 1
            )

            context.fill(
                Path(ellipseIn: CGRect(
                    x: point.x - radius,
                    y: point.y - radius,
                    width: radius * 2,
                    height: radius * 2
                )),
                with: .color(tint.opacity(0.28 + localProgress * 0.34))
            )
        }

        let seedRadius = 10 + CGFloat(progress) * 12
        context.fill(
            Path(ellipseIn: CGRect(
                x: center.x - seedRadius,
                y: center.y - seedRadius,
                width: seedRadius * 2,
                height: seedRadius * 2
            )),
            with: .color(tint.opacity(0.26 + progress * 0.48))
        )
        context.stroke(
            Path(ellipseIn: CGRect(
                x: center.x - seedRadius - 5,
                y: center.y - seedRadius - 5,
                width: seedRadius * 2 + 10,
                height: seedRadius * 2 + 10
            )),
            with: .color(tint.opacity(0.20 + progress * 0.20)),
            lineWidth: 1.4
        )
    }
}

private struct PressureBloomTransformationView: View {
    let mood: Mood
    let suggestion: GrowthActionSuggestion
    let liveProfile: LiveStormProfile

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var sceneHeight: CGFloat {
        dynamicTypeSize.isAccessibilitySize ? 330 : 280
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            PressureStormView(
                intensity: max(0.30, liveProfile.intensity - 0.12),
                resolvedMood: mood,
                showsLabels: false,
                liveKeywords: liveProfile.keywords,
                liveTheme: liveProfile.theme
            )

            VStack(alignment: .leading, spacing: 10) {
                Label("Storm sorted", systemImage: mood.symbolName)
                    .font(.caption.bold())
                    .foregroundStyle(.white.opacity(0.9))

                Text(suggestion.title)
                    .font(.title.bold())
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)

                Text(suggestion.action)
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.82))
                    .fixedSize(horizontal: false, vertical: true)

                Text(liveProfile.caption)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.72))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(22)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: sceneHeight)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(mood.tint.opacity(0.5), lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Storm sorted")
        .accessibilityValue("\(suggestion.title). \(suggestion.action)")
    }
}

private struct StormSortingView: View {
    let suggestion: GrowthActionSuggestion
    let tint: Color
    let liveKeywords: [String]
    @Binding var selectedLane: GrowthLane

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var fragmentAssignments: [StormFragment.ID: GrowthLane] = [:]
    @Namespace private var fragmentNamespace

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: dynamicTypeSize.isAccessibilitySize ? 220 : 160), spacing: 10)]
    }

    private var fragments: [StormFragment] {
        StormFragment.fragments(for: suggestion, liveKeywords: liveKeywords)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DirectStormSortingHeaderView(
                tint: tint,
                liveKeywords: liveKeywords
            )

            StormSurgeryTableView(
                fragments: fragments,
                selectedLane: selectedLane,
                tint: tint,
                laneForFragment: currentLane
            )

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(GrowthLane.allCases) { lane in
                    StormLaneColumnView(
                        lane: lane,
                        fragments: fragments(in: lane),
                        tint: lane.tint(primary: tint),
                        namespace: fragmentNamespace,
                        isSelected: selectedLane == lane,
                        onSelectLane: {
                            withAnimation(sortingAnimation) {
                                selectedLane = lane
                            }
                        },
                        onMoveFragment: moveFragment,
                        onDropFragments: moveFragments
                    )
                }
            }

            Label(selectedLane.commitmentLine, systemImage: selectedLane.symbolName)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityLabel(selectedLane.commitmentLine)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Sorted pressure lanes")
    }

    private func fragments(in lane: GrowthLane) -> [StormFragment] {
        fragments.filter { fragment in
            currentLane(for: fragment) == lane
        }
    }

    private func currentLane(for fragment: StormFragment) -> GrowthLane {
        fragmentAssignments[fragment.id] ?? fragment.startingLane
    }

    private func moveFragment(_ fragment: StormFragment) {
        let nextLane = currentLane(for: fragment).nextLane

        withAnimation(sortingAnimation) {
            fragmentAssignments[fragment.id] = nextLane
            selectedLane = nextLane
        }
    }

    private func moveFragments(_ fragmentIDs: [StormFragment.ID], to lane: GrowthLane) {
        withAnimation(sortingAnimation) {
            for fragmentID in fragmentIDs {
                fragmentAssignments[fragmentID] = lane
            }

            selectedLane = lane
        }
    }

    private var sortingAnimation: Animation {
        reduceMotion ? .linear(duration: 0) : .spring(response: 0.42, dampingFraction: 0.78)
    }
}

private struct DirectStormSortingHeaderView: View {
    let tint: Color
    let liveKeywords: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Pull the storm apart", systemImage: "hand.draw")
                .font(.subheadline.bold())
                .foregroundStyle(tint)
                .fixedSize(horizontal: false, vertical: true)

            Text("Words from the storm can be dragged into Now, Later, or Let go. The seed will remember how you changed the weather.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            if !liveKeywords.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(Array(liveKeywords.enumerated()), id: \.offset) { _, keyword in
                            Label(keyword, systemImage: "tornado")
                                .font(.caption2.bold())
                                .foregroundStyle(tint)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 5)
                                .background(tint.opacity(0.11), in: Capsule())
                        }
                    }
                    .padding(.vertical, 1)
                }
            }
        }
        .padding(12)
        .background(tint.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(tint.opacity(0.16), lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Pull the storm apart")
        .accessibilityValue(liveKeywords.isEmpty ? "Use the generated fragments to sort the storm." : "Live storm words: \(liveKeywords.joined(separator: ", ")).")
    }
}

private struct StormSurgeryTableView: View {
    let fragments: [StormFragment]
    let selectedLane: GrowthLane
    let tint: Color
    let laneForFragment: (StormFragment) -> GrowthLane

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var tableHeight: CGFloat {
        dynamicTypeSize.isAccessibilitySize ? 260 : 220
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "scope")
                    .font(.subheadline.bold())
                    .foregroundStyle(tint)
                    .frame(width: 24)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 3) {
                    Text("Storm surgery table")
                        .font(.subheadline.bold())
                        .fixedSize(horizontal: false, vertical: true)

                    Text("Every fragment you move changes what the storm core becomes: root, bud, or wind.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .layoutPriority(1)
            }

            GeometryReader { proxy in
                ZStack {
                    StormSurgeryCanvasView(
                        fragments: fragments,
                        selectedLane: selectedLane,
                        tint: tint,
                        laneForFragment: laneForFragment,
                        reduceMotion: reduceMotion
                    )

                    ForEach(Array(fragments.prefix(7).enumerated()), id: \.element.id) { index, fragment in
                        let lane = laneForFragment(fragment)
                        StormSurgeryFragmentBadge(
                            fragment: fragment,
                            lane: lane,
                            tint: lane.tint(primary: tint)
                        )
                        .position(
                            surgeryBadgePosition(
                                index: index,
                                count: min(fragments.count, 7),
                                size: proxy.size
                            )
                        )
                    }
                }
            }
            .frame(height: tableHeight)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(tint.opacity(0.20), lineWidth: 1)
            }

            HStack(spacing: 8) {
                ForEach(GrowthLane.allCases) { lane in
                    Label(lane.physicsTitle, systemImage: lane.physicsSymbolName)
                        .font(.caption2.bold())
                        .foregroundStyle(lane.tint(primary: tint))
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .background(lane.tint(primary: tint).opacity(0.08), in: Capsule())
                }
            }
        }
        .padding(12)
        .background(tint.opacity(0.07), in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(tint.opacity(0.16), lineWidth: 1)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Storm surgery table")
        .accessibilityValue(accessibilitySummary)
    }

    private func surgeryBadgePosition(
        index: Int,
        count: Int,
        size: CGSize
    ) -> CGPoint {
        let width = max(size.width, 1)
        let height = max(size.height, 1)
        let radiusX = width * 0.34
        let radiusY = height * 0.28
        let angle = (Double(index) / Double(max(count, 1))) * .pi * 2 - .pi / 2

        return CGPoint(
            x: width * 0.5 + cos(angle) * radiusX,
            y: height * 0.46 + sin(angle) * radiusY
        )
    }

    private var accessibilitySummary: String {
        let laneSummary = GrowthLane.allCases
            .map { lane in
                let count = fragments.filter { laneForFragment($0) == lane }.count
                return "\(lane.title): \(count)"
            }
            .joined(separator: ", ")
        return "Fragments orbit the storm core. \(laneSummary)."
    }
}

private struct StormSurgeryCanvasView: View {
    let fragments: [StormFragment]
    let selectedLane: GrowthLane
    let tint: Color
    let laneForFragment: (StormFragment) -> GrowthLane
    let reduceMotion: Bool

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                drawTable(
                    in: &context,
                    size: size,
                    time: reduceMotion ? 0 : timeline.date.timeIntervalSinceReferenceDate
                )
            }
        }
        .background {
            LinearGradient(
                colors: [
                    tint.opacity(0.18),
                    Color.blue.opacity(0.08),
                    Color.orange.opacity(0.07)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    private func drawTable(
        in context: inout GraphicsContext,
        size: CGSize,
        time: TimeInterval
    ) {
        let width = max(size.width, 1)
        let height = max(size.height, 1)
        let center = CGPoint(x: width * 0.5, y: height * 0.44)
        let pulse = CGFloat((sin(time * 1.1) + 1) / 2)
        let coreRadius = min(width, height) * 0.18
        let coreRect = CGRect(
            x: center.x - coreRadius,
            y: center.y - coreRadius,
            width: coreRadius * 2,
            height: coreRadius * 2
        )

        for index in 0..<4 {
            let radius = coreRadius + CGFloat(index) * 18 + pulse * 5
            context.stroke(
                Path(ellipseIn: CGRect(
                    x: center.x - radius,
                    y: center.y - radius,
                    width: radius * 2,
                    height: radius * 2
                )),
                with: .color(tint.opacity(0.18 - Double(index) * 0.025)),
                style: StrokeStyle(lineWidth: 1, lineCap: .round)
            )
        }

        context.fill(
            Path(ellipseIn: coreRect),
            with: .radialGradient(
                Gradient(colors: [
                    selectedLane.tint(primary: tint).opacity(0.62),
                    tint.opacity(0.20),
                    Color.black.opacity(0.06)
                ]),
                center: center,
                startRadius: 3,
                endRadius: coreRadius
            )
        )
        context.stroke(
            Path(ellipseIn: coreRect.insetBy(dx: -6, dy: -6)),
            with: .color(Color.white.opacity(0.32)),
            lineWidth: 1.4
        )

        let laneCenters: [(GrowthLane, CGPoint)] = [
            (.now, CGPoint(x: width * 0.22, y: height * 0.84)),
            (.later, CGPoint(x: width * 0.50, y: height * 0.89)),
            (.release, CGPoint(x: width * 0.78, y: height * 0.84))
        ]

        for (lane, laneCenter) in laneCenters {
            let laneTint = lane.tint(primary: tint)
            var path = Path()
            path.move(to: center)
            path.addQuadCurve(
                to: laneCenter,
                control: CGPoint(
                    x: (center.x + laneCenter.x) / 2,
                    y: center.y + height * 0.18
                )
            )
            context.stroke(
                path,
                with: .color(laneTint.opacity(selectedLane == lane ? 0.46 : 0.20)),
                style: StrokeStyle(lineWidth: selectedLane == lane ? 2.4 : 1.2, lineCap: .round)
            )

            let wellRect = CGRect(x: laneCenter.x - 24, y: laneCenter.y - 16, width: 48, height: 32)
            context.fill(
                Path(roundedRect: wellRect, cornerRadius: 8),
                with: .color(laneTint.opacity(selectedLane == lane ? 0.24 : 0.12))
            )
            context.stroke(
                Path(roundedRect: wellRect, cornerRadius: 8),
                with: .color(laneTint.opacity(0.34)),
                lineWidth: 1
            )
        }

        for (index, fragment) in fragments.prefix(7).enumerated() {
            let lane = laneForFragment(fragment)
            let angle = (Double(index) / Double(max(min(fragments.count, 7), 1))) * .pi * 2 + time * lane.orbitSpeed
            let orbitRadius = coreRadius + 42 + CGFloat(index % 2) * 14
            let point = CGPoint(
                x: center.x + cos(angle) * orbitRadius,
                y: center.y + sin(angle) * orbitRadius * 0.68
            )

            context.fill(
                Path(ellipseIn: CGRect(x: point.x - 4, y: point.y - 4, width: 8, height: 8)),
                with: .color(lane.tint(primary: tint).opacity(0.54))
            )
        }
    }
}

private struct StormSurgeryFragmentBadge: View {
    let fragment: StormFragment
    let lane: GrowthLane
    let tint: Color

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: lane.physicsSymbolName)
                .font(.caption2.bold())
                .foregroundStyle(tint)
                .accessibilityHidden(true)

            Text(fragment.shortText)
                .font(.caption2.bold())
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .padding(.horizontal, 7)
        .padding(.vertical, 5)
        .background(Color.white.opacity(0.76), in: Capsule())
        .overlay {
            Capsule()
                .stroke(tint.opacity(0.32), lineWidth: 1)
        }
        .shadow(color: tint.opacity(0.12), radius: 5, x: 0, y: 2)
    }
}

private struct SeedCommitmentView: View {
    let mood: Mood
    let suggestion: GrowthActionSuggestion
    let selectedLane: GrowthLane

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var seedSize: CGFloat {
        dynamicTypeSize.isAccessibilitySize ? 62 : 54
    }

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            ZStack {
                Circle()
                    .fill(mood.tint.opacity(0.22))

                Image(systemName: selectedLane.symbolName)
                    .font(.title3.bold())
                    .foregroundStyle(mood.tint)
                    .accessibilityHidden(true)
            }
            .frame(width: seedSize, height: seedSize)

            VStack(alignment: .leading, spacing: 5) {
                Text(selectedLane.seedTitle)
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)

                Text(selectedLane.text(from: suggestion))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .layoutPriority(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(seedBackground, in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(mood.tint.opacity(0.24), lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(selectedLane.seedTitle)
        .accessibilityValue(selectedLane.text(from: suggestion))
        .animation(reduceMotion ? .linear(duration: 0) : .spring(response: 0.36, dampingFraction: 0.8), value: selectedLane)
    }

    private var seedBackground: LinearGradient {
        LinearGradient(
            colors: [
                mood.tint.opacity(0.16),
                Color.white.opacity(0.62)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

private struct FocusSproutView: View {
    let tint: Color
    let actionText: String

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var startedAt: Date?

    private let duration: TimeInterval = 60

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { timeline in
            let progress = focusProgress(now: timeline.date)

            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top, spacing: 10) {
                    FocusSproutCanvasView(
                        tint: tint,
                        progress: progress,
                        reduceMotion: reduceMotion
                    )
                    .frame(width: 58, height: 58)
                    .accessibilityHidden(true)

                    VStack(alignment: .leading, spacing: 4) {
                        Label("Focus sprout", systemImage: "timer")
                            .font(.subheadline.bold())
                            .foregroundStyle(tint)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(startedAt == nil ? "Start one tiny minute before planting. Starting still counts." : remainingText(progress: progress))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(actionText)
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .layoutPriority(1)
                }

                ProgressView(value: progress)
                    .tint(tint)
                    .accessibilityHidden(true)

                Button {
                    startedAt = Date()
                } label: {
                    Label(startedAt == nil ? "Start tiny sprout" : "Restart sprout", systemImage: "play.circle")
                        .font(.caption.bold())
                        .fixedSize(horizontal: false, vertical: true)
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
            .padding(12)
            .background(tint.opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(tint.opacity(0.18), lineWidth: 1)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Focus sprout")
            .accessibilityValue(startedAt == nil ? "Start one tiny minute. Starting still counts." : remainingText(progress: progress))
        }
    }

    private func focusProgress(now: Date) -> Double {
        guard let startedAt else {
            return 0
        }

        return min(max(now.timeIntervalSince(startedAt) / duration, 0), 1)
    }

    private func remainingText(progress: Double) -> String {
        if progress >= 1 {
            return "The first minute became roots. Starting still counts."
        }

        let seconds = max(0, Int(((1 - progress) * duration).rounded()))
        return "\(seconds) seconds left. Let one tiny step become roots."
    }
}

private struct FocusSproutCanvasView: View {
    let tint: Color
    let progress: Double
    let reduceMotion: Bool

    var body: some View {
        Canvas { context, size in
            let width = max(size.width, 1)
            let height = max(size.height, 1)
            let groundY = height * 0.80
            let centerX = width * 0.5
            let growth = CGFloat(progress)

            context.fill(
                Path(ellipseIn: CGRect(x: width * 0.15, y: groundY - 5, width: width * 0.70, height: 10)),
                with: .color(tint.opacity(0.16))
            )

            for index in 0..<3 {
                var root = Path()
                let spread = CGFloat(index - 1) * 18 * growth
                root.move(to: CGPoint(x: centerX, y: groundY))
                root.addQuadCurve(
                    to: CGPoint(x: centerX + spread, y: height * 0.98),
                    control: CGPoint(x: centerX + spread * 0.24, y: height * 0.88)
                )
                context.stroke(
                    root,
                    with: .color(tint.opacity(0.24 + progress * 0.38)),
                    style: StrokeStyle(lineWidth: 1.6, lineCap: .round)
                )
            }

            var stem = Path()
            stem.move(to: CGPoint(x: centerX, y: groundY))
            stem.addQuadCurve(
                to: CGPoint(x: centerX + 4, y: groundY - 34 * growth),
                control: CGPoint(x: centerX - 8, y: groundY - 16 * growth)
            )
            context.stroke(
                stem,
                with: .color(tint.opacity(0.36 + progress * 0.42)),
                style: StrokeStyle(lineWidth: 2.4, lineCap: .round)
            )

            let leafSize = 8 + growth * 8
            context.fill(
                Path(ellipseIn: CGRect(
                    x: centerX - leafSize * 0.2,
                    y: groundY - 38 * growth,
                    width: leafSize,
                    height: leafSize * 1.5
                )),
                with: .color(tint.opacity(0.30 + progress * 0.46))
            )
        }
    }
}

private struct PlantingSeedView: View {
    let tint: Color

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var pulse = false

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "camera.macro")
                .font(.title3.bold())
                .foregroundStyle(tint)
                .scaleEffect(reduceMotion ? 1 : (pulse ? 1.14 : 0.94))
                .accessibilityHidden(true)

            Text("Planting seed...")
                .font(.subheadline.bold())
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)
        }
        .padding(12)
        .background(tint.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(tint.opacity(0.28), lineWidth: 1)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Planting seed")
        .onAppear {
            guard !reduceMotion else {
                pulse = true
                return
            }

            withAnimation(.easeInOut(duration: 0.42).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }
}

private struct StormLaneColumnView: View {
    let lane: GrowthLane
    let fragments: [StormFragment]
    let tint: Color
    let namespace: Namespace.ID
    let isSelected: Bool
    let onSelectLane: () -> Void
    let onMoveFragment: (StormFragment) -> Void
    let onDropFragments: ([StormFragment.ID], GrowthLane) -> Void

    @State private var isDropTargeted = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button(action: onSelectLane) {
                Label(lane.title, systemImage: lane.symbolName)
                    .font(.subheadline.bold())
                    .foregroundStyle(tint)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .buttonStyle(.plain)
            .accessibilityAddTraits(isSelected ? .isSelected : [])

            Text(lane.physicsTitle)
                .font(.caption2.bold())
                .foregroundStyle(tint.opacity(0.86))
                .fixedSize(horizontal: false, vertical: true)

            if fragments.isEmpty {
                Text(lane.emptyText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                ForEach(fragments) { fragment in
                    StormFragmentChipView(
                        fragment: fragment,
                        lane: lane,
                        tint: tint,
                        namespace: namespace
                    ) {
                        onMoveFragment(fragment)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: 168, alignment: .topLeading)
        .padding(12)
        .bloomCardBackground(tint: tint)
        .background((isSelected || isDropTargeted) ? tint.opacity(isDropTargeted ? 0.20 : 0.12) : Color.clear, in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke((isSelected || isDropTargeted) ? tint.opacity(0.78) : Color.clear, lineWidth: isDropTargeted ? 3 : 2)
        }
        .dropDestination(for: String.self) { fragmentIDs, _ in
            onDropFragments(fragmentIDs, lane)
            return true
        } isTargeted: { isTargeted in
            isDropTargeted = isTargeted
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(lane.title)
    }
}

private struct StormFragmentChipView: View {
    let fragment: StormFragment
    let lane: GrowthLane
    let tint: Color
    let namespace: Namespace.ID
    let action: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var pulse = false

    var body: some View {
        Button(action: action) {
            HStack(alignment: .firstTextBaseline, spacing: 7) {
                Image(systemName: lane.physicsSymbolName)
                    .font(.caption.bold())
                    .foregroundStyle(tint)
                    .accessibilityHidden(true)

                Text(fragment.text)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 0)

                Image(systemName: fragment.symbolName)
                    .font(.caption2.bold())
                    .foregroundStyle(tint.opacity(0.72))
                    .accessibilityHidden(true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(chipBackground, in: RoundedRectangle(cornerRadius: 7))
            .overlay {
                RoundedRectangle(cornerRadius: 7)
                    .stroke(tint.opacity(borderOpacity), lineWidth: lane == .now ? 1.4 : 1)
            }
            .matchedGeometryEffect(id: fragment.id, in: namespace)
            .scaleEffect(reduceMotion ? 1 : chipScale)
            .offset(y: reduceMotion ? 0 : chipYOffset)
            .shadow(color: tint.opacity(shadowOpacity), radius: shadowRadius, x: 0, y: shadowY)
        }
        .buttonStyle(.plain)
        .draggable(fragment.id)
        .accessibilityLabel(fragment.text)
        .accessibilityValue(lane.physicsDetail)
        .accessibilityHint("Moves this fragment to the next lane.")
        .onAppear {
            guard !reduceMotion else {
                pulse = true
                return
            }

            withAnimation(.easeInOut(duration: lane.animationDuration).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }

    private var chipBackground: Color {
        switch lane {
        case .now:
            tint.opacity(0.16)
        case .later:
            tint.opacity(pulse ? 0.16 : 0.09)
        case .release:
            tint.opacity(0.07)
        }
    }

    private var chipScale: CGFloat {
        switch lane {
        case .now:
            1
        case .later:
            pulse ? 1.018 : 0.992
        case .release:
            pulse ? 0.992 : 1.010
        }
    }

    private var chipYOffset: CGFloat {
        switch lane {
        case .now:
            2
        case .later:
            pulse ? -3 : 1
        case .release:
            pulse ? -5 : -1
        }
    }

    private var borderOpacity: Double {
        switch lane {
        case .now:
            0.34
        case .later:
            pulse ? 0.34 : 0.18
        case .release:
            0.18
        }
    }

    private var shadowOpacity: Double {
        switch lane {
        case .now:
            0.22
        case .later:
            0.12
        case .release:
            0.08
        }
    }

    private var shadowRadius: CGFloat {
        switch lane {
        case .now:
            6
        case .later:
            pulse ? 9 : 4
        case .release:
            pulse ? 12 : 6
        }
    }

    private var shadowY: CGFloat {
        switch lane {
        case .now:
            5
        case .later:
            2
        case .release:
            0
        }
    }
}

private struct StormFragment: Identifiable, Hashable {
    let id: String
    let text: String
    let symbolName: String
    let startingLane: GrowthLane

    static func fragments(for suggestion: GrowthActionSuggestion, liveKeywords: [String]) -> [StormFragment] {
        var base = [
            StormFragment(
                id: "mood",
                text: suggestion.mood.fragmentText,
                symbolName: suggestion.mood.symbolName,
                startingLane: .now
            ),
            StormFragment(
                id: "theme",
                text: suggestion.theme.fragmentText,
                symbolName: suggestion.theme.symbolName,
                startingLane: .later
            ),
            StormFragment(
                id: "now",
                text: suggestion.nowStep,
                symbolName: "bolt.fill",
                startingLane: .now
            ),
            StormFragment(
                id: "later",
                text: suggestion.laterStep,
                symbolName: "tray",
                startingLane: .later
            ),
            StormFragment(
                id: "release",
                text: suggestion.releaseStep,
                symbolName: "wind",
                startingLane: .release
            )
        ]

        for (index, keyword) in liveKeywords.prefix(5).enumerated() {
            let lane = GrowthLane.allCases[index % GrowthLane.allCases.count]
            base.insert(
                StormFragment(
                    id: "live-\(index)-\(keyword)",
                    text: keyword,
                    symbolName: "tornado",
                    startingLane: lane
                ),
                at: min(index, base.count)
            )
        }

        return base
    }

    var shortText: String {
        if text.count <= 16 {
            return text
        }

        return String(text.prefix(13)) + "..."
    }
}

private extension GrowthLane {
    var animationDuration: Double {
        switch self {
        case .now:
            1.2
        case .later:
            1.4
        case .release:
            1.0
        }
    }

    var orbitSpeed: Double {
        switch self {
        case .now:
            0.10
        case .later:
            0.06
        case .release:
            -0.08
        }
    }

    func tint(primary: Color) -> Color {
        switch self {
        case .now:
            primary
        case .later:
            .blue
        case .release:
            .orange
        }
    }

    func text(from suggestion: GrowthActionSuggestion) -> String {
        switch self {
        case .now:
            suggestion.nowStep
        case .later:
            suggestion.laterStep
        case .release:
            suggestion.releaseStep
        }
    }
}

private extension Mood {
    var fragmentText: String {
        switch self {
        case .calm:
            "Steady energy is available."
        case .happy:
            "Good energy can be used carefully."
        case .tired:
            "Low energy means the next step should be smaller."
        case .stressed:
            "Pressure is making everything sound urgent."
        case .unsure:
            "Uncertainty needs one clear question."
        }
    }
}

private extension ReflectionTheme {
    var fragmentText: String {
        switch self {
        case .school:
            "School is the loudest part of the storm."
        case .friendship:
            "A relationship worry is asking for care."
        case .rest:
            "Rest is part of the answer, not a reward."
        case .pressure:
            "The pressure storm is mixing now with later."
        case .uncertainty:
            "The storm needs one answerable question."
        case .general:
            "The storm is real even without a perfect label."
        }
    }
}

private struct LocalActionExplanationView: View {
    let suggestion: GrowthActionSuggestion
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Why this action")
                .font(.headline)

            Label(suggestion.theme.displayName, systemImage: suggestion.theme.symbolName)
                .font(.subheadline.bold())
                .foregroundStyle(tint)
                .fixedSize(horizontal: false, vertical: true)

            Text(suggestion.explanation)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)

            Divider()

            Label("Tiny idea", systemImage: "lightbulb")
                .font(.subheadline.bold())
                .foregroundStyle(tint)
                .fixedSize(horizontal: false, vertical: true)

            Text(suggestion.literacyInsight)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .bloomCardBackground(tint: tint)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Why this action")
        .accessibilityValue("\(suggestion.theme.displayName). \(suggestion.explanation) \(suggestion.literacyInsight)")
    }
}

struct GrowthActionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                GrowthActionView(
                    checkInState: .constant(
                        CheckInState(
                            selectedMood: .stressed,
                            reflectionText: "I have a lot to finish, but I can start with one clear step.",
                            completedCheckIns: 2
                        )
                    ),
                    onComplete: {}
                )
            }
            .previewDisplayName("Growth Action - With Reflection")

            NavigationStack {
                GrowthActionView(
                    checkInState: .constant(
                        CheckInState(
                            selectedMood: .calm,
                            completedCheckIns: 2
                        )
                    ),
                    onComplete: {}
                )
            }
            .previewDisplayName("Growth Action - No Reflection")

            NavigationStack {
                GrowthActionView(
                    checkInState: .constant(
                        CheckInState(
                            selectedMood: .stressed,
                            reflectionText: "I have a project due today and feel pressure to finish everything.",
                            completedCheckIns: 2
                        )
                    ),
                    onComplete: {}
                )
            }
            .previewLayout(.fixed(width: 1024, height: 768))
            .previewDisplayName("Growth Action - iPad Review")
        }
    }
}
