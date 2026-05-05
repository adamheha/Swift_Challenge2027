import SwiftUI

struct StepProgressView: View {
    let currentStep: Int

    private let steps = ["Mood", "Reflect", "Action"]

    var body: some View {
        HStack(spacing: 8) {
            ForEach(Array(steps.enumerated()), id: \.offset) { index, title in
                let stepNumber = index + 1

                HStack(spacing: 6) {
                    Circle()
                        .fill(stepNumber <= currentStep ? .green : .secondary.opacity(0.25))
                        .frame(width: 22, height: 22)
                        .overlay {
                            Text("\(stepNumber)")
                                .font(.caption.bold())
                                .foregroundStyle(stepNumber <= currentStep ? .white : .secondary)
                        }

                    Text(title)
                        .font(.caption.bold())
                        .foregroundStyle(stepNumber == currentStep ? .primary : .secondary)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Check-in step \(currentStep) of \(steps.count)")
    }
}

struct StepProgressView_Previews: PreviewProvider {
    static var previews: some View {
        StepProgressView(currentStep: 2)
            .padding()
    }
}
