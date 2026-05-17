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

@Test func liveStormProfileReflectsTypingAndMoodWithoutSavingText() {
    let reflection = "I have a project deadline and too much to finish."
    let profile = LocalActionEngine.liveStormProfile(
        selectedMood: .stressed,
        reflectionText: reflection,
        characterLimit: CheckInState.reflectionCharacterLimit
    )

    #expect(profile.theme == .pressure)
    #expect(profile.keywords.contains("project"))
    #expect(profile.keywords.contains("deadline"))
    #expect(profile.caption == "Stressed is coloring a pressure storm.")
    #expect(profile.intensity > 0.34)
    #expect(profile.accessibilityValue.contains("Pressure storm"))
}

@Test func reflectionPrivacyRitualKeepsFullReflectionPrivate() {
    let reflection = "I have a project deadline and too much to finish."
    let profile = LocalActionEngine.liveStormProfile(
        selectedMood: .stressed,
        reflectionText: reflection,
        characterLimit: CheckInState.reflectionCharacterLimit
    )
    let ritual = LocalActionEngine.reflectionPrivacyRitual(for: profile)

    #expect(ritual.title == "Words become weather")
    #expect(ritual.fragments.contains("project"))
    #expect(ritual.detail.contains("BloomMind remembers the shape, not the private words."))
    #expect(!ritual.detail.contains(reflection))
    #expect(!ritual.accessibilityValue.contains(reflection))
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

    #expect(Mood.allCases.count == 8)
    #expect(Set(plantNames).count == Mood.allCases.count)
    #expect(Mood.calm.plantAccessibilityName == "Calm sprout")
    #expect(Mood.happy.plantAccessibilityName == "Sun bloom")
    #expect(Mood.tired.plantAccessibilityName == "Moon bell")
    #expect(Mood.stressed.plantAccessibilityName == "Wind grass")
    #expect(Mood.unsure.plantAccessibilityName == "Question bud")
    #expect(Mood.overwhelmed.plantAccessibilityName == "Storm bloom")
    #expect(Mood.focused.plantAccessibilityName == "Compass bloom")
    #expect(Mood.lonely.plantAccessibilityName == "Signal flower")
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
    #expect(state.gardenSeeds == [GardenSeed(mood: .stressed)])
    #expect(state.gardenSeedsThisWeek.map(\.mood) == [.calm, .stressed])
}

@Test func checkInCompletionStoresSeedConsequence() {
    var state = CheckInState(
        selectedMood: .tired,
        reflectionText: "I slept badly and need a real break.",
        completedCheckIns: 2
    )

    state.completeCheckIn(lane: .release, theme: .rest)

    #expect(state.gardenSeeds.last == GardenSeed(mood: .tired, lane: .release, theme: .rest))
    #expect(state.gardenSeedsThisWeek.last?.lane == .release)
    #expect(state.gardenSeedsThisWeek.last?.theme == .rest)
}

@Test func gardenSeedMemorySummariesStayPrivate() {
    let seed = GardenSeed(mood: .stressed, lane: .release, theme: .pressure)

    #expect(seed.memoryTitle == "Pressure seed")
    #expect(seed.memoryDetail == "This stressed seed became lightened by letting go.")
    #expect(seed.tinyActionMemory == "The tiny action was to let one pressure leave this minute.")
    #expect(seed.worldChangeSummary == "More open air appeared around this plant.")
    #expect(seed.privateMemorySentence == "A pressure seed became lightened by letting go without saving the private words.")
}

@Test func growthLanePhysicsCopyExplainsVisibleConsequences() {
    #expect(GrowthLane.now.physicsTitle == "Heavy enough to root")
    #expect(GrowthLane.now.physicsDetail == "Now fragments land with weight and press roots into the soil.")
    #expect(GrowthLane.later.physicsTitle == "Held in suspension")
    #expect(GrowthLane.release.physicsDetail == "Let go fragments lose weight and dissolve into wind.")
    #expect(GrowthLane.now.focusSproutLine == "Start one tiny minute. The root grows because beginning counts.")
}

@Test func weatherObservatorySnapshotReadsWeekAsPressureLayers() {
    let preview = CheckInState().demoWeekPreviewState()
    let snapshot = preview.weatherObservatorySnapshot

    #expect(snapshot.title == "The week has a sky")
    #expect(snapshot.completedCount == 7)
    #expect(snapshot.totalCount == 7)
    #expect(snapshot.dominantMood == .calm)
    #expect(snapshot.dominantLane == .release)
    #expect(snapshot.pressureLayers.contains(.task))
    #expect(snapshot.pressureLayers.contains(.body))
    #expect(snapshot.pressureLayers.contains(.future))
    #expect(snapshot.pressureLayers.contains(.social))
    #expect(snapshot.lensLine == "The lens shows pressure leaving as wind around the center bloom.")
    #expect(snapshot.accessibilityValue.contains("Pressure layers"))
}

@Test func emptyWeatherObservatoryWaitsForFirstSignal() {
    let snapshot = CheckInState().weatherObservatorySnapshot

    #expect(snapshot.title == "Weather Observatory")
    #expect(snapshot.pressureLayers == [.weather])
    #expect(snapshot.completedCount == 0)
    #expect(snapshot.lensLine == "Enter the storm to make one pressure layer visible.")
}

@Test func weekShapeSummaryKeepsPrivateTextOutOfLandscape() {
    let reflection = "My private project deadline sentence should not reappear."
    let seeds = [
        GardenSeed(mood: .stressed, lane: .now, theme: .pressure),
        GardenSeed(mood: .stressed, lane: .later, theme: .rest),
        GardenSeed(mood: .calm, lane: .release, theme: .school)
    ]
    let summary = LocalActionEngine.weekShapeSummary(
        for: seeds,
        totalCount: CheckInState.weeklyCheckInGoal
    )

    #expect(summary.title == "The week has terrain")
    #expect(summary.detail.contains("stressed toward calm"))
    #expect(summary.terrainLine.contains("pressure ridge"))
    #expect(summary.landmarks[0] == "Day 1: Pressure became Now")
    #expect(!summary.detail.contains(reflection))
    #expect(!summary.terrainLine.contains(reflection))
    #expect(!summary.landmarks.joined().contains(reflection))
}

@Test func artifactCraftingChoicesCreateDifferentFinalGestures() {
    let artifact = LocalActionEngine.weeklyArtifact(for: CheckInState.demoGardenSeeds)

    #expect(ArtifactCraftingChoice.press.craftedLine(for: artifact).hasPrefix("Pressed:"))
    #expect(ArtifactCraftingChoice.release.craftedLine(for: artifact).contains("next seed"))
    #expect(ArtifactCraftingChoice.connect.craftedLine(for: artifact) == "Connected: This was a pressure week that learned to make air. The seven seeds become one sky.")
    #expect(ArtifactCraftingChoice.connect.symbolName == "link.circle")
}

@Test func sensoryObservatoryBuildsSoundscapeInstrumentsAndAtlas() {
    let seeds = CheckInState.demoGardenSeeds
    let soundscape = SensoryObservatory.soundscape(for: seeds)
    let instruments = SensoryObservatory.weatherInstruments(
        for: seeds,
        completedCount: CheckInState.weeklyCheckInGoal,
        totalCount: CheckInState.weeklyCheckInGoal
    )
    let atlas = SensoryObservatory.rareBloomAtlas(for: seeds)
    let season = SensoryObservatory.season(for: seeds)

    #expect(soundscape.events.contains(.bloom))
    #expect(soundscape.accessibilityValue.contains("local sound cues"))
    #expect(instruments.count == 5)
    #expect(instruments.map(\.id).contains("barometer"))
    #expect(atlas.contains { $0.title == "Storm-break bloom" })
    #expect(atlas.contains { $0.title == "Compass bloom" })
    #expect(atlas.contains { $0.title == "Signal flower" })
    #expect(season.title == "Clear season")
}

@Test func seedEvolutionStagesReflectWeekProgressAndLane() {
    let seeds = [
        GardenSeed(mood: .stressed, lane: .release, theme: .pressure),
        GardenSeed(mood: .tired, lane: .later, theme: .rest),
        GardenSeed(mood: .calm, lane: .now, theme: .school)
    ]

    #expect(seeds[0].evolutionStage(index: 0, totalCount: seeds.count) == .blooming)
    #expect(seeds[1].evolutionStage(index: 1, totalCount: seeds.count) == .resting)
    #expect(seeds[2].evolutionStage(index: 2, totalCount: seeds.count) == .justPlanted)

    let fullWeek = CheckInState.demoGardenSeeds
    #expect(fullWeek[0].evolutionStage(index: 0, totalCount: fullWeek.count) == .archived)
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
    completeState = completeState.demoWeekPreviewState()

    let completeReview = completeState.weeklyReview
    #expect(completeReview.title == "This week bloomed")
    #expect(completeReview.detail == "Seven storms became seeds. Calm surfaced most, and let go shaped the garden's ending.")
    #expect(completeReview.accentMood == .calm)
}

@Test func weeklyBloomPayoffUnlocksAfterSevenSeedsWithoutReflectionText() {
    let reflection = "I have a project due today and feel pressure to finish everything."
    var state = CheckInState(
        selectedMood: .stressed,
        reflectionText: reflection,
        completedCheckIns: 6,
        gardenSeeds: [
            GardenSeed(mood: .stressed, lane: .now, theme: .pressure),
            GardenSeed(mood: .tired, lane: .later, theme: .rest),
            GardenSeed(mood: .unsure, lane: .release, theme: .uncertainty),
            GardenSeed(mood: .calm, lane: .now, theme: .school),
            GardenSeed(mood: .happy, lane: .later, theme: .friendship),
            GardenSeed(mood: .stressed, lane: .release, theme: .pressure)
        ]
    )

    #expect(!state.isWeeklyBloomUnlocked)

    state.completeCheckIn(lane: .release, theme: .pressure)

    let payoff = state.weeklyBloomPayoff
    #expect(state.isWeeklyBloomUnlocked)
    #expect(payoff.title == "This week bloomed")
    #expect(payoff.subtitle == "Seven private storms became one visible garden.")
    #expect(payoff.dominantMood == .stressed)
    #expect(payoff.dominantLane == .release)
    #expect(payoff.literacyUnlock.title == "Urgent is not the same as important")
    #expect(payoff.artifact.title == "Weather stone")
    #expect(payoff.artifact.line == "This was a pressure week that learned to make air.")
    #expect(payoff.closingLine == "I can carry less and still keep growing.")
    #expect(!payoff.story.contains(reflection))
    #expect(!payoff.insight.contains(reflection))
    #expect(!payoff.nextWeekIntention.contains(reflection))
    #expect(!payoff.artifact.line.contains(reflection))
    #expect(payoff.privacyNote == "BloomMind remembers the growth pattern, not your private reflection text.")
}

@Test func weeklyBloomPayoffUsesDemoWeekForAwardPath() {
    let preview = CheckInState().demoWeekPreviewState()
    let payoff = preview.weeklyBloomPayoff

    #expect(preview.isWeeklyBloomUnlocked)
    #expect(payoff.dominantMood == .calm)
    #expect(payoff.dominantLane == .release)
    #expect(payoff.story.contains("Steadiness was the clearest color"))
    #expect(payoff.nextWeekIntention.contains("Next week"))
    #expect(payoff.literacyUnlock.detail.contains("Pressure often gets louder"))
    #expect(payoff.artifact.title == "Weather stone")
    #expect(payoff.accessibilityValue.contains("Weather stone"))
}

@Test func weeklyArtifactChoosesPersonalArtifactFromPattern() {
    let tiredSeeds = [
        GardenSeed(mood: .tired, lane: .later, theme: .rest),
        GardenSeed(mood: .tired, lane: .now, theme: .rest),
        GardenSeed(mood: .calm, lane: .later, theme: .school)
    ]
    let unsureSeeds = [
        GardenSeed(mood: .unsure, lane: .now, theme: .uncertainty),
        GardenSeed(mood: .calm, lane: .release, theme: .uncertainty)
    ]

    #expect(LocalActionEngine.weeklyArtifact(for: tiredSeeds).title == "Moon pressed flower")
    #expect(LocalActionEngine.weeklyArtifact(for: unsureSeeds).title == "Question lantern")
}

@Test func returnTomorrowPromptReflectsLatestSeedOrWeeklyBloom() {
    let empty = CheckInState()
    #expect(empty.returnTomorrowPrompt == "Tomorrow, notice one feeling before it turns into weather.")

    let partial = CheckInState(
        completedCheckIns: 1,
        gardenSeeds: [
            GardenSeed(mood: .calm, lane: .later, theme: .school)
        ]
    )
    #expect(partial.returnTomorrowPrompt == "Tomorrow, try parking one worry in Later before it takes over.")

    let full = CheckInState().demoWeekPreviewState()
    #expect(full.returnTomorrowPrompt.contains("Next week"))
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
    #expect(partial.gardenAccessibilityValue == "3 of 7 plants grown: Calm sprout with Now, Sun bloom with Later, Moon bell with Let go")

    let capped = CheckInState(completedCheckIns: 12)
    #expect(
        capped.gardenAccessibilityValue
            == "7 of 7 plants grown: Calm sprout with Now, Sun bloom with Later, Moon bell with Let go, Wind grass with Now, Question bud with Later, Storm bloom with Let go, Compass bloom with Now"
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

@Test func demoWeekPreviewFillsReviewPathWithoutChangingRealWeek() {
    let state = CheckInState(
        selectedMood: .stressed,
        reflectionText: "Everything is loud right now.",
        completedCheckIns: 1,
        gardenMoods: [.stressed]
    )

    let preview = state.demoWeekPreviewState()

    #expect(preview.completedCheckInsThisWeek == CheckInState.weeklyCheckInGoal)
    #expect(preview.gardenMoodsThisWeek == CheckInState.demoGardenMoods)
    #expect(preview.gardenSeedsThisWeek == CheckInState.demoGardenSeeds)
    #expect(preview.selectedMood == nil)
    #expect(preview.reflectionText.isEmpty)
    #expect(state.completedCheckInsThisWeek == 1)
    #expect(state.gardenMoods == [.stressed])
    #expect(state.gardenSeeds.isEmpty)
    #expect(state.selectedMood == .stressed)
    #expect(state.reflectionText == "Everything is loud right now.")
}

@Test func bloomMindJourneyHasOriginAndDirectorDemoArc() {
    let originBeats = BloomMindJourney.originBeats()
    let demoSteps = BloomMindJourney.guidedAwardDemoSteps()

    #expect(originBeats.count == 4)
    #expect(originBeats.first?.title == "Tasks")
    #expect(BloomMindJourney.originLine.contains("weather"))
    #expect(BloomMindJourney.personalMeaningLine.contains("school pressure"))
    #expect(demoSteps.count == 8)
    #expect(demoSteps.map(\.id).contains("wordless"))
    #expect(demoSteps.map(\.id).contains("film"))
    #expect(demoSteps.last?.id == "museum")
    #expect(BloomMindJourney.demoReflection.contains("deadline"))
}

@Test func wordlessStormSignalCanDriveCheckInWithoutReflectionText() {
    var state = CheckInState()
    state.wordlessSignal = WordlessStormSignal(intensity: 0.82, lane: .release)

    #expect(!state.canContinueToAction)
    #expect(state.liveStormProfile.accessibilityValue.contains("School"))
    #expect(state.wordlessSignal?.suggestedMood == .overwhelmed)

    state.selectedMood = state.wordlessSignal?.suggestedMood

    #expect(state.canContinueToAction)
    #expect(state.continueActionAccessibilityHint.contains("wordless"))

    state.completeCheckIn(lane: .release, theme: .pressure)

    #expect(state.wordlessSignal == nil)
    #expect(state.reflectionText.isEmpty)
    #expect(state.gardenSeedsThisWeek.last == GardenSeed(mood: .overwhelmed, lane: .release, theme: .pressure))
}

@Test func stormLayerPeelingShrinksCoreAndRevealsSeed() {
    let keywords = ["exam", "group chat", "sleep", "college"]
    let layers = BloomMindJourney.peelingLayers(for: .school, keywords: keywords)

    #expect(layers == [.task, .social, .body, .future])

    let partial = BloomMindJourney.peelingPlan(
        for: .school,
        keywords: keywords,
        peeledLayers: [.task, .social]
    )
    let complete = BloomMindJourney.peelingPlan(
        for: .school,
        keywords: keywords,
        peeledLayers: Set(layers)
    )

    #expect(partial.coreScale < 1.0)
    #expect(!partial.seedIsVisible)
    #expect(complete.coreScale < partial.coreScale)
    #expect(complete.seedIsVisible)
    #expect(complete.summary.contains("seed"))
}

@Test func carrySeedAndArchiveMuseumKeepWeeklyEndingPrivate() {
    let preview = CheckInState().demoWeekPreviewState()
    let payoff = preview.weeklyBloomPayoff
    let choices = BloomMindJourney.carrySeedChoices(for: payoff)
    let craftedLine = ArtifactCraftingChoice.connect.craftedLine(for: payoff.artifact)
    let museum = BloomMindJourney.archiveMuseum(
        for: preview.gardenSeedsThisWeek,
        payoff: payoff,
        craftedLine: craftedLine,
        selectedCarryLine: choices[0].line
    )

    #expect(choices.count == 3)
    #expect(choices.map(\.line).contains(payoff.nextWeekIntention))
    #expect(museum.rareBlooms.count > 0)
    #expect(!museum.accessibilityValue.localizedCaseInsensitiveContains("reflection text"))
    #expect(museum.craftedLine.contains("Connected:"))
    #expect(museum.carryLine == payoff.closingLine)
}

@Test func soulDetailsNameWeekAndExplainConsequences() {
    let seeds = CheckInState.demoGardenSeeds
    let constellation = BloomMindJourney.pressureConstellationName(for: seeds)
    let change = BloomMindJourney.whatChangedBecauseOfMe(for: GardenSeed(mood: .stressed, lane: .release, theme: .pressure))
    let stamp = BloomMindJourney.memoryStamp(
        for: GardenSeed(mood: .focused, lane: .now, theme: .school),
        dayIndex: 2,
        totalCount: CheckInState.weeklyCheckInGoal,
        calibration: EmotionalCalibrationSignal(loudness: 0.8, heaviness: 0.7)
    )

    #expect(!constellation.title.isEmpty)
    #expect(change.title == "Because you chose Let go")
    #expect(change.detail.contains("sky opened"))
    #expect(stamp.tokens.contains("D3"))
    #expect(stamp.tokens.contains("Focused"))
    #expect(!stamp.detail.localizedCaseInsensitiveContains("reflection text"))
}

@Test func calibrationAndTimeToneCreateLocalSoulDetails() {
    let calibration = EmotionalCalibrationSignal(loudness: 0.9, heaviness: 0.85)
    let morning = BloomMindJourney.timeOfDayGardenTone(
        date: Date(timeIntervalSince1970: 1_710_000_000),
        calendar: Calendar(identifier: .gregorian),
        hasCompletedToday: false,
        completedCount: 2,
        totalCount: CheckInState.weeklyCheckInGoal
    )
    let completed = BloomMindJourney.timeOfDayGardenTone(
        hasCompletedToday: true,
        completedCount: 2,
        totalCount: CheckInState.weeklyCheckInGoal
    )

    #expect(calibration.suggestedMood == .overwhelmed)
    #expect(calibration.generatedStormText.contains("loud"))
    #expect(!morning.title.isEmpty)
    #expect(completed.title == "Open air after planting")
}

@Test func vocabularyUnlocksAndDemoCaptionsSupportJudgingPath() {
    let unlocks = BloomMindJourney.vocabularyUnlocks(for: CheckInState.demoGardenSeeds)
    let captions = BloomMindJourney.guidedAwardDemoSteps().map(\.caption)

    #expect(unlocks.count >= 3)
    #expect(unlocks.contains { $0.line.contains("urgent") || $0.line.contains("sky") })
    #expect(captions.contains("This is the week becoming memory."))
    #expect(captions.last == "This is the ending becoming a beginning.")
}

@Test func carrySeedLineOverridesReturnTomorrowPrompt() {
    let carry = "Carry this exact next seed."
    let state = CheckInState(
        completedCheckIns: CheckInState.weeklyCheckInGoal,
        gardenMoods: CheckInState.demoGardenMoods,
        gardenSeeds: CheckInState.demoGardenSeeds,
        carrySeedLine: carry
    )

    #expect(state.returnTomorrowPrompt == carry)
}

@Test func ideaCycleRoundOneCreatesTenLivingMicroDetails() {
    let firstCycle = BloomMindIdeaCycles.livingMicroDetails

    #expect(firstCycle.title == "Round 1: Living Micro-Details")
    #expect(firstCycle.sparks.count == 10)
    #expect(firstCycle.sparks.contains { $0.id == "thought-fireflies" })
    #expect(firstCycle.sparks.contains { $0.dimension == "Ritual" })
    #expect(firstCycle.accessibilityValue.contains("10 ideas"))
}

@Test func ideaCycleRoundTwoAddsTenReturnHooks() {
    let cycles = BloomMindIdeaCycles.completedCycles()
    let secondCycle = BloomMindIdeaCycles.returnHooks

    #expect(cycles.count == 2)
    #expect(BloomMindIdeaCycles.totalIdeaCount == 20)
    #expect(secondCycle.title == "Round 2: Return Hooks")
    #expect(secondCycle.sparks.count == 10)
    #expect(secondCycle.sparks.contains { $0.id == "no-shame-streak" })
    #expect(secondCycle.sparks.contains { $0.dimension == "Return" })
    #expect(secondCycle.implementedResult.contains("tomorrow"))
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
