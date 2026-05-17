import Foundation

enum ExperienceTriggerMoment: String, CaseIterable {
    case arrival
    case needsCheckIn
    case calibration
    case sorting
    case postPlanting
    case partialGarden
    case almostBloom
    case weeklyBloom
    case demoDirector
    case quietArchive

    var title: String {
        switch self {
        case .arrival:
            "First arrival"
        case .needsCheckIn:
            "Today needs a seed"
        case .calibration:
            "Feeling before label"
        case .sorting:
            "Storm surgery"
        case .postPlanting:
            "After planting"
        case .partialGarden:
            "Growing week"
        case .almostBloom:
            "Almost bloom"
        case .weeklyBloom:
            "Weekly bloom"
        case .demoDirector:
            "Judge path"
        case .quietArchive:
            "Private archive"
        }
    }

    var symbolName: String {
        switch self {
        case .arrival:
            "scope"
        case .needsCheckIn:
            "camera.macro"
        case .calibration:
            "circle.dashed"
        case .sorting:
            "hand.draw"
        case .postPlanting:
            "leaf"
        case .partialGarden:
            "map"
        case .almostBloom:
            "sparkles"
        case .weeklyBloom:
            "sun.max"
        case .demoDirector:
            "play.rectangle"
        case .quietArchive:
            "archivebox"
        }
    }
}

struct ExperienceTriggerRule: Equatable, Identifiable {
    let id: String
    let roundNumber: Int
    let moment: ExperienceTriggerMoment
    let title: String
    let detail: String
    let surface: String
    let priority: Int
}

struct ExperienceFocusCard: Equatable, Identifiable {
    let id: String
    let title: String
    let detail: String
    let surface: String
    let symbolName: String
}

struct ExperienceSurfacePlan: Equatable {
    let moment: ExperienceTriggerMoment
    let focusCards: [ExperienceFocusCard]
    let showObservatoryTools: Bool
    let showIdeaStudio: Bool
    let showGardenDepth: Bool
    let showWeeklyPayoff: Bool
}

enum BloomMindExperienceOrchestrator {
    static func allTriggerRules() -> [ExperienceTriggerRule] {
        ExperienceTriggerMoment.allCases.enumerated().flatMap { offset, moment in
            triggerRules(for: moment, roundNumber: offset + 1)
        }
    }

    static func moment(
        for state: CheckInState,
        isPreviewingDemoWeek: Bool
    ) -> ExperienceTriggerMoment {
        if isPreviewingDemoWeek {
            return .demoDirector
        }

        if state.isWeeklyBloomUnlocked {
            return .weeklyBloom
        }

        let completedCount = state.completedCheckInsThisWeek
        if completedCount >= max(CheckInState.weeklyCheckInGoal - 1, 1) {
            return .almostBloom
        }

        if state.hasCompletedCheckInToday() {
            return .postPlanting
        }

        if completedCount == 0 {
            return .arrival
        }

        return .needsCheckIn
    }

    static func surfacePlan(
        for state: CheckInState,
        isPreviewingDemoWeek: Bool
    ) -> ExperienceSurfacePlan {
        let activeMoment = moment(for: state, isPreviewingDemoWeek: isPreviewingDemoWeek)
        let completedCount = state.completedCheckInsThisWeek
        let cards = focusCards(for: activeMoment, limit: 3)

        return ExperienceSurfacePlan(
            moment: activeMoment,
            focusCards: cards,
            showObservatoryTools: isPreviewingDemoWeek || completedCount > 0 || activeMoment == .arrival,
            showIdeaStudio: isPreviewingDemoWeek || state.isWeeklyBloomUnlocked || completedCount >= 3,
            showGardenDepth: completedCount > 0 || isPreviewingDemoWeek,
            showWeeklyPayoff: state.isWeeklyBloomUnlocked
        )
    }

    static func focusCards(
        for moment: ExperienceTriggerMoment,
        limit: Int
    ) -> [ExperienceFocusCard] {
        allTriggerRules()
            .filter { $0.moment == moment }
            .sorted { left, right in
                if left.priority == right.priority {
                    return left.id < right.id
                }
                return left.priority < right.priority
            }
            .prefix(limit)
            .map { rule in
                ExperienceFocusCard(
                    id: rule.id,
                    title: rule.title,
                    detail: rule.detail,
                    surface: rule.surface,
                    symbolName: rule.moment.symbolName
                )
            }
    }

    private static func triggerRules(
        for moment: ExperienceTriggerMoment,
        roundNumber: Int
    ) -> [ExperienceTriggerRule] {
        let titles = ideaTitles(for: moment)
        let surface = surfaceName(for: moment)

        return titles.enumerated().map { index, title in
            ExperienceTriggerRule(
                id: "\(moment.rawValue)-\(index + 1)",
                roundNumber: roundNumber,
                moment: moment,
                title: title,
                detail: detail(for: moment, title: title),
                surface: surface,
                priority: index + 1
            )
        }
    }

    private static func surfaceName(for moment: ExperienceTriggerMoment) -> String {
        switch moment {
        case .arrival:
            "Opening lens"
        case .needsCheckIn:
            "Check-in invitation"
        case .calibration:
            "Calibration ring"
        case .sorting:
            "Storm surgery table"
        case .postPlanting:
            "Garden response"
        case .partialGarden:
            "Garden depth"
        case .almostBloom:
            "Center bloom"
        case .weeklyBloom:
            "Weekly ceremony"
        case .demoDirector:
            "Award path"
        case .quietArchive:
            "Private museum"
        }
    }

    private static func detail(
        for moment: ExperienceTriggerMoment,
        title: String
    ) -> String {
        switch moment {
        case .arrival:
            "\(title) appears only before the first seed so the opening feels focused."
        case .needsCheckIn:
            "\(title) appears when today has not been named yet."
        case .calibration:
            "\(title) belongs before mood labels, when the feeling is still shape and weight."
        case .sorting:
            "\(title) appears while pressure is being separated into Now, Later, and Let go."
        case .postPlanting:
            "\(title) appears after planting, when the user needs consequence instead of more input."
        case .partialGarden:
            "\(title) appears when the week has enough seeds to invite exploration."
        case .almostBloom:
            "\(title) appears when the center bloom is close and anticipation matters."
        case .weeklyBloom:
            "\(title) appears only after seven seeds, so the ending feels earned."
        case .demoDirector:
            "\(title) appears in the judge path so the strongest story is easy to find."
        case .quietArchive:
            "\(title) appears in archive contexts, preserving memory without private text."
        }
    }

    private static func ideaTitles(for moment: ExperienceTriggerMoment) -> [String] {
        switch moment {
        case .arrival:
            return [
                "Doorway weather",
                "One-minute promise",
                "Quiet first lens",
                "Paper-to-cloud hint",
                "Waiting seed glint",
                "No dashboard first",
                "Origin breath",
                "Soft start caption",
                "Inner-sky threshold",
                "First spark restraint"
            ]
        case .needsCheckIn:
            return [
                "Horizon cloud",
                "Today seed nudge",
                "Gentle return line",
                "Unwritten weather",
                "Mood-before-words hint",
                "Tiny quest invitation",
                "No-shame reminder",
                "Next minute beacon",
                "Check-in door glow",
                "Private start prompt"
            ]
        case .calibration:
            return [
                "Loudness orbit",
                "Heaviness shadow",
                "Shape-before-name",
                "Pre-mood pulse",
                "Quiet-heavy clue",
                "Light-loud shimmer",
                "Weather weight mark",
                "Ring-to-seed shell",
                "Tactile label bridge",
                "Feeling compass"
            ]
        case .sorting:
            return [
                "Task layer hinge",
                "Social layer thread",
                "Body layer dimmer",
                "Future layer door",
                "Now root impact",
                "Later glass hold",
                "Let-go wind shear",
                "Fragment gravity",
                "Seed core reveal",
                "Choice trail spark"
            ]
        case .postPlanting:
            return [
                "Because-of-me echo",
                "Soil pulse",
                "Root proof",
                "Bud waiting light",
                "Open-sky exhale",
                "Seed landing ring",
                "Aftercare line",
                "World changed mark",
                "Tiny victory hush",
                "Tomorrow glimmer"
            ]
        case .partialGarden:
            return [
                "Map zone invitation",
                "X-Ray hint",
                "Week shape glider",
                "Atlas corner",
                "Rare bloom clue",
                "Memory stamp tray",
                "Garden breath meter",
                "Lane ecology line",
                "Seed evolution lens",
                "Explore-without-text"
            ]
        case .almostBloom:
            return [
                "Sixth seed glow",
                "Center bloom tremor",
                "Almost-there weather",
                "Final seed invitation",
                "Week arc preview",
                "Constellation outline",
                "Artifact silhouette",
                "Ceremony threshold",
                "Bloom countdown whisper",
                "Seventh-door shimmer"
            ]
        case .weeklyBloom:
            return [
                "Constellation name",
                "Week film spotlight",
                "Vocabulary unlock",
                "Carry seed choice",
                "Artifact crafting",
                "Private museum shelf",
                "Final story mode",
                "Season title",
                "Before-after sky",
                "Ending-becomes-beginning"
            ]
        case .demoDirector:
            return [
                "Judge-first door",
                "Spotlight caption",
                "Demo reflection card",
                "Ninety-second trail",
                "Origin beat lock",
                "Interaction proof cue",
                "Privacy proof cue",
                "Payoff proof cue",
                "Craft proof cue",
                "Submission rehearsal path"
            ]
        case .quietArchive:
            return [
                "Pressed week shelf",
                "Artifact footnote",
                "Season drawer",
                "Rare bloom specimen",
                "Memory-without-text seal",
                "Carry-line archive",
                "Private postcard",
                "Past sky chip",
                "Root history trace",
                "Archive hush"
            ]
        }
    }
}
