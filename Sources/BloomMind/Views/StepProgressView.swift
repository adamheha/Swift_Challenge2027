import SwiftUI

struct StepProgressView: View {
    let currentStep: Int

    private let steps = ["Mood", "Reflect", "Action"]

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @ScaledMetric(relativeTo: .caption) private var stepCircleSize: CGFloat = 22

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

    private var prefersStackedLayout: Bool {
        dynamicTypeSize.isAccessibilitySize
    }

    func isCompleted(stepNumber: Int) -> Bool {
        stepNumber <= clampedCurrentStep
    }

    func isCurrent(stepNumber: Int) -> Bool {
        stepNumber == clampedCurrentStep
    }

    var body: some View {
        stepLayout
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(accessibilitySummary)
    }

    @ViewBuilder
    private var stepLayout: some View {
        if prefersStackedLayout {
            stackedSteps
        } else {
            ViewThatFits(in: .horizontal) {
                horizontalSteps
                stackedSteps
            }
        }
    }

    private var horizontalSteps: some View {
        HStack(spacing: 8) {
            ForEach(Array(steps.enumerated()), id: \.offset) { index, title in
                let stepNumber = index + 1
                stepItem(title: title, stepNumber: stepNumber, fillsWidth: true)
            }
        }
    }

    private var stackedSteps: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(Array(steps.enumerated()), id: \.offset) { index, title in
                let stepNumber = index + 1
                stepItem(title: title, stepNumber: stepNumber, fillsWidth: false)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func stepItem(title: String, stepNumber: Int, fillsWidth: Bool) -> some View {
        HStack(spacing: 6) {
            Circle()
                .fill(isCompleted(stepNumber: stepNumber) ? .green : .secondary.opacity(0.25))
                .frame(width: stepCircleSize, height: stepCircleSize)
                .overlay {
                    Text("\(stepNumber)")
                        .font(.caption.bold())
                        .foregroundStyle(isCompleted(stepNumber: stepNumber) ? .white : .secondary)
                        .minimumScaleFactor(0.8)
                }

            Text(title)
                .font(.caption.bold())
                .foregroundStyle(isCurrent(stepNumber: stepNumber) ? .primary : .secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: fillsWidth ? .infinity : nil, alignment: .leading)
    }
}

struct StepProgressView_Previews: PreviewProvider {
    static var previews: some View {
        StepProgressView(currentStep: 2)
            .padding()
            .previewDisplayName("Step Progress - Reflect")
    }
}
