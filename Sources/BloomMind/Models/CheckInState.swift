import Foundation

struct GardenWeekReview: Equatable {
    let title: String
    let detail: String
    let accentMood: Mood?
    let completedCount: Int
    let totalCount: Int

    var accessibilityValue: String {
        "\(detail) \(completedCount) of \(totalCount) seeds planted."
    }
}

struct LiveStormProfile: Equatable {
    let theme: ReflectionTheme
    let intensity: Double
    let keywords: [String]
    let caption: String
    let accessibilityValue: String
}

enum GrowthLane: String, CaseIterable, Identifiable {
    case now
    case later
    case release

    var id: String { rawValue }

    var title: String {
        switch self {
        case .now:
            "Now"
        case .later:
            "Later"
        case .release:
            "Let go"
        }
    }

    var symbolName: String {
        switch self {
        case .now:
            "bolt.fill"
        case .later:
            "tray"
        case .release:
            "wind"
        }
    }

    var commitmentLine: String {
        switch self {
        case .now:
            "Start with this one visible step."
        case .later:
            "Park the bigger worry here for after the first step."
        case .release:
            "This is the pressure you do not have to carry right now."
        }
    }

    var emptyText: String {
        switch self {
        case .now:
            "No urgent piece here."
        case .later:
            "Nothing parked here."
        case .release:
            "Nothing to let go here."
        }
    }

    var nextLane: GrowthLane {
        switch self {
        case .now:
            .later
        case .later:
            .release
        case .release:
            .now
        }
    }

    var seedTitle: String {
        switch self {
        case .now:
            "This seed starts with now."
        case .later:
            "This seed protects later."
        case .release:
            "This seed lets one thing go."
        }
    }

    var gardenConsequenceTitle: String {
        switch self {
        case .now:
            "Rooted into now"
        case .later:
            "Held as a bud"
        case .release:
            "Lightened by letting go"
        }
    }

    var gardenConsequenceDetail: String {
        switch self {
        case .now:
            "This choice strengthens the roots because one next step became visible."
        case .later:
            "This choice becomes an unopened bud, keeping the bigger worry outside this minute."
        case .release:
            "This choice leaves more open air in the garden because one pressure was allowed to pass."
        }
    }
}

struct GardenSeed: Equatable {
    let mood: Mood
    let lane: GrowthLane
    let theme: ReflectionTheme

    init(
        mood: Mood,
        lane: GrowthLane = .now,
        theme: ReflectionTheme = .general
    ) {
        self.mood = mood
        self.lane = lane
        self.theme = theme
    }

    var memoryTitle: String {
        "\(theme.displayName) seed"
    }

    var memoryDetail: String {
        "This \(mood.rawValue.lowercased()) seed became \(lane.gardenConsequenceTitle.lowercased())."
    }

    var tinyActionMemory: String {
        switch lane {
        case .now:
            "The tiny action was to make one next step visible."
        case .later:
            "The tiny action was to give the bigger worry a place to wait."
        case .release:
            "The tiny action was to let one pressure leave this minute."
        }
    }

    var privateMemorySentence: String {
        "A \(theme.displayName.lowercased()) seed became \(lane.gardenConsequenceTitle.lowercased()) without saving the private words."
    }

    var worldChangeSummary: String {
        switch lane {
        case .now:
            "Roots grew under this plant."
        case .later:
            "A patient bud appeared beside this plant."
        case .release:
            "More open air appeared around this plant."
        }
    }
}

struct WeeklyLiteracyUnlock: Equatable {
    let title: String
    let detail: String
}

struct WeeklyBloomPayoff: Equatable {
    let title: String
    let subtitle: String
    let story: String
    let insight: String
    let literacyUnlock: WeeklyLiteracyUnlock
    let closingLine: String
    let nextWeekIntention: String
    let privacyNote: String
    let dominantMood: Mood?
    let dominantLane: GrowthLane?
    let completedCount: Int
    let totalCount: Int

    var accessibilityValue: String {
        "\(subtitle) \(story) \(insight) \(literacyUnlock.title). \(literacyUnlock.detail) \(closingLine) \(nextWeekIntention) \(completedCount) of \(totalCount) seeds complete."
    }
}

struct CheckInState {
    static let reflectionCharacterLimit = 160
    static let weeklyCheckInGoal = 7
    static let reflectionPromptText = "Optional: write one or two sentences about what is spinning around you."
    static let localPrivacyDetailText = "Your reflection stays local in this prototype."
    static let completeActionAccessibilityHint = "Plants this seed in the garden and returns to Today."
    static let gardenPreviewTitle = "Emotion garden"
    static let previewDemoWeekActionTitle = "Preview Award Demo"
    static let showMyWeekActionTitle = "Show My Week"
    static let previewDemoWeekActionAccessibilityHint = "Shows a sample completed week without changing your check-ins."
    static let showMyWeekActionAccessibilityHint = "Returns the garden to your actual check-ins."
    static let demoWeekPreviewTitle = "Guided award demo"
    static let demoWeekPreviewDetail = "Your real check-ins are not changed."
    static let originLine = "BloomMind was made for the moment when school pressure stops feeling like tasks and starts feeling like weather."
    static let demoGardenMoods: [Mood] = [
        .stressed,
        .tired,
        .unsure,
        .calm,
        .happy,
        .stressed,
        .calm
    ]
    static let demoGardenSeeds: [GardenSeed] = [
        GardenSeed(mood: .stressed, lane: .now, theme: .pressure),
        GardenSeed(mood: .tired, lane: .later, theme: .rest),
        GardenSeed(mood: .unsure, lane: .release, theme: .uncertainty),
        GardenSeed(mood: .calm, lane: .now, theme: .school),
        GardenSeed(mood: .happy, lane: .later, theme: .friendship),
        GardenSeed(mood: .stressed, lane: .release, theme: .pressure),
        GardenSeed(mood: .calm, lane: .release, theme: .general)
    ]

    var selectedMood: Mood?
    var reflectionText = ""
    var completedCheckIns = 0
    var lastCompletedAt: Date?
    var gardenMoods: [Mood] = []
    var gardenSeeds: [GardenSeed] = []

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
        hasCompletedCheckInToday() ? "Today's storm already became a seed." : "What is spinning around you today?"
    }

    var primaryActionTitle: String {
        hasCompletedCheckInToday() ? "Transform Another Feeling" : "Enter the Storm"
    }

    var primaryActionAccessibilityHint: String {
        hasCompletedCheckInToday() ? "Starts another storm-to-bloom check-in." : "Starts today's storm-to-bloom check-in."
    }

    var todayStatusTitle: String {
        hasCompletedCheckInToday() ? "Today's seed is growing" : "Ready to name the storm"
    }

    var todayStatusDetail: String {
        hasCompletedCheckInToday() ? Self.localPrivacyDetailText : "One minute is enough to separate now from later."
    }

    var bloomEncouragement: String {
        if hasCompletedCheckInToday() {
            return "Today's seed is growing. Let that small action count."
        }

        return switch completedCheckInsThisWeek {
        case 0:
            "A storm gets smaller when one piece becomes visible."
        case 1...3:
            "Your garden is learning the shape of your week."
        case 4...6:
            "Each seed is proof that pressure can become one step."
        default:
            "The weekly garden is full. Let the whole storm feel less abstract."
        }
    }

    var liveStormProfile: LiveStormProfile {
        LocalActionEngine.liveStormProfile(
            selectedMood: selectedMood,
            reflectionText: reflectionText,
            characterLimit: Self.reflectionCharacterLimit
        )
    }

    var weeklyReview: GardenWeekReview {
        let seeds = gardenSeedsThisWeek
        let moods = seeds.map(\.mood)

        guard let newestMood = moods.last else {
            return GardenWeekReview(
                title: "The garden is waiting",
                detail: "The first storm has not become a seed yet.",
                accentMood: nil,
                completedCount: completedCheckInsThisWeek,
                totalCount: Self.weeklyCheckInGoal
            )
        }

        guard let dominantMood = Self.dominantMood(in: moods) else {
            return GardenWeekReview(
                title: "The garden is waiting",
                detail: "The first storm has not become a seed yet.",
                accentMood: nil,
                completedCount: completedCheckInsThisWeek,
                totalCount: Self.weeklyCheckInGoal
            )
        }

        if completedCheckInsThisWeek >= Self.weeklyCheckInGoal {
            let dominantLane = Self.dominantLane(in: seeds) ?? .now
            return GardenWeekReview(
                title: "This week bloomed",
                detail: "\(Self.weeklyGoalWord) storms became seeds. \(dominantMood.rawValue) surfaced most, and \(dominantLane.title.lowercased()) shaped the garden's ending.",
                accentMood: newestMood,
                completedCount: completedCheckInsThisWeek,
                totalCount: Self.weeklyCheckInGoal
            )
        }

        if completedCheckInsThisWeek == 1 {
            return GardenWeekReview(
                title: "One storm has shape now",
                detail: "\(newestMood.rawValue) became the first seed in this week's garden.",
                accentMood: newestMood,
                completedCount: completedCheckInsThisWeek,
                totalCount: Self.weeklyCheckInGoal
            )
        }

        return GardenWeekReview(
            title: "This week is changing shape",
            detail: "\(completedCheckInsThisWeek) storms have become seeds. \(dominantMood.rawValue) is the clearest pattern so far.",
            accentMood: newestMood,
            completedCount: completedCheckInsThisWeek,
            totalCount: Self.weeklyCheckInGoal
        )
    }

    var isWeeklyBloomUnlocked: Bool {
        completedCheckInsThisWeek >= Self.weeklyCheckInGoal && !gardenSeedsThisWeek.isEmpty
    }

    var weeklyBloomPayoff: WeeklyBloomPayoff {
        let seeds = gardenSeedsThisWeek
        let moods = seeds.map(\.mood)
        let dominantMood = Self.dominantMood(in: moods)
        let dominantLane = Self.dominantLane(in: seeds)
        let dominantTheme = Self.dominantTheme(in: seeds)

        guard isWeeklyBloomUnlocked, let dominantMood, let dominantLane else {
            return WeeklyBloomPayoff(
                title: "This week is still growing",
                subtitle: "\(completedCheckInsThisWeek) of \(Self.weeklyCheckInGoal) seeds are planted.",
                story: "The garden is still collecting the shape of this week.",
                insight: "One honest check-in is enough to make the storm less abstract.",
                literacyUnlock: WeeklyLiteracyUnlock(
                    title: "Emotional literacy unlock",
                    detail: "A feeling does not need a perfect label before it can become one small next step."
                ),
                closingLine: "One small seed still counts.",
                nextWeekIntention: "Plant the next seed when one feeling becomes loud enough to name.",
                privacyNote: Self.localPrivacyDetailText,
                dominantMood: dominantMood,
                dominantLane: dominantLane,
                completedCount: completedCheckInsThisWeek,
                totalCount: Self.weeklyCheckInGoal
            )
        }

        return WeeklyBloomPayoff(
            title: "This week bloomed",
            subtitle: "\(Self.weeklyGoalWord) private storms became one visible garden.",
            story: Self.weekStory(
                dominantMood: dominantMood,
                dominantLane: dominantLane,
                dominantTheme: dominantTheme
            ),
            insight: LocalActionEngine.weeklyInsight(for: seeds),
            literacyUnlock: LocalActionEngine.weeklyLiteracyUnlock(for: seeds),
            closingLine: Self.closingLine(
                dominantMood: dominantMood,
                dominantLane: dominantLane
            ),
            nextWeekIntention: LocalActionEngine.nextWeekIntention(for: seeds),
            privacyNote: "BloomMind remembers the growth pattern, not your private reflection text.",
            dominantMood: dominantMood,
            dominantLane: dominantLane,
            completedCount: completedCheckInsThisWeek,
            totalCount: Self.weeklyCheckInGoal
        )
    }

    var returnTomorrowPrompt: String {
        if isWeeklyBloomUnlocked {
            return weeklyBloomPayoff.nextWeekIntention
        }

        guard let newestSeed = gardenSeedsThisWeek.last else {
            return "Tomorrow, notice one feeling before it turns into weather."
        }

        switch newestSeed.lane {
        case .now:
            return "Tomorrow, let one loud task become one visible next step."
        case .later:
            return "Tomorrow, try parking one worry in Later before it takes over."
        case .release:
            return "Tomorrow, let one small thing become air before carrying it."
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
        let grownSeeds = gardenSeedsThisWeek

        guard !grownSeeds.isEmpty else {
            return "0 of \(Self.weeklyCheckInGoal) plants grown. The garden is ready for today's first seed."
        }

        let plantNames = grownSeeds
            .map { seed in
                "\(seed.mood.plantAccessibilityName) with \(seed.lane.title)"
            }
            .joined(separator: ", ")

        return "\(grownSeeds.count) of \(Self.weeklyCheckInGoal) plants grown: \(plantNames)"
    }

    var gardenProgressText: String {
        "\(completedCheckInsThisWeek)/\(Self.weeklyCheckInGoal)"
    }

    var gardenMoodsThisWeek: [Mood] {
        gardenSeedsThisWeek.map(\.mood)
    }

    var gardenSeedsThisWeek: [GardenSeed] {
        let visibleCount = completedCheckInsThisWeek

        guard visibleCount > 0 else {
            return []
        }

        if gardenSeeds.count >= visibleCount {
            return Array(gardenSeeds.suffix(visibleCount))
        }

        if !gardenSeeds.isEmpty {
            let missingCount = visibleCount - gardenSeeds.count
            return Self.fallbackGardenSeeds(count: missingCount) + gardenSeeds
        }

        if gardenMoods.count >= visibleCount {
            return Array(gardenMoods.suffix(visibleCount)).map { mood in
                GardenSeed(mood: mood)
            }
        }

        let missingCount = visibleCount - gardenMoods.count
        return Self.fallbackGardenSeeds(count: missingCount) + gardenMoods.map { mood in
            GardenSeed(mood: mood)
        }
    }

    var continueActionAccessibilityHint: String {
        canContinueToAction
            ? "Shows a small growth action."
            : "Select a mood to continue."
    }

    var canContinueToAction: Bool {
        selectedMood != nil && isReflectionWithinLimit
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

    mutating func completeCheckIn(
        lane: GrowthLane = .now,
        theme: ReflectionTheme = .general,
        on date: Date = Date()
    ) {
        let completedMood = selectedMood ?? .unsure
        completedCheckIns = max(completedCheckIns, 0) + 1
        lastCompletedAt = date
        gardenMoods.append(completedMood)
        gardenSeeds.append(GardenSeed(
            mood: completedMood,
            lane: lane,
            theme: theme
        ))
        selectedMood = nil
        reflectionText = ""
    }

    func demoWeekPreviewState() -> CheckInState {
        var preview = self
        preview.completedCheckIns = Self.weeklyCheckInGoal
        preview.gardenMoods = Self.demoGardenMoods
        preview.gardenSeeds = Self.demoGardenSeeds
        preview.selectedMood = nil
        preview.reflectionText = ""
        return preview
    }

    private static func fallbackGardenMoods(count: Int) -> [Mood] {
        guard count > 0 else {
            return []
        }

        let moods = Mood.allCases
        return (0..<count).map { index in
            moods[index % moods.count]
        }
    }

    private static func fallbackGardenSeeds(count: Int) -> [GardenSeed] {
        fallbackGardenMoods(count: count).enumerated().map { index, mood in
            GardenSeed(
                mood: mood,
                lane: GrowthLane.allCases[index % GrowthLane.allCases.count],
                theme: .general
            )
        }
    }

    private static var weeklyGoalWord: String {
        switch weeklyCheckInGoal {
        case 7:
            "Seven"
        default:
            "\(weeklyCheckInGoal)"
        }
    }

    private static func dominantMood(in moods: [Mood]) -> Mood? {
        guard !moods.isEmpty else {
            return nil
        }

        let counts = moods.reduce(into: [Mood: Int]()) { partialResult, mood in
            partialResult[mood, default: 0] += 1
        }

        var dominant = moods[moods.index(before: moods.endIndex)]
        var dominantCount = counts[dominant, default: 0]

        for mood in moods.reversed() {
            let count = counts[mood, default: 0]
            if count > dominantCount {
                dominant = mood
                dominantCount = count
            }
        }

        return dominant
    }

    private static func dominantLane(in seeds: [GardenSeed]) -> GrowthLane? {
        dominantValue(in: seeds.map(\.lane))
    }

    private static func dominantTheme(in seeds: [GardenSeed]) -> ReflectionTheme {
        dominantValue(in: seeds.map(\.theme)) ?? .general
    }

    private static func dominantValue<Value: Hashable>(in values: [Value]) -> Value? {
        guard let newest = values.last else {
            return nil
        }

        let counts = values.reduce(into: [Value: Int]()) { partialResult, value in
            partialResult[value, default: 0] += 1
        }

        var dominant = newest
        var dominantCount = counts[dominant, default: 0]

        for value in values.reversed() {
            let count = counts[value, default: 0]
            if count > dominantCount {
                dominant = value
                dominantCount = count
            }
        }

        return dominant
    }

    private static func weekStory(
        dominantMood: Mood,
        dominantLane: GrowthLane,
        dominantTheme: ReflectionTheme
    ) -> String {
        let moodLine = switch dominantMood {
        case .calm:
            "Steadiness was the clearest color in this garden."
        case .happy:
            "Bright energy kept returning, even inside a busy week."
        case .tired:
            "This was a lower-energy week, but it still found a way to grow."
        case .stressed:
            "Pressure showed up often, but it did not stay formless."
        case .unsure:
            "Uncertainty appeared often, and the garden turned it into questions instead of fog."
        }

        let laneLine = switch dominantLane {
        case .now:
            "You kept choosing one visible step instead of carrying the whole storm."
        case .later:
            "You practiced giving bigger worries a place to wait."
        case .release:
            "You made room by letting some pressure leave this minute."
        }

        let themeLine = dominantTheme == .general
            ? "The exact theme did not need to be perfect for the week to make sense."
            : "\(dominantTheme.displayName) was the loudest theme, but it became part of the garden instead of the whole sky."

        return "\(moodLine) \(laneLine) \(themeLine)"
    }

    private static func closingLine(
        dominantMood: Mood,
        dominantLane: GrowthLane
    ) -> String {
        switch (dominantMood, dominantLane) {
        case (.stressed, .release):
            "I can carry less and still keep growing."
        case (.tired, _):
            "Rest can be part of growth, not proof that I fell behind."
        case (.unsure, .now):
            "One clear question can be enough for today."
        case (_, .later):
            "Not everything has to be solved in the same minute."
        case (_, .release):
            "Letting go can be an action too."
        case (.happy, _):
            "Good energy is worth noticing, not rushing past."
        case (.calm, _):
            "Steady things count."
        default:
            "One small step still changes the shape of the week."
        }
    }
}
