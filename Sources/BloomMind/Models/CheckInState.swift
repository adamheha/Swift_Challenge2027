import Foundation

struct CheckInState {
    static let reflectionCharacterLimit = 160

    var selectedMood: Mood?
    var reflectionText = ""
    var completedCheckIns = 0
    var lastCompletedAt: Date?

    var completedCheckInsThisWeek: Int {
        min(completedCheckIns, 7)
    }

    var bloomProgress: Double {
        Double(completedCheckInsThisWeek) / 7.0
    }

    var bloomProgressPercent: Int {
        Int((bloomProgress * 100).rounded())
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
        completedCheckIns += 1
        lastCompletedAt = date
        selectedMood = nil
        reflectionText = ""
    }
}
