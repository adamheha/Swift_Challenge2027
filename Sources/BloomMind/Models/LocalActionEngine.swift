import Foundation

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
    let explanation: String
}

enum LocalActionEngine {
    static func detectTheme(in reflectionText: String) -> ReflectionTheme {
        let normalizedText = normalized(reflectionText)

        guard !normalizedText.isEmpty else {
            return .general
        }

        let words = Set(normalizedText.split(separator: " ").map(String.init))
        var bestTheme = ReflectionTheme.general
        var bestScore = 0

        for theme in detectableThemes {
            let score = theme.keywords.reduce(0) { partialScore, keyword in
                partialScore + (contains(keyword: keyword, in: normalizedText, words: words) ? 1 : 0)
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
            explanation: explanation(for: mood, theme: theme)
        )
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

    private static func contains(keyword: String, in normalizedText: String, words: Set<String>) -> Bool {
        if keyword.contains(" ") {
            return normalizedText.contains(keyword)
        }

        return words.contains(keyword)
    }

    private static func explanation(for mood: Mood, theme: ReflectionTheme) -> String {
        if theme == .general {
            return "No specific theme was detected, so this uses your \(mood.rawValue.lowercased()) mood to keep the next step simple. The reflection stays on this device."
        }

        return "This looks like a \(theme.displayName.lowercased()) theme, detected locally, and uses your \(mood.rawValue.lowercased()) mood to keep the next step small. The reflection stays on this device."
    }
}

private extension ReflectionTheme {
    var keywords: [String] {
        switch self {
        case .school:
            [
                "school",
                "class",
                "homework",
                "assignment",
                "project",
                "teacher",
                "grade",
                "grades",
                "test",
                "quiz",
                "exam",
                "study"
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
}

private extension Mood {
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
        }
    }
}
