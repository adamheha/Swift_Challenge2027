import SwiftUI

struct GrowthActionView: View {
    @Binding var checkInState: CheckInState
    let onComplete: () -> Void

    private var selectedMood: Mood {
        checkInState.selectedMood ?? .unsure
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

                Text(selectedMood.growthActionTitle)
                    .font(.title.bold())
                    .multilineTextAlignment(.center)

                Text(selectedMood.growthAction)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
            }
            .bloomPanel(padding: 22)
            .accessibilityElement(children: .combine)

            if !checkInState.trimmedReflectionText.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your reflection")
                        .font(.headline)
                    Text(checkInState.trimmedReflectionText)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(.white.opacity(0.7), in: RoundedRectangle(cornerRadius: 8))
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(selectedMood.tint.opacity(0.22), lineWidth: 1)
                }
                .accessibilityElement(children: .combine)
            }

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
