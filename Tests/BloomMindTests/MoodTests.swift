import Foundation
import Testing
@testable import BloomMind

@Test func moodActionsMatchConceptScope() {
    #expect(Mood.calm.growthAction == "Write down one thing you want to protect today.")
    #expect(Mood.happy.growthAction == "Share one kind sentence with someone.")
    #expect(Mood.tired.growthAction == "Take three slow breaths and lower one expectation.")
    #expect(Mood.stressed.growthAction == "Choose the smallest next step and do only that.")
    #expect(Mood.unsure.growthAction == "Write one question you want to understand better.")
}

@Test func checkInCompletionResetsCurrentEntry() {
    var state = CheckInState(
        selectedMood: .happy,
        reflectionText: "Today felt bright.",
        completedCheckIns: 1
    )

    state.completeCheckIn()

    #expect(state.completedCheckIns == 2)
    #expect(state.lastCompletedAt != nil)
    #expect(state.selectedMood == nil)
    #expect(state.reflectionText.isEmpty)
}

@Test func checkInCanContinueRequiresMoodAndReflection() {
    var state = CheckInState()
    #expect(!state.canContinueToAction)

    state.selectedMood = .calm
    #expect(!state.canContinueToAction)

    state.reflectionText = "   "
    #expect(!state.canContinueToAction)

    state.reflectionText = "I noticed I feel steady today."
    #expect(state.canContinueToAction)
}

@Test func bloomProgressCapsAtSevenCheckIns() {
    let state = CheckInState(completedCheckIns: 12)

    #expect(state.completedCheckInsThisWeek == CheckInState.weeklyCheckInGoal)
    #expect(state.bloomProgress == 1.0)
    #expect(state.bloomProgressPercent == 100)
}

@Test func bloomEncouragementReflectsProgressRange() {
    #expect(CheckInState(completedCheckIns: 0).bloomEncouragement == "Start with one honest check-in today.")
    #expect(CheckInState(completedCheckIns: 2).bloomEncouragement == "Your bloom is beginning to take shape.")
    #expect(CheckInState(completedCheckIns: 5).bloomEncouragement == "A steady reflection habit is growing.")
    #expect(
        CheckInState(completedCheckIns: CheckInState.weeklyCheckInGoal).bloomEncouragement
            == "Your weekly bloom is full. Take a quiet moment to notice it."
    )
}

@Test func completedCheckInTracksToday() {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(secondsFromGMT: 0)!
    let completedAt = Date(timeIntervalSince1970: 1_767_638_400)
    let laterSameDay = Date(timeIntervalSince1970: 1_767_650_000)
    let nextDay = Date(timeIntervalSince1970: 1_767_724_800)

    var state = CheckInState()
    #expect(!state.hasCompletedCheckInToday(now: completedAt, calendar: calendar))

    state.completeCheckIn(on: completedAt)

    #expect(state.hasCompletedCheckInToday(now: laterSameDay, calendar: calendar))
    #expect(!state.hasCompletedCheckInToday(now: nextDay, calendar: calendar))
}

@Test func todayCompletionUpdatesEncouragement() {
    var state = CheckInState(completedCheckIns: 2)
    state.completeCheckIn()

    #expect(state.hasCompletedCheckInToday())
    #expect(state.bloomEncouragement == "Today's check-in is complete. Let that small action count.")
}


@Test func reflectionLimitKeepsCheckInShort() {
    var state = CheckInState(selectedMood: .calm)

    state.reflectionText = String(repeating: "a", count: CheckInState.reflectionCharacterLimit)
    #expect(state.reflectionCharacterCount == CheckInState.reflectionCharacterLimit)
    #expect(state.isReflectionWithinLimit)
    #expect(state.canContinueToAction)

    state.reflectionText += "a"
    #expect(!state.isReflectionWithinLimit)
    #expect(!state.canContinueToAction)
}

@Test func reflectionAccessibilityCopyTracksLimitState() {
    var state = CheckInState()
    state.reflectionText = "A short check-in."

    #expect(state.reflectionAccessibilityValue == "17 of 160 characters")
    #expect(state.reflectionAccessibilityHint == CheckInState.reflectionPromptText)

    state.reflectionText = String(repeating: "a", count: CheckInState.reflectionCharacterLimit + 1)

    #expect(state.reflectionAccessibilityValue == "161 of 160 characters")
    #expect(state.reflectionAccessibilityHint == "Shorten your reflection before continuing.")
}

@Test func homeCopyReflectsTodayCompletion() {
    let notCompleted = CheckInState()
    #expect(notCompleted.todayPrompt == "What feeling wants your attention today?")
    #expect(notCompleted.primaryActionTitle == "Start Check-In")
    #expect(notCompleted.todayStatusTitle == "Ready for today's check-in")
    #expect(notCompleted.todayStatusDetail == "One minute is enough to notice what is here.")

    var completed = CheckInState()
    completed.completeCheckIn()
    #expect(completed.todayPrompt == "Today's bloom is already growing.")
    #expect(completed.primaryActionTitle == "Check In Again")
    #expect(completed.todayStatusTitle == "Today's check-in is complete")
    #expect(completed.todayStatusDetail == "Your reflection stays local in this prototype.")
}

@MainActor
@Test func stepProgressAccessibilityClampsOutOfRangeSteps() {
    let beforeFirstStep = StepProgressView(currentStep: 0)
    #expect(beforeFirstStep.displayedStepNumber == 1)
    #expect(beforeFirstStep.accessibilitySummary == "Check-in step 1 of 3, Mood")

    let afterLastStep = StepProgressView(currentStep: 4)
    #expect(afterLastStep.displayedStepNumber == 3)
    #expect(afterLastStep.accessibilitySummary == "Check-in step 3 of 3, Action")
}

@MainActor
@Test func stepProgressVisualStateAlsoClampsOutOfRangeSteps() {
    let beforeFirstStep = StepProgressView(currentStep: 0)
    #expect(beforeFirstStep.isCurrent(stepNumber: 1))
    #expect(beforeFirstStep.isCompleted(stepNumber: 1))
    #expect(!beforeFirstStep.isCompleted(stepNumber: 2))

    let afterLastStep = StepProgressView(currentStep: 4)
    #expect(afterLastStep.isCurrent(stepNumber: 3))
    #expect(afterLastStep.isCompleted(stepNumber: 3))
    #expect(!afterLastStep.isCurrent(stepNumber: 2))
}
