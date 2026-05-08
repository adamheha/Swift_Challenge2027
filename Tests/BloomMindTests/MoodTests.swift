import Foundation
import Testing
@testable import BloomMind

@Test func moodSupportCopyMatchesMood() {
    #expect(Mood.stressed.accessibilityHint == "Selects stressed as your current mood.")
    #expect(Mood.tired.symbolName == "moon")
}

@Test func reflectionThemeDetectionMatchesSimpleStudentThemes() {
    #expect(LocalActionEngine.detectTheme(in: "I have a math test and homework tonight.") == .school)
    #expect(LocalActionEngine.detectTheme(in: "Studying for quizzes makes the evening feel busy.") == .school)
    #expect(LocalActionEngine.detectTheme(in: "My friend and I had an argument at lunch.") == .friendship)
    #expect(LocalActionEngine.detectTheme(in: "I slept badly and need a real break.") == .rest)
    #expect(LocalActionEngine.detectTheme(in: "Everything is due today and I feel too much pressure.") == .pressure)
    #expect(LocalActionEngine.detectTheme(in: "I am not sure what choice makes sense.") == .uncertainty)
}

@Test func reflectionThemeDetectionFallsBackToGeneral() {
    #expect(LocalActionEngine.detectTheme(in: "") == .general)
    #expect(LocalActionEngine.detectTheme(in: "The afternoon feels kind of ordinary.") == .general)
}

@Test func localActionEngineCombinesMoodAndTheme() {
    let tiredSchool = LocalActionEngine.suggestion(
        for: .tired,
        reflectionText: "I have homework and a quiz tomorrow."
    )
    let calmSchool = LocalActionEngine.suggestion(
        for: .calm,
        reflectionText: "I have homework and a quiz tomorrow."
    )
    let tiredRest = LocalActionEngine.suggestion(
        for: .tired,
        reflectionText: "I am exhausted and need sleep."
    )

    #expect(tiredSchool.theme == .school)
    #expect(tiredSchool.title == "A tiny school step for tired")
    #expect(tiredSchool.action == "Make it gentle: write the school task that matters most, then do the first two minutes.")
    #expect(calmSchool.action == "Keep it steady: write the school task that matters most, then do the first two minutes.")
    #expect(tiredRest.action == "Make it gentle: take a real pause with water, a stretch, or two minutes with your eyes closed.")
}

@Test func localActionEngineAddsEmotionalLiteracyInsight() {
    let reflection = "Everything is due today and I feel too much pressure."
    let suggestion = LocalActionEngine.suggestion(for: .stressed, reflectionText: reflection)

    #expect(suggestion.theme == .pressure)
    #expect(suggestion.nowStep == "Choose the next tiny step and make it physically visible.")
    #expect(suggestion.laterStep == "Everything after the first step belongs in later, not in now.")
    #expect(suggestion.releaseStep == "You do not need to carry every urgent thing at the same volume.")
    #expect(
        suggestion.literacyInsight
            == "Pressure often feels bigger when every task looks urgent. Separating now from later can make the next step easier to start."
    )
    #expect(!suggestion.literacyInsight.contains(reflection))
}

@Test func localActionEngineExplanationKeepsReflectionPrivate() {
    let reflection = "My friend Maya ignored my message and I felt left out."
    let suggestion = LocalActionEngine.suggestion(
        for: .unsure,
        reflectionText: reflection
    )

    #expect(suggestion.theme == .friendship)
    #expect(!suggestion.action.contains(reflection))
    #expect(!suggestion.explanation.contains(reflection))
    #expect(suggestion.explanation.contains("The reflection stays on this device."))
}

@Test func moodPlantAccessibilityNamesAreDistinct() {
    let plantNames = Mood.allCases.map(\.plantAccessibilityName)

    #expect(Set(plantNames).count == Mood.allCases.count)
    #expect(Mood.calm.plantAccessibilityName == "Calm sprout")
    #expect(Mood.happy.plantAccessibilityName == "Sun bloom")
    #expect(Mood.tired.plantAccessibilityName == "Moon bell")
    #expect(Mood.stressed.plantAccessibilityName == "Wind grass")
    #expect(Mood.unsure.plantAccessibilityName == "Question bud")
}

@Test func moodGardenReflectionNotesAreSpecificAndPrivate() {
    let notes = Mood.allCases.map(\.gardenReflectionNote)
    let prompts = Mood.allCases.map(\.gardenRevisitPrompt)

    #expect(Set(notes).count == Mood.allCases.count)
    #expect(Set(prompts).count == Mood.allCases.count)
    #expect(Mood.stressed.gardenReflectionNote == "This plant marks a check-in where pressure became one smaller next step.")
    #expect(Mood.stressed.gardenRevisitPrompt == "Look for one task that can wait before starting the next tiny step.")
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

@Test func checkInCompletionAddsSelectedMoodToGarden() {
    var state = CheckInState(
        selectedMood: .stressed,
        reflectionText: "I have a lot to finish.",
        completedCheckIns: 1
    )

    state.completeCheckIn()

    #expect(state.gardenMoods == [.stressed])
    #expect(state.gardenMoodsThisWeek == [.calm, .stressed])
}

@Test func checkInCompletionUsesUnsurePlantWhenMoodIsMissing() {
    var state = CheckInState()

    state.completeCheckIn()

    #expect(state.gardenMoods == [.unsure])
    #expect(state.gardenMoodsThisWeek == [.unsure])
}

@Test func checkInCompletionNormalizesNegativeProgress() {
    var state = CheckInState(completedCheckIns: -2)

    state.completeCheckIn()

    #expect(state.completedCheckIns == 1)
    #expect(state.completedCheckInsThisWeek == 1)
}

@Test func checkInCanContinueRequiresMoodOnlyAndValidReflectionLength() {
    var state = CheckInState()
    #expect(!state.canContinueToAction)

    state.selectedMood = .calm
    #expect(state.canContinueToAction)

    state.reflectionText = "   "
    #expect(state.canContinueToAction)

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
    #expect(CheckInState(completedCheckIns: -2).bloomEncouragement == "A storm gets smaller when one piece becomes visible.")
    #expect(CheckInState(completedCheckIns: 0).bloomEncouragement == "A storm gets smaller when one piece becomes visible.")
    #expect(CheckInState(completedCheckIns: 2).bloomEncouragement == "Your garden is learning the shape of your week.")
    #expect(CheckInState(completedCheckIns: 5).bloomEncouragement == "Each seed is proof that pressure can become one step.")
    #expect(
        CheckInState(completedCheckIns: CheckInState.weeklyCheckInGoal).bloomEncouragement
            == "The weekly garden is full. Let the whole storm feel less abstract."
    )
}

@Test func weeklyReviewReflectsEmptyPartialAndCompleteGardens() {
    let emptyReview = CheckInState().weeklyReview
    #expect(emptyReview.title == "The garden is waiting")
    #expect(emptyReview.detail == "The first storm has not become a seed yet.")
    #expect(emptyReview.accentMood == nil)
    #expect(emptyReview.accessibilityValue == "The first storm has not become a seed yet. 0 of 7 seeds planted.")

    let partialReview = CheckInState(completedCheckIns: 3).weeklyReview
    #expect(partialReview.title == "This week is changing shape")
    #expect(partialReview.detail == "3 storms have become seeds. Tired is the clearest pattern so far.")
    #expect(partialReview.accentMood == .tired)

    var completeState = CheckInState()
    completeState.replayDemoWeek()

    let completeReview = completeState.weeklyReview
    #expect(completeReview.title == "A full week changed shape")
    #expect(completeReview.detail == "Seven storms became seeds. Calm surfaced most, and the newest seed ends as calm.")
    #expect(completeReview.accentMood == .calm)
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
    #expect(state.bloomEncouragement == "Today's seed is growing. Let that small action count.")
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
    #expect(CheckInState.completeActionAccessibilityHint == "Plants this seed in the garden and returns to Today.")
}

@Test func continueActionAccessibilityHintReflectsReadiness() {
    let empty = CheckInState()
    #expect(empty.continueActionAccessibilityHint == "Select a mood to continue.")

    let ready = CheckInState(
        selectedMood: .calm
    )
    #expect(ready.continueActionAccessibilityHint == "Shows a small growth action.")
}

@Test func finalDemoPathKeepsOneMinuteActionStable() {
    let reflection = "I have a project due today and feel pressure to finish everything."
    let suggestion = LocalActionEngine.suggestion(for: .stressed, reflectionText: reflection)

    #expect(suggestion.theme == .pressure)
    #expect(suggestion.title == "A tiny pressure step for stressed")
    #expect(suggestion.action == "Make it tiny: choose one thing that can wait, then start only the next tiny step.")
    #expect(!suggestion.explanation.contains(reflection))
}

@Test func homeCopyReflectsIncompleteAndCompleteStates() {
    let notCompleted = CheckInState()
    #expect(notCompleted.todayPrompt == "What is spinning around you today?")
    #expect(notCompleted.primaryActionTitle == "Enter the Storm")
    #expect(notCompleted.primaryActionAccessibilityHint == "Starts today's storm-to-bloom check-in.")
    #expect(notCompleted.todayStatusTitle == "Ready to name the storm")
    #expect(notCompleted.todayStatusDetail == "One minute is enough to separate now from later.")

    var completed = CheckInState()
    completed.completeCheckIn()
    #expect(completed.todayPrompt == "Today's storm already became a seed.")
    #expect(completed.primaryActionTitle == "Transform Another Feeling")
    #expect(completed.primaryActionAccessibilityHint == "Starts another storm-to-bloom check-in.")
    #expect(completed.todayStatusTitle == "Today's seed is growing")
    #expect(completed.todayStatusDetail == CheckInState.localPrivacyDetailText)
}

@Test func gardenAccessibilityValueReflectsWeeklyProgress() {
    let floor = CheckInState(completedCheckIns: -2)
    #expect(floor.gardenAccessibilityValue == "0 of 7 plants grown. The garden is ready for today's first seed.")

    let partial = CheckInState(completedCheckIns: 3)
    #expect(partial.gardenAccessibilityValue == "3 of 7 plants grown: Calm sprout, Sun bloom, Moon bell")

    let capped = CheckInState(completedCheckIns: 12)
    #expect(
        capped.gardenAccessibilityValue
            == "7 of 7 plants grown: Calm sprout, Sun bloom, Moon bell, Wind grass, Question bud, Calm sprout, Sun bloom"
    )
}

@Test func gardenProgressTextReflectsClampedWeeklyProgress() {
    #expect(CheckInState(completedCheckIns: -2).gardenProgressText == "0/7")
    #expect(CheckInState(completedCheckIns: 3).gardenProgressText == "3/7")
    #expect(CheckInState(completedCheckIns: 12).gardenProgressText == "7/7")
}

@Test func gardenPreviewTitleMatchesHomeCopy() {
    #expect(CheckInState.gardenPreviewTitle == "Emotion garden")
}

@Test func gardenMoodsThisWeekUsesFallbackForLegacyProgress() {
    let state = CheckInState(completedCheckIns: 4)

    #expect(state.gardenMoodsThisWeek == [.calm, .happy, .tired, .stressed])
}

@Test func gardenMoodsThisWeekKeepsMostRecentPlantsWithinGoal() {
    let moods: [Mood] = [
        .calm,
        .happy,
        .tired,
        .stressed,
        .unsure,
        .calm,
        .happy,
        .tired
    ]
    let state = CheckInState(completedCheckIns: 8, gardenMoods: moods)

    #expect(state.gardenMoodsThisWeek == Array(moods.suffix(CheckInState.weeklyCheckInGoal)))
}

@Test func replayDemoWeekFillsOneMinuteReviewPath() {
    var state = CheckInState(
        selectedMood: .stressed,
        reflectionText: "Everything is loud right now.",
        completedCheckIns: 1,
        gardenMoods: [.stressed]
    )

    state.replayDemoWeek()

    #expect(state.completedCheckInsThisWeek == CheckInState.weeklyCheckInGoal)
    #expect(state.gardenMoodsThisWeek == CheckInState.demoGardenMoods)
    #expect(state.selectedMood == nil)
    #expect(state.reflectionText.isEmpty)
    #expect(state.hasCompletedCheckInToday())
}

@MainActor
@Test func stepProgressAccessibilityClampsOutOfRangeSteps() {
    let beforeFirstStep = StepProgressView(currentStep: 0)
    #expect(beforeFirstStep.displayedStepNumber == 1)
    #expect(beforeFirstStep.accessibilitySummary == "Check-in step 1 of 3, Name")

    let afterLastStep = StepProgressView(currentStep: 4)
    #expect(afterLastStep.displayedStepNumber == 3)
    #expect(afterLastStep.accessibilitySummary == "Check-in step 3 of 3, Grow")
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
