import SwiftUI

struct CheckInView: View {
    @Binding var checkInState: CheckInState
    let onContinue: () -> Void

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @ScaledMetric(relativeTo: .body) private var reflectionMinHeight: CGFloat = 140

    private var moodButtonMinimumWidth: CGFloat {
        dynamicTypeSize.isAccessibilitySize ? 180 : 130
    }

    private var moodGridColumns: [GridItem] {
        [GridItem(.adaptive(minimum: moodButtonMinimumWidth), spacing: 12)]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            StepProgressView(currentStep: 1)
                .bloomPanel(padding: 12)

            CheckInStormPreviewView(
                selectedMood: checkInState.selectedMood,
                reflectionText: checkInState.reflectionText
            )

            VStack(alignment: .leading, spacing: 8) {
                Text("Name the storm")
                    .font(.title.bold())

                Text("Pick the closest feeling. The goal is not a perfect label; it is one visible piece of the storm.")
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            LazyVGrid(columns: moodGridColumns, spacing: 12) {
                ForEach(Mood.allCases) { mood in
                    MoodButton(
                        mood: mood,
                        isSelected: checkInState.selectedMood == mood
                    ) {
                        checkInState.selectedMood = mood
                    }
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("What is spinning around you?")
                        .font(.headline)

                    Spacer()

                    Text("\(checkInState.reflectionCharacterCount)/\(CheckInState.reflectionCharacterLimit)")
                        .font(.caption.monospacedDigit())
                        .foregroundStyle(checkInState.isReflectionWithinLimit ? Color.secondary : Color.red)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Reflection")
                .accessibilityValue(checkInState.reflectionAccessibilityValue)
                .accessibilityHint(checkInState.reflectionAccessibilityHint)

                ReflectionFieldView(
                    text: $checkInState.reflectionText,
                    minHeight: reflectionMinHeight
                )
                .accessibilityLabel("Reflection")
                .accessibilityValue(checkInState.reflectionAccessibilityValue)
                .accessibilityHint(checkInState.reflectionAccessibilityHint)
                .bloomCardBackground(tint: .green)

                if !checkInState.isReflectionWithinLimit {
                    Label("Keep this reflection short enough for a one-minute check-in.", systemImage: "exclamationmark.circle")
                        .font(.caption)
                        .foregroundStyle(.red)
                        .fixedSize(horizontal: false, vertical: true)
                        .accessibilityHint("Shorten your reflection before continuing.")
                }
            }

            WordlessCheckInCardView(
                signal: $checkInState.wordlessSignal,
                selectedMood: $checkInState.selectedMood
            )

            Spacer()

            Button(action: onContinue) {
                Label("Continue", systemImage: "arrow.right")
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(!checkInState.canContinueToAction)
            .accessibilityHint(checkInState.continueActionAccessibilityHint)
        }
        .bloomPage(maxWidth: 620)
        .navigationTitle("Check-In")
    }
}

private struct ReflectionFieldView: View {
    @Binding var text: String
    let minHeight: CGFloat

    @FocusState private var isFocused: Bool

    var body: some View {
        TextField(
            CheckInState.reflectionPromptText,
            text: $text,
            axis: .vertical
        )
        .textFieldStyle(.plain)
        .font(.body)
        .lineLimit(4...8)
        .focused($isFocused)
        .padding(12)
        .frame(maxWidth: .infinity, minHeight: minHeight, alignment: .topLeading)
        .contentShape(Rectangle())
        .onTapGesture {
            isFocused = true
        }
    }
}

private struct WordlessCheckInCardView: View {
    @Binding var signal: WordlessStormSignal?
    @Binding var selectedMood: Mood?

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var draftSignal = WordlessStormSignal.defaultSignal

    private var padHeight: CGFloat {
        dynamicTypeSize.isAccessibilitySize ? 150 : 112
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "hand.tap")
                    .font(.subheadline.bold())
                    .foregroundStyle(draftSignal.lane.wordlessTint(primary: .green))
                    .frame(width: 24)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 3) {
                    Text("Wordless mode")
                        .font(.headline)
                        .fixedSize(horizontal: false, vertical: true)

                    Text("When words are hard, press or drag the storm pad. Down becomes Now, sideways becomes Later, up becomes Let go.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .layoutPriority(1)
            }

            WordlessStormPadView(signal: $draftSignal)
                .frame(height: padHeight)

            HStack(spacing: 8) {
                ForEach(GrowthLane.allCases) { lane in
                    Button {
                        draftSignal.lane = lane
                        applyDraft()
                    } label: {
                        Label(lane.title, systemImage: lane.symbolName)
                            .font(.caption.bold())
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                    .buttonStyle(.bordered)
                    .tint(lane.wordlessTint(primary: .green))
                    .accessibilityHint(lane.focusSproutLine)
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Signal strength")
                        .font(.caption.bold())

                    Spacer()

                    Text("\(Int((draftSignal.normalizedIntensity * 100).rounded()))%")
                        .font(.caption.monospacedDigit())
                        .foregroundStyle(.secondary)
                }

                Slider(
                    value: Binding(
                        get: { draftSignal.normalizedIntensity },
                        set: { newValue in
                            draftSignal.intensity = newValue
                            applyDraft()
                        }
                    ),
                    in: 0.1...1.0
                )
                .tint(draftSignal.lane.wordlessTint(primary: .green))
            }

            HStack(alignment: .top, spacing: 10) {
                Label(draftSignal.title, systemImage: draftSignal.lane.physicsSymbolName)
                    .font(.caption.bold())
                    .foregroundStyle(draftSignal.lane.wordlessTint(primary: .green))
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: 8)

                if signal != nil {
                    Button("Clear") {
                        signal = nil
                    }
                    .font(.caption.bold())
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    .accessibilityHint("Removes the wordless signal.")
                } else {
                    Button("Use signal") {
                        applyDraft()
                    }
                    .font(.caption.bold())
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                    .accessibilityHint("Attaches this wordless storm signal to the check-in.")
                }
            }

            if let signal {
                Text(signal.detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityLabel(signal.accessibilityValue)
            }
        }
        .padding(12)
        .background(draftSignal.lane.wordlessTint(primary: .green).opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(draftSignal.lane.wordlessTint(primary: .green).opacity(0.18), lineWidth: 1)
        }
        .onAppear {
            if let signal {
                draftSignal = signal
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Wordless mode")
    }

    private func applyDraft() {
        signal = draftSignal
        if selectedMood == nil {
            selectedMood = draftSignal.suggestedMood
        }
    }
}

private struct WordlessStormPadView: View {
    @Binding var signal: WordlessStormSignal

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(signal.lane.wordlessTint(primary: .green).opacity(0.10))

                ForEach(0..<5, id: \.self) { index in
                    Circle()
                        .stroke(signal.lane.wordlessTint(primary: .green).opacity(0.18 - Double(index) * 0.02), lineWidth: 1)
                        .frame(
                            width: CGFloat(42 + index * 28) * signal.normalizedIntensity,
                            height: CGFloat(42 + index * 28) * signal.normalizedIntensity
                        )
                }

                VStack(spacing: 8) {
                    Image(systemName: signal.lane.physicsSymbolName)
                        .font(.title2.bold())
                        .foregroundStyle(signal.lane.wordlessTint(primary: .green))
                        .accessibilityHidden(true)

                    Text(signal.title)
                        .font(.caption.bold())
                        .foregroundStyle(.primary)

                    Text("Drag the pressure.")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        let width = max(proxy.size.width, 1)
                        let height = max(proxy.size.height, 1)
                        let center = CGPoint(x: width / 2, y: height / 2)
                        let dx = value.location.x - center.x
                        let dy = value.location.y - center.y
                        let distance = sqrt(dx * dx + dy * dy)
                        let intensity = min(max(Double(distance / max(width, height)) * 2.4, 0.18), 1.0)

                        signal.intensity = intensity

                        if dy > abs(dx) * 0.75 {
                            signal.lane = .now
                        } else if dy < -abs(dx) * 0.75 {
                            signal.lane = .release
                        } else {
                            signal.lane = .later
                        }
                    }
            )
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Wordless storm pad")
        .accessibilityValue(signal.accessibilityValue)
        .accessibilityHint("Drag down for Now, sideways for Later, or up for Let go.")
    }
}

private extension GrowthLane {
    func wordlessTint(primary: Color) -> Color {
        switch self {
        case .now:
            primary
        case .later:
            .blue
        case .release:
            .orange
        }
    }
}

private struct MoodButton: View {
    let mood: Mood
    let isSelected: Bool
    let action: () -> Void

    @ScaledMetric(relativeTo: .body) private var buttonMinHeight: CGFloat = 92
    @ScaledMetric(relativeTo: .title2) private var iconSize: CGFloat = 24

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: mood.symbolName)
                    .font(.system(size: iconSize, weight: .regular))
                Text(mood.rawValue)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
            }
            .frame(maxWidth: .infinity, minHeight: buttonMinHeight)
            .foregroundStyle(isSelected ? mood.selectedForegroundColor : mood.tint)
            .background(isSelected ? mood.tint.gradient : mood.tint.opacity(0.12).gradient, in: RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? .white.opacity(0.7) : mood.tint.opacity(0.22), lineWidth: 1)
            }
            .overlay(alignment: .topTrailing) {
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.caption.bold())
                        .foregroundStyle(.white)
                        .padding(8)
                        .accessibilityHidden(true)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(mood.rawValue)
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
        .accessibilityHint(mood.accessibilityHint)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

struct CheckInView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                CheckInView(
                    checkInState: .constant(CheckInState()),
                    onContinue: {}
                )
            }
            .previewDisplayName("Check-In - Empty")

            NavigationStack {
                CheckInView(
                    checkInState: .constant(
                        CheckInState(
                            selectedMood: .calm,
                            reflectionText: "I feel steady enough to start small."
                        )
                    ),
                    onContinue: {}
                )
            }
            .previewDisplayName("Check-In - Selected")

            NavigationStack {
                CheckInView(
                    checkInState: .constant(
                        CheckInState(
                            selectedMood: .stressed,
                            reflectionText: "I have a project due today and feel pressure to finish everything."
                        )
                    ),
                    onContinue: {}
                )
            }
            .previewLayout(.fixed(width: 1024, height: 768))
            .previewDisplayName("Check-In - iPad Review")
        }
    }
}
