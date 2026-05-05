import SwiftUI

struct StepProgressView: View {
    let currentStep: Int

    let steps = ["Mood", "Reflect", "Action"]

    var clampedCurrentStep: Int {
        min(max(currentStep, 1), steps.count)
    }

    var displayedStepNumber: Int {
        clampedCurrentStep
    }

    var currentStepTitle: String {
        steps[displayedStepNumber - 1]
    }

    var accessibilitySummary: String {
        "Check-in step \(displayedStepNumber) of \(steps.count), \(currentStepTitle)"
    }

    func isCompleted(stepNumber: Int) -> Bool {
        stepNumber <= clampedCurrentStep
    }

    func isCurrent(stepNumber: Int) -> Bool {
        stepNumber == clampedCurrentStep
    }

    var body: some View {
        HStack(spacing: 8) {
            ForEach(Array(steps.enumerated()), id: \.offset) { index, title in
                let stepNumber = index + 1

                HStack(spacing: 6) {
                    Circle()
                        .fill(isCompleted(stepNumber: stepNumber) ? .green : .secondary.opacity(0.25))
                        .frame(width: 22, height: 22)
                        .overlay {
                            Text("\(stepNumber)")
                                .font(.caption.bold())
                                .foregroundStyle(isCompleted(stepNumber: stepNumber) ? .white : .secondary)
                        }

                    Text(title)
                        .font(.caption.bold())
                        .foregroundStyle(isCurrent(stepNumber: stepNumber) ? .primary : .secondary)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilitySummary)
    }
}

struct StepProgressView_Previews: PreviewProvider {
    static var previews: some View {
        StepProgressView(currentStep: 2)
            .padding()
    }
}
