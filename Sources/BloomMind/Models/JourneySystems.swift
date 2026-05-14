import Foundation

struct OriginSceneBeat: Equatable, Identifiable {
    let id: String
    let title: String
    let detail: String
    let symbolName: String
}

struct GuidedDemoStep: Equatable, Identifiable {
    let id: String
    let title: String
    let detail: String
    let instruction: String
    let caption: String
    let systemImage: String
}

struct EmotionalCalibrationSignal: Equatable {
    var loudness: Double
    var heaviness: Double

    static let defaultSignal = EmotionalCalibrationSignal(loudness: 0.48, heaviness: 0.54)

    var normalizedLoudness: Double {
        min(max(loudness, 0.0), 1.0)
    }

    var normalizedHeaviness: Double {
        min(max(heaviness, 0.0), 1.0)
    }

    var title: String {
        switch (normalizedLoudness, normalizedHeaviness) {
        case (0.68..., 0.68...):
            "Loud and heavy"
        case (0.68..., _):
            "Loud but movable"
        case (_, 0.68...):
            "Quiet but heavy"
        case (...0.34, ...0.34):
            "Quiet and light"
        default:
            "Present weather"
        }
    }

    var generatedStormText: String {
        let volume = normalizedLoudness >= 0.64 ? "loud" : normalizedLoudness <= 0.34 ? "quiet" : "present"
        let weight = normalizedHeaviness >= 0.64 ? "heavy" : normalizedHeaviness <= 0.34 ? "light" : "moving"
        return "\(volume) \(weight) school weather"
    }

    var suggestedMood: Mood {
        switch (normalizedLoudness, normalizedHeaviness) {
        case (0.70..., 0.70...):
            .overwhelmed
        case (0.70..., _):
            .stressed
        case (_, 0.70...):
            .tired
        case (...0.34, ...0.34):
            .calm
        default:
            .unsure
        }
    }

    var accessibilityValue: String {
        let loudPercent = Int((normalizedLoudness * 100).rounded())
        let heavyPercent = Int((normalizedHeaviness * 100).rounded())
        return "\(title). Loudness \(loudPercent) percent. Heaviness \(heavyPercent) percent."
    }
}

struct StormLayerPeelingPlan: Equatable {
    let layers: [PressureLayer]
    let peeledLayers: Set<PressureLayer>
    let coreScale: Double
    let seedIsVisible: Bool
    let summary: String
}

struct WordlessStormSignal: Equatable {
    var intensity: Double
    var lane: GrowthLane

    static let defaultSignal = WordlessStormSignal(intensity: 0.55, lane: .now)

    var normalizedIntensity: Double {
        min(max(intensity, 0.1), 1.0)
    }

    var title: String {
        switch lane {
        case .now:
            "Press into now"
        case .later:
            "Hold for later"
        case .release:
            "Release upward"
        }
    }

    var detail: String {
        switch lane {
        case .now:
            "This wordless signal turns pressure into one grounded next step."
        case .later:
            "This wordless signal gives the storm a safe place to wait."
        case .release:
            "This wordless signal lets one part of the storm become air."
        }
    }

    var generatedStormText: String {
        let strength = normalizedIntensity >= 0.72 ? "loud" : normalizedIntensity >= 0.42 ? "present" : "quiet"
        return "wordless \(strength) \(lane.title.lowercased()) storm"
    }

    var suggestedMood: Mood {
        switch (lane, normalizedIntensity) {
        case (.now, 0.72...):
            .focused
        case (.now, _):
            .calm
        case (.later, 0.72...):
            .tired
        case (.later, _):
            .unsure
        case (.release, 0.72...):
            .overwhelmed
        case (.release, _):
            .calm
        }
    }

    var accessibilityValue: String {
        let percent = Int((normalizedIntensity * 100).rounded())
        return "\(title). \(percent) percent intensity. \(detail)"
    }
}

struct CarrySeedChoice: Equatable, Identifiable {
    let id: String
    let title: String
    let line: String
    let symbolName: String
}

struct ArchiveMuseumDisplay: Equatable {
    let artifact: WeeklyBloomArtifact
    let season: EmotionalSeason
    let rareBlooms: [RareBloom]
    let craftedLine: String
    let carryLine: String

    var accessibilityValue: String {
        let bloomNames = rareBlooms.map(\.title).joined(separator: ", ")
        return "\(artifact.title). \(season.title). Rare blooms: \(bloomNames). \(carryLine)"
    }
}

struct PressureConstellationName: Equatable {
    let title: String
    let detail: String
    let symbolName: String
}

struct TimeOfDayGardenTone: Equatable {
    let title: String
    let detail: String
    let symbolName: String
}

struct WhatChangedBecauseOfMe: Equatable {
    let title: String
    let detail: String
    let symbolName: String
}

struct MemoryStamp: Equatable {
    let title: String
    let detail: String
    let tokens: [String]
}

struct EmotionalVocabularyUnlock: Equatable, Identifiable {
    let id: String
    let title: String
    let line: String
    let symbolName: String
}

enum BloomMindJourney {
    static let originLine = "Pressure stopped feeling like tasks. It started feeling like weather."
    static let personalMeaningLine = "I made BloomMind because sometimes school pressure did not feel like a list. It felt like weather."
    static let demoReflection = "Exam, club project, group chat, and a deadline are all spinning at once."

    static func originBeats() -> [OriginSceneBeat] {
        [
            OriginSceneBeat(
                id: "papers",
                title: "Tasks",
                detail: "Papers, clocks, grades, and messages begin as separate pieces.",
                symbolName: "doc.text"
            ),
            OriginSceneBeat(
                id: "weather",
                title: "Weather",
                detail: "When too many pieces arrive together, they stop feeling like a list.",
                symbolName: "cloud.bolt"
            ),
            OriginSceneBeat(
                id: "seed",
                title: "Seed",
                detail: "BloomMind turns one storm into one seed the student can carry.",
                symbolName: "camera.macro"
            ),
            OriginSceneBeat(
                id: "garden",
                title: "Garden",
                detail: "The week becomes a private world that remembers growth, not private words.",
                symbolName: "sparkles"
            )
        ]
    }

    static func guidedAwardDemoSteps() -> [GuidedDemoStep] {
        [
            GuidedDemoStep(
                id: "origin",
                title: "Opening origin",
                detail: "The app starts with the moment school pressure becomes weather.",
                instruction: "Start here so the judge understands why the world exists.",
                caption: "This is why BloomMind exists.",
                systemImage: "sparkles"
            ),
            GuidedDemoStep(
                id: "observatory",
                title: "Weather observatory",
                detail: "The home sky reads the week as pressure layers, mood, and lane.",
                instruction: "Notice the lens, instruments, soundscape, and next seed.",
                caption: "This is the student's inner weather.",
                systemImage: "scope"
            ),
            GuidedDemoStep(
                id: "reflection",
                title: "Live storm",
                detail: "A private reflection becomes safe weather fragments as the student types.",
                instruction: "Use the demo reflection, then show how keywords orbit the storm.",
                caption: "This is the storm becoming visible.",
                systemImage: "tornado"
            ),
            GuidedDemoStep(
                id: "wordless",
                title: "Wordless check-in",
                detail: "The student can express pressure by pressing, dragging, or releasing.",
                instruction: "Show that BloomMind still works on days when words are hard.",
                caption: "This is the no-typing path.",
                systemImage: "hand.tap"
            ),
            GuidedDemoStep(
                id: "surgery",
                title: "Storm surgery",
                detail: "Task, social, body, and future layers peel away until the seed appears.",
                instruction: "Peel two layers, then drag fragments into Now, Later, and Let go.",
                caption: "These are the choices changing the world.",
                systemImage: "hand.draw"
            ),
            GuidedDemoStep(
                id: "plant",
                title: "Planting ritual",
                detail: "The seed is dragged into soil and grows from the chosen consequence.",
                instruction: "Let Now make roots, Later make buds, or Let go make air.",
                caption: "This is pressure becoming one seed.",
                systemImage: "camera.macro"
            ),
            GuidedDemoStep(
                id: "film",
                title: "Week film",
                detail: "Seven seeds replay as a ten-second storm-to-garden transformation.",
                instruction: "Play the film after the demo week unlocks.",
                caption: "This is the week becoming memory.",
                systemImage: "film"
            ),
            GuidedDemoStep(
                id: "museum",
                title: "Private museum",
                detail: "The completed week becomes an artifact, a season, and a carry seed.",
                instruction: "End on the artifact plus the origin line.",
                caption: "This is the ending becoming a beginning.",
                systemImage: "archivebox"
            )
        ]
    }

    static func pressureConstellationName(for seeds: [GardenSeed]) -> PressureConstellationName {
        let dominantMood = dominantValue(in: seeds.map(\.mood))
        let dominantLane = dominantValue(in: seeds.map(\.lane))
        let dominantTheme = dominantValue(in: seeds.map(\.theme))

        switch (dominantMood, dominantLane, dominantTheme) {
        case (.overwhelmed?, .release?, _), (.stressed?, .release?, _):
            return PressureConstellationName(
                title: "The Weather That Learned to Open",
                detail: "This constellation appears when a loud week makes more air.",
                symbolName: "wind"
            )
        case (.tired?, _, .rest?):
            return PressureConstellationName(
                title: "The Quiet Root Week",
                detail: "This constellation appears when low energy still protects growth.",
                symbolName: "moon.stars"
            )
        case (.focused?, .now?, _), (.calm?, .now?, _):
            return PressureConstellationName(
                title: "The Week of Small Starts",
                detail: "This constellation appears when steadiness keeps choosing one next step.",
                symbolName: "scope"
            )
        case (.unsure?, _, .uncertainty?):
            return PressureConstellationName(
                title: "The Storm With a Door",
                detail: "This constellation appears when questions become a way through.",
                symbolName: "rectangle.portrait.and.arrow.right"
            )
        default:
            return PressureConstellationName(
                title: "The Seven-Seed Weather",
                detail: "This constellation appears when a mixed week becomes one private sky.",
                symbolName: "sparkles"
            )
        }
    }

    static func timeOfDayGardenTone(
        date: Date = Date(),
        calendar: Calendar = .current,
        hasCompletedToday: Bool,
        completedCount: Int,
        totalCount: Int
    ) -> TimeOfDayGardenTone {
        let hour = calendar.component(.hour, from: date)
        let progressIsNearBloom = completedCount >= max(totalCount - 1, 1)

        if hasCompletedToday {
            return TimeOfDayGardenTone(
                title: "Open air after planting",
                detail: "Today's seed is in the soil, so the garden breathes wider.",
                symbolName: "wind"
            )
        }

        if progressIsNearBloom {
            return TimeOfDayGardenTone(
                title: "Almost-bloom weather",
                detail: "The center bloom is close enough to glow before the next check-in.",
                symbolName: "sparkles"
            )
        }

        switch hour {
        case 5..<12:
            return TimeOfDayGardenTone(
                title: "Morning clarity",
                detail: "The garden opens with clearer light and a quieter storm edge.",
                symbolName: "sunrise"
            )
        case 18..<24, 0..<5:
            return TimeOfDayGardenTone(
                title: "Evening observatory",
                detail: "The garden lowers its light so the week can be seen gently.",
                symbolName: "moon"
            )
        default:
            return TimeOfDayGardenTone(
                title: "Midday weather",
                detail: "The garden is awake, and an unfinished storm waits at the horizon.",
                symbolName: "sun.max"
            )
        }
    }

    static func whatChangedBecauseOfMe(for seed: GardenSeed) -> WhatChangedBecauseOfMe {
        switch seed.lane {
        case .now:
            return WhatChangedBecauseOfMe(
                title: "Because you chose Now",
                detail: "This plant grew roots. One next step became strong enough to hold.",
                symbolName: "arrow.down.to.line"
            )
        case .later:
            return WhatChangedBecauseOfMe(
                title: "Because you chose Later",
                detail: "A bud started waiting instead of shouting. The worry stayed visible without taking the whole minute.",
                symbolName: "tray"
            )
        case .release:
            return WhatChangedBecauseOfMe(
                title: "Because you chose Let go",
                detail: "The sky opened. One piece of pressure became air instead of another task.",
                symbolName: "wind"
            )
        }
    }

    static func memoryStamp(
        for seed: GardenSeed,
        dayIndex: Int,
        totalCount: Int,
        calibration: EmotionalCalibrationSignal? = nil
    ) -> MemoryStamp {
        let dayToken = "D\(min(max(dayIndex + 1, 1), max(totalCount, 1)))"
        let laneToken = seed.lane.title
        let themeToken = seed.theme.displayName
        let calibrationToken = calibration?.title ?? "shape kept"

        return MemoryStamp(
            title: "Memory without text",
            detail: "This stamp remembers color, pressure layer, lane, day position, and weather shape without storing the reflection.",
            tokens: [dayToken, seed.mood.rawValue, themeToken, laneToken, calibrationToken]
        )
    }

    static func vocabularyUnlocks(for seeds: [GardenSeed]) -> [EmotionalVocabularyUnlock] {
        let themes = Set(seeds.map(\.theme))
        let moods = Set(seeds.map(\.mood))
        let lanes = Set(seeds.map(\.lane))
        var unlocks: [EmotionalVocabularyUnlock] = []

        if themes.contains(.pressure) || moods.contains(.stressed) || moods.contains(.overwhelmed) {
            unlocks.append(EmotionalVocabularyUnlock(
                id: "urgent",
                title: "Urgent is not everything",
                line: "A task can be urgent without becoming the whole sky.",
                symbolName: "timer"
            ))
        }

        if themes.contains(.rest) || moods.contains(.tired) {
            unlocks.append(EmotionalVocabularyUnlock(
                id: "rest",
                title: "Rest is information",
                line: "Rest is not the opposite of progress. It tells the garden what needs care.",
                symbolName: "moon"
            ))
        }

        if themes.contains(.uncertainty) || moods.contains(.unsure) {
            unlocks.append(EmotionalVocabularyUnlock(
                id: "question",
                title: "A question can move",
                line: "A question is already a kind of movement when it becomes visible.",
                symbolName: "questionmark.circle"
            ))
        }

        if lanes.contains(.release) {
            unlocks.append(EmotionalVocabularyUnlock(
                id: "space",
                title: "Letting go makes space",
                line: "Letting go is not losing. Sometimes it is making room for the next seed.",
                symbolName: "wind"
            ))
        }

        if unlocks.isEmpty {
            unlocks.append(EmotionalVocabularyUnlock(
                id: "stability",
                title: "Stability is progress",
                line: "Growth does not need one dramatic mood. Steady still counts.",
                symbolName: "leaf"
            ))
        }

        return Array(unlocks.prefix(4))
    }

    static func peelingLayers(
        for theme: ReflectionTheme,
        keywords: [String]
    ) -> [PressureLayer] {
        let keywordLayers = keywords.compactMap(keywordLayer)
        let preferredLayers = [theme.pressureLayerForJourney] + keywordLayers + [.task, .social, .body, .future]
        var seen = Set<PressureLayer>()

        return preferredLayers.compactMap { layer in
            guard layer != .weather, !seen.contains(layer) else {
                return nil
            }

            seen.insert(layer)
            return layer
        }
    }

    static func peelingPlan(
        for theme: ReflectionTheme,
        keywords: [String],
        peeledLayers: Set<PressureLayer>
    ) -> StormLayerPeelingPlan {
        let layers = peelingLayers(for: theme, keywords: keywords)
        let visiblePeeledLayers = peeledLayers.intersection(Set(layers))
        let denominator = max(layers.count, 1)
        let peeledRatio = Double(visiblePeeledLayers.count) / Double(denominator)
        let coreScale = max(0.42, 1.0 - peeledRatio * 0.48)
        let seedIsVisible = visiblePeeledLayers.count >= denominator
        let summary = seedIsVisible
            ? "All visible layers are peeled. The seed is exposed at the storm core."
            : "\(visiblePeeledLayers.count) of \(denominator) pressure layers peeled. The storm core is getting smaller."

        return StormLayerPeelingPlan(
            layers: layers,
            peeledLayers: visiblePeeledLayers,
            coreScale: coreScale,
            seedIsVisible: seedIsVisible,
            summary: summary
        )
    }

    static func carrySeedChoices(for payoff: WeeklyBloomPayoff) -> [CarrySeedChoice] {
        [
            CarrySeedChoice(
                id: "closing",
                title: "Carry the line",
                line: payoff.closingLine,
                symbolName: "quote.bubble"
            ),
            CarrySeedChoice(
                id: "intention",
                title: "Carry the intention",
                line: payoff.nextWeekIntention,
                symbolName: "arrow.forward.circle"
            ),
            CarrySeedChoice(
                id: "artifact",
                title: "Carry the artifact",
                line: payoff.artifact.line,
                symbolName: payoff.artifact.symbolName
            )
        ]
    }

    static func archiveMuseum(
        for seeds: [GardenSeed],
        payoff: WeeklyBloomPayoff,
        craftedLine: String,
        selectedCarryLine: String
    ) -> ArchiveMuseumDisplay {
        ArchiveMuseumDisplay(
            artifact: payoff.artifact,
            season: SensoryObservatory.season(for: seeds),
            rareBlooms: Array(SensoryObservatory.rareBloomAtlas(for: seeds).prefix(4)),
            craftedLine: craftedLine,
            carryLine: selectedCarryLine
        )
    }

    private static func keywordLayer(_ keyword: String) -> PressureLayer? {
        let normalized = keyword.lowercased()

        if ["exam", "test", "quiz", "project", "deadline", "homework", "grade", "class"].contains(where: normalized.contains) {
            return .task
        }

        if ["friend", "message", "chat", "group", "team", "club", "family"].contains(where: normalized.contains) {
            return .social
        }

        if ["sleep", "tired", "body", "energy", "rest", "sick"].contains(where: normalized.contains) {
            return .body
        }

        if ["future", "college", "unknown", "choice", "what if", "competition"].contains(where: normalized.contains) {
            return .future
        }

        return nil
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
}

private extension ReflectionTheme {
    var pressureLayerForJourney: PressureLayer {
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
}
