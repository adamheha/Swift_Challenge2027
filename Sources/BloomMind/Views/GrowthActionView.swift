import SwiftUI

struct GrowthActionView: View {
    @Binding var checkInState: CheckInState
    let onComplete: () -> Void

    private var selectedMood: Mood {
        checkInState.selectedMood ?? .unsure
    }

    private var suggestion: GrowthActionSuggestion {
        LocalActionEngine.suggestion(
            for: selectedMood,
            reflectionText: checkInState.trimmedReflectionText
        )
    }

    var body: some View {
        VStack(spacing: 26) {
            StepProgressView(currentStep: 3)
                .bloomPanel(padding: 12)

            VStack(spacing: 12) {
                Image(systemName: selectedMood.symbolName)
                    .font(.system(size: 54, weight: .regular))
                    .foregroundStyle(selectedMood.tint.gradient)
                    .accessibilityHidden(true)

                Text(suggestion.title)
                    .font(.title.bold())
                    .multilineTextAlignment(.center)

                Text(suggestion.action)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
            }
            .bloomPanel(padding: 22)
            .accessibilityElement(children: .combine)

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

            Text(suggestion.explanation)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(.white.opacity(0.7), in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(tint.opacity(0.22), lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
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
