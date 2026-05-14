import Foundation
#if canImport(NaturalLanguage)
import NaturalLanguage
#endif

enum ReflectionTheme: String, CaseIterable, Identifiable {
    case school
    case friendship
    case rest
    case pressure
    case uncertainty
    case general

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .school:
            "School"
        case .friendship:
            "Friendship"
        case .rest:
            "Rest"
        case .pressure:
            "Pressure"
        case .uncertainty:
            "Uncertainty"
        case .general:
            "General"
        }
    }

    var symbolName: String {
        switch self {
        case .school:
            "book.closed"
        case .friendship:
            "person.2"
        case .rest:
            "moon"
        case .pressure:
            "timer"
        case .uncertainty:
            "questionmark.circle"
        case .general:
            "sparkle"
        }
    }
}

struct GrowthActionSuggestion: Equatable {
    let mood: Mood
    let theme: ReflectionTheme
    let title: String
    let action: String
    let nowStep: String
    let laterStep: String
    let releaseStep: String
    let explanation: String
    let literacyInsight: String
}

enum LocalActionEngine {
    static func liveStormProfile(
        selectedMood: Mood?,
        reflectionText: String,
        characterLimit: Int
    ) -> LiveStormProfile {
        let theme = detectTheme(in: reflectionText)
        let trimmed = reflectionText.trimmingCharacters(in: .whitespacesAndNewlines)
        let progress = min(Double(trimmed.count) / Double(max(characterLimit, 1)), 1)
        let moodRelief = selectedMood == nil ? 0 : 0.16
        let themeLift = theme == .general ? 0 : 0.08
        let intensity = min(max(0.34 + progress * 0.46 + themeLift - moodRelief, 0.24), 0.96)
        let keywords = liveKeywords(in: trimmed, theme: theme)
        let caption: String

        if trimmed.isEmpty {
            caption = "The storm is waiting for one honest phrase."
        } else if selectedMood == nil {
            caption = "\(theme.displayName) is starting to appear in the weather."
        } else {
            caption = "\(selectedMood?.rawValue ?? "This mood") is coloring a \(theme.displayName.lowercased()) storm."
        }

        return LiveStormProfile(
            theme: theme,
            intensity: intensity,
            keywords: keywords,
            caption: caption,
            accessibilityValue: "\(theme.displayName) storm, \(Int((intensity * 100).rounded())) percent intensity. \(caption)"
        )
    }

    static func detectTheme(in reflectionText: String) -> ReflectionTheme {
        let detectionText = DetectionText(reflectionText)

        guard !detectionText.normalizedText.isEmpty else {
            return .general
        }

        var bestTheme = ReflectionTheme.general
        var bestScore = 0

        for theme in detectableThemes {
            let score = theme.keywords.reduce(0) { partialScore, keyword in
                partialScore + (contains(keyword: keyword, in: detectionText) ? 1 : 0)
            }

            if score > bestScore {
                bestTheme = theme
                bestScore = score
            }
        }

        return bestTheme
    }

    static func suggestion(for mood: Mood, reflectionText: String) -> GrowthActionSuggestion {
        let theme = detectTheme(in: reflectionText)
        let action = "\(mood.localActionTone) \(theme.actionStep)"

        return GrowthActionSuggestion(
            mood: mood,
            theme: theme,
            title: "A tiny \(theme.titleNoun) step for \(mood.rawValue.lowercased())",
            action: action,
            nowStep: theme.nowStep,
            laterStep: theme.laterStep,
            releaseStep: theme.releaseStep,
            explanation: explanation(for: mood, theme: theme),
            literacyInsight: theme.literacyInsight
        )
    }

    static func weeklyInsight(for seeds: [GardenSeed]) -> String {
        guard
            let dominantMood = dominantValue(in: seeds.map(\.mood)),
            let dominantLane = dominantValue(in: seeds.map(\.lane))
        else {
            return "The garden is still learning the shape of this week."
        }

        return "\(dominantMood.weeklyInsightSentence) \(dominantLane.weeklyInsightSentence)"
    }

    static func nextWeekIntention(for seeds: [GardenSeed]) -> String {
        guard
            let dominantMood = dominantValue(in: seeds.map(\.mood)),
            let dominantLane = dominantValue(in: seeds.map(\.lane)),
            let dominantTheme = dominantValue(in: seeds.map(\.theme))
        else {
            return "Next week, plant one seed when a feeling becomes loud enough to name."
        }

        let themePhrase = dominantTheme.nextWeekThemePhrase
        let lanePhrase = dominantLane.nextWeekLanePhrase
        return "Next week, notice \(themePhrase) early and \(lanePhrase) when the storm starts to gather. \(dominantMood.nextWeekMoodReminder)"
    }

    static func weeklyLiteracyUnlock(for seeds: [GardenSeed]) -> WeeklyLiteracyUnlock {
        let theme = dominantValue(in: seeds.map(\.theme)) ?? .general
        let mood = dominantValue(in: seeds.map(\.mood))

        if theme != .general {
            return WeeklyLiteracyUnlock(
                title: theme.literacyUnlockTitle,
                detail: theme.literacyUnlockDetail
            )
        }

        return WeeklyLiteracyUnlock(
            title: mood?.literacyUnlockTitle ?? "Growth does not need one mood",
            detail: mood?.literacyUnlockDetail ?? "A mixed week can still have a shape when each feeling becomes one small seed."
        )
    }

    static func reflectionPrivacyRitual(for profile: LiveStormProfile) -> ReflectionPrivacyRitual {
        let fragments = profile.keywords.isEmpty ? profile.theme.liveStormWords : profile.keywords
        let safeFragments = Array(fragments.prefix(5))
        let themeName = profile.theme.displayName.lowercased()

        return ReflectionPrivacyRitual(
            title: "Words become weather",
            detail: "The reflection becomes \(themeName) fragments for this ritual. BloomMind remembers the shape, not the private words.",
            fragments: safeFragments,
            accessibilityValue: "Reflection privacy ritual. \(safeFragments.joined(separator: ", ")) become storm fragments. BloomMind remembers the shape, not the private words."
        )
    }

    static func pressureLayers(for seeds: [GardenSeed]) -> [PressureLayer] {
        var seen = Set<PressureLayer>()
        var layers: [PressureLayer] = []

        for seed in seeds {
            let layer = seed.theme.pressureLayer
            guard !seen.contains(layer) else {
                continue
            }

            seen.insert(layer)
            layers.append(layer)
        }

        return layers.isEmpty ? [.weather] : layers
    }

    static func weatherObservatorySnapshot(
        for seeds: [GardenSeed],
        completedCount: Int,
        totalCount: Int
    ) -> WeatherObservatorySnapshot {
        let visibleCount = min(max(completedCount, 0), max(totalCount, 0))
        let dominantMood = dominantValue(in: seeds.map(\.mood))
        let dominantLane = dominantValue(in: seeds.map(\.lane))
        let layers = pressureLayers(for: seeds)

        guard !seeds.isEmpty else {
            return WeatherObservatorySnapshot(
                title: "Weather Observatory",
                detail: "No inner weather has been observed yet.",
                skyLine: "The lens is clear, waiting for the first storm signal.",
                lensLine: "Enter the storm to make one pressure layer visible.",
                pressureLayers: layers,
                dominantMood: nil,
                dominantLane: nil,
                completedCount: visibleCount,
                totalCount: totalCount
            )
        }

        let title = visibleCount >= totalCount
            ? "The week has a sky"
            : "The week is forming weather"
        let detail = "\(visibleCount) of \(totalCount) storm signals have reached the observatory."
        let skyLine = dominantMood?.observatorySkyLine ?? "Mixed weather is becoming readable."
        let lensLine = dominantLane?.observatoryLensLine ?? "The lens is still deciding where the pressure wants to go."

        return WeatherObservatorySnapshot(
            title: title,
            detail: detail,
            skyLine: skyLine,
            lensLine: lensLine,
            pressureLayers: layers,
            dominantMood: dominantMood,
            dominantLane: dominantLane,
            completedCount: visibleCount,
            totalCount: totalCount
        )
    }

    static func weekShapeSummary(
        for seeds: [GardenSeed],
        totalCount: Int
    ) -> WeekShapeSummary {
        guard let firstSeed = seeds.first else {
            return WeekShapeSummary(
                title: "No terrain yet",
                detail: "The first seed will draw the first point on the emotional landscape.",
                terrainLine: "The week has not made a line yet.",
                landmarks: ["Seed 1 is waiting"],
                completedCount: 0,
                totalCount: totalCount
            )
        }

        let latestSeed = seeds.last ?? firstSeed
        let dominantMood = dominantValue(in: seeds.map(\.mood)) ?? latestSeed.mood
        let dominantLane = dominantValue(in: seeds.map(\.lane)) ?? latestSeed.lane
        let movementLine: String

        if firstSeed.mood == latestSeed.mood {
            movementLine = "The week kept returning to \(latestSeed.mood.rawValue.lowercased()), but the choices still changed its shape."
        } else {
            movementLine = "The week moved from \(firstSeed.mood.rawValue.lowercased()) toward \(latestSeed.mood.rawValue.lowercased())."
        }

        let landmarks = seeds.prefix(totalCount).enumerated().map { index, seed in
            "Day \(index + 1): \(seed.theme.displayName) became \(seed.lane.title)"
        }

        return WeekShapeSummary(
            title: "The week has terrain",
            detail: "\(movementLine) \(dominantLane.title) was the strongest shaping force.",
            terrainLine: "\(dominantMood.weekShapeTerrain) \(dominantLane.weekShapeForce)",
            landmarks: landmarks,
            completedCount: min(seeds.count, max(totalCount, 0)),
            totalCount: totalCount
        )
    }

    static func weeklyArtifact(for seeds: [GardenSeed]) -> WeeklyBloomArtifact {
        let dominantMood = dominantValue(in: seeds.map(\.mood))
        let dominantLane = dominantValue(in: seeds.map(\.lane))
        let dominantTheme = dominantValue(in: seeds.map(\.theme)) ?? .general

        switch (dominantMood, dominantLane, dominantTheme) {
        case (.stressed?, .release?, _), (_, .release?, .pressure):
            return WeeklyBloomArtifact(
                title: "Weather stone",
                detail: "A small artifact for a pressure week that made more air.",
                line: "This was a pressure week that learned to make air.",
                symbolName: "wind",
                dominantMood: dominantMood,
                dominantLane: dominantLane
            )
        case (.tired?, _, _), (_, .later?, .rest):
            return WeeklyBloomArtifact(
                title: "Moon pressed flower",
                detail: "A quiet artifact for a week that protected rest and smaller steps.",
                line: "This was a tired week that still found a softer way to grow.",
                symbolName: "moon.stars",
                dominantMood: dominantMood,
                dominantLane: dominantLane
            )
        case (_, .now?, .school), (.calm?, .now?, _):
            return WeeklyBloomArtifact(
                title: "Root compass",
                detail: "A grounded artifact for a week that kept choosing the visible next step.",
                line: "This week turned a whole sky into one step at a time.",
                symbolName: "arrow.down.right.circle",
                dominantMood: dominantMood,
                dominantLane: dominantLane
            )
        case (.unsure?, _, _), (_, _, .uncertainty):
            return WeeklyBloomArtifact(
                title: "Question lantern",
                detail: "A soft artifact for a week that changed fog into answerable questions.",
                line: "This week did not need certainty before it could move.",
                symbolName: "questionmark.bubble",
                dominantMood: dominantMood,
                dominantLane: dominantLane
            )
        case (.happy?, _, _), (_, .later?, .friendship):
            return WeeklyBloomArtifact(
                title: "Sun archive",
                detail: "A warm artifact for a week that remembered bright moments too.",
                line: "This week let good energy become part of the record.",
                symbolName: "sun.max",
                dominantMood: dominantMood,
                dominantLane: dominantLane
            )
        default:
            return WeeklyBloomArtifact(
                title: "Pressed bloom",
                detail: "A private artifact for a mixed week that still became one garden.",
                line: "This was a mixed week that still learned its shape.",
                symbolName: "sparkles.rectangle.stack",
                dominantMood: dominantMood,
                dominantLane: dominantLane
            )
        }
    }

    private static let detectableThemes: [ReflectionTheme] = [
        .pressure,
        .school,
        .friendship,
        .rest,
        .uncertainty
    ]

    private static func normalized(_ text: String) -> String {
        text
            .folding(options: [.caseInsensitive, .diacriticInsensitive], locale: Locale(identifier: "en_US_POSIX"))
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }

    private static func liveKeywords(in text: String, theme: ReflectionTheme) -> [String] {
        let normalizedText = normalized(text)
        let stopWords: Set<String> = [
            "a", "an", "and", "are", "as", "at", "be", "but", "can", "do", "for", "have",
            "i", "in", "is", "it", "me", "my", "of", "on", "or", "so", "that", "the",
            "this", "to", "too", "was", "with"
        ]
        let typedTerms = normalizedText
            .split(separator: " ")
            .map(String.init)
            .filter { term in
                term.count > 2 && !stopWords.contains(term)
            }

        let combined = typedTerms + theme.liveStormWords
        var seen = Set<String>()
        var result: [String] = []

        for term in combined {
            guard !seen.contains(term) else {
                continue
            }

            seen.insert(term)
            result.append(term)

            if result.count == 5 {
                break
            }
        }

        return result.isEmpty ? theme.liveStormWords : result
    }

    private static func contains(keyword: String, in detectionText: DetectionText) -> Bool {
        let normalizedKeyword = normalized(keyword)

        if normalizedKeyword.contains(" ") {
            return detectionText.normalizedText.contains(normalizedKeyword)
        }

        return detectionText.terms.contains(normalizedKeyword)
    }

    private static func explanation(for mood: Mood, theme: ReflectionTheme) -> String {
        if theme == .general {
            return "No specific theme was detected, so this uses your \(mood.rawValue.lowercased()) mood to keep the next step simple. The reflection stays on this device."
        }

        return "This looks like a \(theme.displayName.lowercased()) theme, detected locally, and uses your \(mood.rawValue.lowercased()) mood to keep the next step small. The reflection stays on this device."
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

    private struct DetectionText {
        let normalizedText: String
        let terms: Set<String>

        init(_ text: String) {
            normalizedText = LocalActionEngine.normalized(text)

            var detectedTerms = Set(normalizedText.split(separator: " ").map(String.init))
            detectedTerms.formUnion(Self.naturalLanguageTerms(in: text))
            terms = detectedTerms
        }

        private static func naturalLanguageTerms(in text: String) -> Set<String> {
            #if canImport(NaturalLanguage)
            guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                return []
            }

            let tagger = NLTagger(tagSchemes: [.lemma])
            tagger.string = text
            let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
            var terms = Set<String>()

            tagger.enumerateTags(
                in: text.startIndex..<text.endIndex,
                unit: .word,
                scheme: .lemma,
                options: options
            ) { tag, tokenRange in
                let candidates = [
                    String(text[tokenRange]),
                    tag?.rawValue
                ].compactMap { $0 }

                for candidate in candidates {
                    let normalizedCandidate = LocalActionEngine.normalized(candidate)
                    let candidateTerms = normalizedCandidate.split(separator: " ").map(String.init)
                    terms.formUnion(candidateTerms)
                }

                return true
            }

            return terms
            #else
            return []
            #endif
        }
    }
}

private extension ReflectionTheme {
    var pressureLayer: PressureLayer {
        switch self {
        case .school:
            .task
        case .friendship:
            .social
        case .rest:
            .body
        case .pressure:
            .task
        case .uncertainty:
            .future
        case .general:
            .weather
        }
    }

    var keywords: [String] {
        switch self {
        case .school:
            [
                "school",
                "class",
                "homework",
                "assignment",
                "assignments",
                "project",
                "teacher",
                "grade",
                "grades",
                "test",
                "quiz",
                "quizzes",
                "exam",
                "study",
                "studying"
            ]
        case .friendship:
            [
                "friend",
                "friends",
                "friendship",
                "classmate",
                "teammate",
                "group",
                "texted",
                "message",
                "argument",
                "lonely",
                "left out"
            ]
        case .rest:
            [
                "rest",
                "sleep",
                "slept",
                "nap",
                "bed",
                "tired",
                "exhausted",
                "drained",
                "energy",
                "break"
            ]
        case .pressure:
            [
                "pressure",
                "pressured",
                "stress",
                "stressed",
                "overwhelmed",
                "deadline",
                "due",
                "busy",
                "rush",
                "late",
                "too much"
            ]
        case .uncertainty:
            [
                "uncertain",
                "unsure",
                "confused",
                "lost",
                "maybe",
                "unknown",
                "decide",
                "choice",
                "not sure",
                "no idea",
                "don t know",
                "do not know",
                "what if"
            ]
        case .general:
            []
        }
    }

    var titleNoun: String {
        switch self {
        case .school:
            "school"
        case .friendship:
            "friendship"
        case .rest:
            "rest"
        case .pressure:
            "pressure"
        case .uncertainty:
            "clarity"
        case .general:
            "today"
        }
    }

    var actionStep: String {
        switch self {
        case .school:
            "write the school task that matters most, then do the first two minutes."
        case .friendship:
            "send one kind sentence, or write it first if sending feels too big."
        case .rest:
            "take a real pause with water, a stretch, or two minutes with your eyes closed."
        case .pressure:
            "choose one thing that can wait, then start only the next tiny step."
        case .uncertainty:
            "write the question you need answered, then name who or what could help."
        case .general:
            "choose one small action you can finish before the next thing starts."
        }
    }

    var nowStep: String {
        switch self {
        case .school:
            "Open the task and do the first visible two minutes."
        case .friendship:
            "Write one kind sentence before deciding whether to send it."
        case .rest:
            "Take water, a stretch, or two slow breaths before the next task."
        case .pressure:
            "Choose the next tiny step and make it physically visible."
        case .uncertainty:
            "Write the one question that would make the situation clearer."
        case .general:
            "Pick one action small enough to finish before the next transition."
        }
    }

    var laterStep: String {
        switch self {
        case .school:
            "Grades, the whole project, and tomorrow's tasks can wait outside this minute."
        case .friendship:
            "The full conversation can wait until the sentence feels honest and calm."
        case .rest:
            "Big planning can wait until your energy has one small refill."
        case .pressure:
            "Everything after the first step belongs in later, not in now."
        case .uncertainty:
            "The final decision can wait until the first question is answered."
        case .general:
            "The rest of the day can wait while this one small action gets named."
        }
    }

    var releaseStep: String {
        switch self {
        case .school:
            "You do not need to solve the entire semester in one check-in."
        case .friendship:
            "You do not need to read every silence as an answer."
        case .rest:
            "You do not need to earn rest by finishing everything first."
        case .pressure:
            "You do not need to carry every urgent thing at the same volume."
        case .uncertainty:
            "You do not need perfect certainty before asking for help."
        case .general:
            "You do not need a perfect label before taking one kind step."
        }
    }

    var literacyInsight: String {
        switch self {
        case .school:
            "School feelings often become easier to handle when the next task is named clearly."
        case .friendship:
            "Friendship stress can feel less tangled when one kind sentence is separated from the whole situation."
        case .rest:
            "Tired feelings can be useful signals that the next step should be smaller, slower, or kinder."
        case .pressure:
            "Pressure often feels bigger when every task looks urgent. Separating now from later can make the next step easier to start."
        case .uncertainty:
            "Uncertainty often softens when one clear question gets named before trying to solve everything."
        case .general:
            "A feeling does not need a perfect label before it can become one small next step."
        }
    }

    var liveStormWords: [String] {
        switch self {
        case .school:
            ["project", "homework", "grades", "deadline"]
        case .friendship:
            ["message", "friend", "silence", "belonging"]
        case .rest:
            ["tired", "rest", "energy", "pause"]
        case .pressure:
            ["deadline", "too much", "urgent", "finish"]
        case .uncertainty:
            ["what if", "maybe", "choice", "question"]
        case .general:
            ["weather", "thought", "feeling", "seed"]
        }
    }

    var literacyUnlockTitle: String {
        switch self {
        case .school:
            "A task is smaller than a whole future"
        case .friendship:
            "Silence is not always an answer"
        case .rest:
            "Rest is information"
        case .pressure:
            "Urgent is not the same as important"
        case .uncertainty:
            "A question is already a step"
        case .general:
            "Growth does not need one mood"
        }
    }

    var literacyUnlockDetail: String {
        switch self {
        case .school:
            "School pressure gets easier to move when one task is separated from the whole semester."
        case .friendship:
            "Relationship stress can soften when one honest sentence is separated from every imagined response."
        case .rest:
            "Low energy is not failure; it is a signal that the next step should become smaller."
        case .pressure:
            "Pressure often gets louder when everything sounds urgent. Naming one now step gives the storm a boundary."
        case .uncertainty:
            "Uncertainty becomes less foggy when it turns into one question that can be answered."
        case .general:
            "A mixed week can still have a shape when each feeling becomes one small seed."
        }
    }
}

private extension Mood {
    var observatorySkyLine: String {
        switch self {
        case .calm:
            "The sky is steady enough to show the edges of each cloud."
        case .happy:
            "Warm light keeps breaking through the week instead of disappearing behind tasks."
        case .tired:
            "The sky is low and moonlit, asking the garden to grow more slowly."
        case .stressed:
            "Electrical clouds are visible now, which makes the storm less invisible."
        case .unsure:
            "Fog is still present, but the lens can find questions inside it."
        case .overwhelmed:
            "The sky is crowded with signals, and the lens is lowering the volume one layer at a time."
        case .focused:
            "The sky narrows into a clear beam, protecting attention from extra weather."
        case .lonely:
            "The sky feels distant, but small signals are still visible at the edge."
        }
    }

    var weekShapeTerrain: String {
        switch self {
        case .calm:
            "The terrain settled into a steady field."
        case .happy:
            "The terrain rose into warm bright hills."
        case .tired:
            "The terrain dipped into a quieter night valley."
        case .stressed:
            "The terrain climbed into a pressure ridge."
        case .unsure:
            "The terrain crossed a fog bridge."
        case .overwhelmed:
            "The terrain crowded into a steep storm wall."
        case .focused:
            "The terrain narrowed into a clear path."
        case .lonely:
            "The terrain stretched into a quiet signal field."
        }
    }

    var localActionTone: String {
        switch self {
        case .calm:
            "Keep it steady:"
        case .happy:
            "Use one bit of good energy:"
        case .tired:
            "Make it gentle:"
        case .stressed:
            "Make it tiny:"
        case .unsure:
            "Make it clearer:"
        case .overwhelmed:
            "Turn the volume down:"
        case .focused:
            "Protect the signal:"
        case .lonely:
            "Make one signal:"
        }
    }

    var weeklyInsightSentence: String {
        switch self {
        case .calm:
            "Calm showed up as a stabilizing pattern, which can make the next step easier to notice."
        case .happy:
            "Happy moments became part of the record, so the week is not only remembered by pressure."
        case .tired:
            "Tired feelings appeared as useful signals to make the next step smaller and kinder."
        case .stressed:
            "Stress appeared often, but naming it kept it from becoming one invisible cloud."
        case .unsure:
            "Uncertainty appeared often, and the garden turned it into something answerable."
        case .overwhelmed:
            "Overwhelm appeared as too many signals at once, and the garden kept separating one piece from the whole sky."
        case .focused:
            "Focused moments appeared as useful attention, so the week is not only remembered by pressure."
        case .lonely:
            "Lonely feelings appeared as signals for care, not proof that the user had to stay isolated."
        }
    }

    var nextWeekMoodReminder: String {
        switch self {
        case .calm:
            "Protect one steady thing before adding more."
        case .happy:
            "Let good energy count before rushing to the next demand."
        case .tired:
            "Make the first step smaller before the week asks for too much."
        case .stressed:
            "Separate the loudest task from the whole sky."
        case .unsure:
            "Name one question before trying to solve the whole week."
        case .overwhelmed:
            "Choose one piece before listening to the whole storm."
        case .focused:
            "Protect one clear block of attention before adding more."
        case .lonely:
            "Let one small signal reach a safe person or page."
        }
    }

    var literacyUnlockTitle: String {
        switch self {
        case .calm:
            "Stability is also progress"
        case .happy:
            "Good energy is worth noticing"
        case .tired:
            "Rest is information"
        case .stressed:
            "Urgent is not the same as important"
        case .unsure:
            "A question is already a step"
        case .overwhelmed:
            "Too much can be separated"
        case .focused:
            "Attention deserves protection"
        case .lonely:
            "A signal is not weakness"
        }
    }

    var literacyUnlockDetail: String {
        switch self {
        case .calm:
            "A steady week still deserves attention because calm is something you can protect."
        case .happy:
            "Bright moments are not distractions from growth; they are part of the record too."
        case .tired:
            "Low energy can point toward a kinder next step instead of a bigger demand."
        case .stressed:
            "Stress is easier to hold when one loud thing becomes separate from the whole storm."
        case .unsure:
            "Uncertainty can move when it becomes one question instead of one fog."
        case .overwhelmed:
            "Overwhelm softens when one piece is separated from the whole storm before everything asks for attention."
        case .focused:
            "Focus is not just productivity; it is a signal that one direction has become clear enough to protect."
        case .lonely:
            "Loneliness can become less closed when it turns into one safe signal for connection or care."
        }
    }
}

private extension GrowthLane {
    var observatoryLensLine: String {
        switch self {
        case .now:
            "The lens shows pressure becoming roots under one visible next step."
        case .later:
            "The lens shows pressure held in glass, visible but not urgent."
        case .release:
            "The lens shows pressure leaving as wind around the center bloom."
        }
    }

    var weekShapeForce: String {
        switch self {
        case .now:
            "Roots pulled the landscape into one next step."
        case .later:
            "Waiting buds made the landscape patient."
        case .release:
            "Open air widened the landscape."
        }
    }

    var weeklyInsightSentence: String {
        switch self {
        case .now:
            "Your most repeated move was choosing one visible step, so the week kept turning pressure into action."
        case .later:
            "Your most repeated move was giving bigger worries a place to wait, so everything did not have to happen at once."
        case .release:
            "Your most repeated move was letting one pressure leave the minute, so the garden gained more open air."
        }
    }

    var nextWeekLanePhrase: String {
        switch self {
        case .now:
            "choose one visible step"
        case .later:
            "give the bigger worry a place to wait"
        case .release:
            "let one thing leave this minute"
        }
    }
}

private extension ReflectionTheme {
    var nextWeekThemePhrase: String {
        switch self {
        case .school:
            "the school task that is getting loud"
        case .friendship:
            "the relationship worry before it becomes the whole day"
        case .rest:
            "your energy level before it turns into exhaustion"
        case .pressure:
            "the moment everything starts sounding urgent"
        case .uncertainty:
            "the question hiding inside the fog"
        case .general:
            "the feeling before it needs a perfect name"
        }
    }
}
