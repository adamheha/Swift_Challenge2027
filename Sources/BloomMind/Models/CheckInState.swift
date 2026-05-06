import Foundation

struct CheckInState {
    static let reflectionCharacterLimit = 160
    static let weeklyCheckInGoal = 7
    static let reflectionPromptText = "Write one or two sentences about what is here right now."
    static let localPrivacyDetailText = "Your reflection stays local in this prototype."
    static let completeActionAccessibilityHint = "Saves this check-in and returns to Today."
    static let gardenPreviewTitle = "Garden preview"
    static let reflectionSummaryTitle = "Your reflection"

    var selectedMood: Mood?
    var reflectionText = ""
    var completedCheckIns = 0
    var lastCompletedAt: Date?

    var completedCheckInsThisWeek: Int {
        min(max(completedCheckIns, 0), Self.weeklyCheckInGoal)
    }

    var bloomProgress: Double {
        Double(completedCheckInsThisWeek) / Double(Self.weeklyCheckInGoal)
    }

    var bloomProgressPercent: Int {
        Int((bloomProgress * 100).rounded())
    }

    var weeklyProgressAccessibilityValue: String {
        "\(bloomProgressPercent) percent, \(completedCheckInsThisWeek) of \(Self.weeklyCheckInGoal) check-ins complete"
    }

    var todayPrompt: String {
        hasCompletedCheckInToday() ? "Today's bloom is already growing." : "What feeling wants your attention today?"
    }

    var primaryActionTitle: String {
        hasCompletedCheckInToday() ? "Check In Again" : "Start Check-In"
    }

    var primaryActionAccessibilityHint: String {
        hasCompletedCheckInToday() ? "Starts another check-in for today." : "Starts today's check-in."
    }

    var todayStatusTitle: String {
        hasCompletedCheckInToday() ? "Today's check-in is complete" : "Ready for today's check-in"
    }

    var todayStatusDetail: String {
        hasCompletedCheckInToday() ? Self.localPrivacyDetailText : "One minute is enough to notice what is here."
    }

    var bloomEncouragement: String {
        if hasCompletedCheckInToday() {
            return "Today's check-in is complete. Let that small action count."
        }

        return switch completedCheckInsThisWeek {
        case 0:
            "Start with one honest check-in today."
        case 1...3:
            "Your bloom is beginning to take shape."
        case 4...6:
            "A steady reflection habit is growing."
        default:
            "Your weekly bloom is full. Take a quiet moment to notice it."
        }
    }

    var trimmedReflectionText: String {
        reflectionText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var reflectionCharacterCount: Int {
        reflectionText.count
    }

    var isReflectionWithinLimit: Bool {
        reflectionCharacterCount <= Self.reflectionCharacterLimit
    }

    var reflectionAccessibilityValue: String {
        "\(reflectionCharacterCount) of \(Self.reflectionCharacterLimit) characters"
    }

    var reflectionAccessibilityHint: String {
        if isReflectionWithinLimit {
            return Self.reflectionPromptText
        }

        return "Shorten your reflection before continuing."
    }

    var gardenAccessibilityValue: String {
        "\(completedCheckInsThisWeek) of \(Self.weeklyCheckInGoal) plants grown"
    }

    var gardenProgressText: String {
        "\(completedCheckInsThisWeek)/\(Self.weeklyCheckInGoal)"
    }

    var continueActionAccessibilityHint: String {
        canContinueToAction
            ? "Shows a small growth action."
            : "Select a mood and write a short reflection to continue."
    }

    var canContinueToAction: Bool {
        selectedMood != nil && !trimmedReflectionText.isEmpty && isReflectionWithinLimit
    }

    func hasCompletedCheckInToday(
        now: Date = Date(),
        calendar: Calendar = .current
    ) -> Bool {
        guard let lastCompletedAt else {
            return false
        }

        return calendar.isDate(lastCompletedAt, inSameDayAs: now)
    }

    mutating func completeCheckIn(on date: Date = Date()) {
        completedCheckIns = max(completedCheckIns, 0) + 1
        lastCompletedAt = date
        selectedMood = nil
        reflectionText = ""
    }
}
