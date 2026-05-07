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
    let explanation: String
    let literacyInsight: String
}

enum LocalActionEngine {
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
            explanation: explanation(for: mood, theme: theme),
            literacyInsight: theme.literacyInsight
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
