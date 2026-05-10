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

    private var pageSpacing: CGFloat {
        dynamicTypeSize.isAccessibilitySize ? 22 : 26
    }

    var body: some View {
        VStack(spacing: pageSpacing) {
            StepProgressView(currentStep: 3)
                .bloomPanel(padding: 12)

            PressureBloomTransformationView(
                mood: selectedMood,
                suggestion: suggestion
            )

            StormSortingView(
                suggestion: suggestion,
                tint: selectedMood.tint,
                selectedLane: $selectedLane
            )

            SeedCommitmentView(
                mood: selectedMood,
                suggestion: suggestion,
                selectedLane: selectedLane
            )

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

            Button(action: plantSeed) {
                Label(isPlantingSeed ? "Planting Seed" : "Plant This Seed", systemImage: isPlantingSeed ? "leaf.circle.fill" : "camera.macro.circle.fill")
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
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

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var sceneHeight: CGFloat {
        dynamicTypeSize.isAccessibilitySize ? 330 : 280
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            PressureStormView(
                intensity: 0.28,
                resolvedMood: mood,
                showsLabels: false
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
    @Binding var selectedLane: GrowthLane

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var fragmentAssignments: [StormFragment.ID: GrowthLane] = [:]
    @Namespace private var fragmentNamespace

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: dynamicTypeSize.isAccessibilitySize ? 220 : 160), spacing: 10)]
    }

    private var fragments: [StormFragment] {
        StormFragment.fragments(for: suggestion)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
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

            if fragments.isEmpty {
                Text(lane.emptyText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                ForEach(fragments) { fragment in
                    StormFragmentChipView(
                        fragment: fragment,
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
    let tint: Color
    let namespace: Namespace.ID
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .firstTextBaseline, spacing: 7) {
                Image(systemName: fragment.symbolName)
                    .font(.caption.bold())
                    .foregroundStyle(tint)
                    .accessibilityHidden(true)

                Text(fragment.text)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(tint.opacity(0.11), in: RoundedRectangle(cornerRadius: 7))
            .overlay {
                RoundedRectangle(cornerRadius: 7)
                    .stroke(tint.opacity(0.22), lineWidth: 1)
            }
            .matchedGeometryEffect(id: fragment.id, in: namespace)
        }
        .buttonStyle(.plain)
        .draggable(fragment.id)
        .accessibilityLabel(fragment.text)
        .accessibilityHint("Moves this fragment to the next lane.")
    }
}

private struct StormFragment: Identifiable, Hashable {
    let id: String
    let text: String
    let symbolName: String
    let startingLane: GrowthLane

    static func fragments(for suggestion: GrowthActionSuggestion) -> [StormFragment] {
        [
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
    }
}

private extension GrowthLane {
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
