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
    let systemImage: String
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
                systemImage: "sparkles"
            ),
            GuidedDemoStep(
                id: "observatory",
                title: "Weather observatory",
                detail: "The home sky reads the week as pressure layers, mood, and lane.",
                instruction: "Notice the lens, instruments, soundscape, and next seed.",
                systemImage: "scope"
            ),
            GuidedDemoStep(
                id: "reflection",
                title: "Live storm",
                detail: "A private reflection becomes safe weather fragments as the student types.",
                instruction: "Use the demo reflection, then show how keywords orbit the storm.",
                systemImage: "tornado"
            ),
            GuidedDemoStep(
                id: "wordless",
                title: "Wordless check-in",
                detail: "The student can express pressure by pressing, dragging, or releasing.",
                instruction: "Show that BloomMind still works on days when words are hard.",
                systemImage: "hand.tap"
            ),
            GuidedDemoStep(
                id: "surgery",
                title: "Storm surgery",
                detail: "Task, social, body, and future layers peel away until the seed appears.",
                instruction: "Peel two layers, then drag fragments into Now, Later, and Let go.",
                systemImage: "hand.draw"
            ),
            GuidedDemoStep(
                id: "plant",
                title: "Planting ritual",
                detail: "The seed is dragged into soil and grows from the chosen consequence.",
                instruction: "Let Now make roots, Later make buds, or Let go make air.",
                systemImage: "camera.macro"
            ),
            GuidedDemoStep(
                id: "film",
                title: "Week film",
                detail: "Seven seeds replay as a ten-second storm-to-garden transformation.",
                instruction: "Play the film after the demo week unlocks.",
                systemImage: "film"
            ),
            GuidedDemoStep(
                id: "museum",
                title: "Private museum",
                detail: "The completed week becomes an artifact, a season, and a carry seed.",
                instruction: "End on the artifact plus the origin line.",
                systemImage: "archivebox"
            )
        ]
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
