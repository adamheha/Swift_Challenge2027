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

@Test func moodSupportCopyMatchesMood() {
    #expect(Mood.stressed.accessibilityHint == "Selects stressed as your current mood.")
    #expect(Mood.tired.growthActionTitle == "A small action for tired")
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

@Test func checkInCompletionNormalizesNegativeProgress() {
    var state = CheckInState(completedCheckIns: -2)

    state.completeCheckIn()

    #expect(state.completedCheckIns == 1)
    #expect(state.completedCheckInsThisWeek == 1)
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

@Test func bloomProgressCapsAtGoalWithAccessibilityCopy() {
    let state = CheckInState(completedCheckIns: 12)

    #expect(state.completedCheckInsThisWeek == CheckInState.weeklyCheckInGoal)
    #expect(state.bloomProgress == 1.0)
    #expect(state.bloomProgressPercent == 100)
    #expect(state.weeklyProgressAccessibilityValue == "100 percent, 7 of 7 check-ins complete")
}

@Test func bloomProgressFloorsAtZeroWithAccessibilityCopy() {
    let state = CheckInState(completedCheckIns: -2)

    #expect(state.completedCheckInsThisWeek == 0)
    #expect(state.bloomProgress == 0.0)
    #expect(state.bloomProgressPercent == 0)
    #expect(state.weeklyProgressAccessibilityValue == "0 percent, 0 of 7 check-ins complete")
}

@Test func bloomEncouragementReflectsProgressRange() {
    #expect(CheckInState(completedCheckIns: -2).bloomEncouragement == "Start with one honest check-in today.")
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

@Test func completeActionAccessibilityHintDescribesResult() {
    #expect(CheckInState.completeActionAccessibilityHint == "Saves this check-in and returns to Today.")
}

@Test func homeCopyReflectsIncompleteAndCompleteStates() {
    let notCompleted = CheckInState()
    #expect(notCompleted.todayPrompt == "What feeling wants your attention today?")
    #expect(notCompleted.primaryActionTitle == "Start Check-In")
    #expect(notCompleted.primaryActionAccessibilityHint == "Starts today's check-in.")
    #expect(notCompleted.todayStatusTitle == "Ready for today's check-in")
    #expect(notCompleted.todayStatusDetail == "One minute is enough to notice what is here.")

    var completed = CheckInState()
    completed.completeCheckIn()
    #expect(completed.todayPrompt == "Today's bloom is already growing.")
    #expect(completed.primaryActionTitle == "Check In Again")
    #expect(completed.primaryActionAccessibilityHint == "Starts another check-in for today.")
    #expect(completed.todayStatusTitle == "Today's check-in is complete")
    #expect(completed.todayStatusDetail == CheckInState.localPrivacyDetailText)
}

@Test func gardenAccessibilityValueReflectsWeeklyProgress() {
    let floor = CheckInState(completedCheckIns: -2)
    #expect(floor.gardenAccessibilityValue == "0 of 7 plants grown")

    let partial = CheckInState(completedCheckIns: 3)
    #expect(partial.gardenAccessibilityValue == "3 of 7 plants grown")

    let capped = CheckInState(completedCheckIns: 12)
    #expect(capped.gardenAccessibilityValue == "7 of 7 plants grown")
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
