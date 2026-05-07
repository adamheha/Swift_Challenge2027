import SwiftUI

struct GrowthActionView: View {
    @Binding var checkInState: CheckInState
    let onComplete: () -> Void

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

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
                tint: selectedMood.tint
            )

            LocalActionExplanationView(
                suggestion: suggestion,
                tint: selectedMood.tint
            )

            Spacer()

            Button {
                checkInState.completeCheckIn()
                onComplete()
            } label: {
                Label("Complete Check-In", systemImage: "checkmark.circle.fill")
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .accessibilityHint(CheckInState.completeActionAccessibilityHint)
        }
        .bloomPage()
        .navigationTitle("Growth Action")
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

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var selectedLane: StormLaneKind = .now

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: dynamicTypeSize.isAccessibilitySize ? 220 : 160), spacing: 10)]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            LazyVGrid(columns: columns, spacing: 10) {
                StormLaneCard(
                    kind: .now,
                    text: suggestion.nowStep,
                    tint: tint,
                    isSelected: selectedLane == .now
                ) {
                    selectedLane = .now
                }

                StormLaneCard(
                    kind: .later,
                    text: suggestion.laterStep,
                    tint: Color.blue,
                    isSelected: selectedLane == .later
                ) {
                    selectedLane = .later
                }

                StormLaneCard(
                    kind: .release,
                    text: suggestion.releaseStep,
                    tint: Color.orange,
                    isSelected: selectedLane == .release
                ) {
                    selectedLane = .release
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
}

private enum StormLaneKind {
    case now
    case later
    case release

    var title: String {
        switch self {
        case .now:
            "Now"
        case .later:
            "Later"
        case .release:
            "Let go"
        }
    }

    var symbolName: String {
        switch self {
        case .now:
            "bolt.fill"
        case .later:
            "tray"
        case .release:
            "wind"
        }
    }

    var commitmentLine: String {
        switch self {
        case .now:
            "Start with this one visible step."
        case .later:
            "Park the bigger worry here for after the first step."
        case .release:
            "This is the pressure you do not have to carry right now."
        }
    }
}

private struct StormLaneCard: View {
    let kind: StormLaneKind
    let text: String
    let tint: Color
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                Label(kind.title, systemImage: kind.symbolName)
                    .font(.subheadline.bold())
                    .foregroundStyle(tint)
                    .fixedSize(horizontal: false, vertical: true)

                Text(text)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, minHeight: 116, alignment: .topLeading)
            .padding(14)
            .bloomCardBackground(tint: tint)
            .background(isSelected ? tint.opacity(0.14) : Color.clear, in: RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? tint.opacity(0.75) : Color.clear, lineWidth: 2)
            }
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(kind.title)
        .accessibilityValue(text)
        .accessibilityHint(isSelected ? "Selected lane." : "Selects this lane for focus.")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
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
        }
    }
}
