import SwiftUI

struct CheckInView: View {
    @Binding var checkInState: CheckInState
    let onContinue: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            StepProgressView(currentStep: 2)

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
                Text("Reflection")
                    .font(.headline)

                TextEditor(text: $checkInState.reflectionText)
                    .frame(minHeight: 140)
                    .padding(8)
                    .background(.quaternary.opacity(0.5), in: RoundedRectangle(cornerRadius: 8))
                    .overlay {
                        if checkInState.reflectionText.isEmpty {
                            Text("Write one or two sentences about what is here right now.")
                                .foregroundStyle(.tertiary)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                .padding(16)
                                .allowsHitTesting(false)
                        }
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
        }
        .padding(24)
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
            .background(isSelected ? mood.tint : mood.tint.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
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
