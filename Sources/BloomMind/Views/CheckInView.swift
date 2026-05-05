import SwiftUI

struct CheckInView: View {
    @Binding var checkInState: CheckInState
    let onContinue: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            StepProgressView(currentStep: 2)
                .bloomPanel(padding: 12)

            VStack(alignment: .leading, spacing: 8) {
                Text("Choose your mood")
                    .font(.title.bold())

                Text("Pick the closest feeling. It does not need to be perfect.")
                    .foregroundStyle(.secondary)
            }

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 130), spacing: 12)], spacing: 12) {
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
                    Text("Reflection")
                        .font(.headline)

                    Spacer()

                    Text("\(checkInState.reflectionCharacterCount)/\(CheckInState.reflectionCharacterLimit)")
                        .font(.caption.monospacedDigit())
                        .foregroundStyle(checkInState.isReflectionWithinLimit ? Color.secondary : Color.red)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Reflection")
                .accessibilityValue(checkInState.reflectionAccessibilityValue)
                .accessibilityHint(checkInState.reflectionAccessibilityHint)

                TextEditor(text: $checkInState.reflectionText)
                    .frame(minHeight: 140)
                    .padding(8)
                    .accessibilityLabel("Reflection")
                    .accessibilityValue(checkInState.reflectionAccessibilityValue)
                    .accessibilityHint(checkInState.reflectionAccessibilityHint)
                    .scrollContentBackground(.hidden)
                    .background(.white.opacity(0.72), in: RoundedRectangle(cornerRadius: 8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.green.opacity(0.2), lineWidth: 1)
                    }
                    .overlay {
                        if checkInState.reflectionText.isEmpty {
                            Text(CheckInState.reflectionPromptText)
                                .foregroundStyle(.tertiary)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                .padding(16)
                                .allowsHitTesting(false)
                                .accessibilityHidden(true)
                        }
                    }

                if !checkInState.isReflectionWithinLimit {
                    Label("Keep this reflection short enough for a one-minute check-in.", systemImage: "exclamationmark.circle")
                        .font(.caption)
                        .foregroundStyle(.red)
                        .accessibilityHint("Shorten your reflection before continuing.")
                }
            }

            Spacer()

            Button(action: onContinue) {
                Label("Continue", systemImage: "arrow.right")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(!checkInState.canContinueToAction)
            .accessibilityHint(
                checkInState.canContinueToAction
                    ? "Shows a small growth action."
                    : "Select a mood and write a short reflection to continue."
            )
        }
        .bloomPage(maxWidth: 620)
        .navigationTitle("Check-In")
    }
}

private struct MoodButton: View {
    let mood: Mood
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: mood.symbolName)
                    .font(.title2)
                Text(mood.rawValue)
                    .font(.headline)
            }
            .frame(maxWidth: .infinity, minHeight: 92)
            .foregroundStyle(isSelected ? .white : mood.tint)
            .background(isSelected ? mood.tint.gradient : mood.tint.opacity(0.12).gradient, in: RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? .white.opacity(0.7) : mood.tint.opacity(0.22), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(mood.rawValue)
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

struct CheckInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CheckInView(
                checkInState: .constant(CheckInState()),
                onContinue: {}
            )
        }
    }
}
