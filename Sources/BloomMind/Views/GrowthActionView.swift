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

            VStack(spacing: 12) {
                Image(systemName: selectedMood.symbolName)
                    .font(.system(size: 54, weight: .regular))
                    .foregroundStyle(selectedMood.tint)
                    .accessibilityHidden(true)

                Text("A small action for \(selectedMood.rawValue.lowercased())")
                    .font(.title.bold())
                    .multilineTextAlignment(.center)

                Text(selectedMood.growthAction)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
            }

            if !checkInState.reflectionText.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your reflection")
                        .font(.headline)
                    Text(checkInState.reflectionText)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(.quaternary.opacity(0.45), in: RoundedRectangle(cornerRadius: 8))
            }

            Spacer()

            Button {
                checkInState.completeCheckIn()
                onComplete()
            } label: {
                Label("Complete Check-In", systemImage: "checkmark")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding(24)
        .navigationTitle("Growth Action")
    }
}

struct GrowthActionView_Previews: PreviewProvider {
    static var previews: some View {
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
    }
}
