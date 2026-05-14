import SwiftUI

enum Mood: String, CaseIterable, Identifiable {
    case calm = "Calm"
    case happy = "Happy"
    case tired = "Tired"
    case stressed = "Stressed"
    case unsure = "Unsure"
    case overwhelmed = "Overwhelmed"
    case focused = "Focused"
    case lonely = "Lonely"

    var id: String { rawValue }

    var symbolName: String {
        switch self {
        case .calm:
            "leaf"
        case .happy:
            "sun.max"
        case .tired:
            "moon"
        case .stressed:
            "wind"
        case .unsure:
            "questionmark.circle"
        case .overwhelmed:
            "cloud.bolt"
        case .focused:
            "scope"
        case .lonely:
            "bubble.left"
        }
    }

    var tint: Color {
        switch self {
        case .calm:
            .green
        case .happy:
            Color(red: 0.82, green: 0.50, blue: 0.04)
        case .tired:
            .blue
        case .stressed:
            .orange
        case .unsure:
            .purple
        case .overwhelmed:
            Color(red: 0.74, green: 0.23, blue: 0.32)
        case .focused:
            Color(red: 0.08, green: 0.56, blue: 0.58)
        case .lonely:
            Color(red: 0.36, green: 0.43, blue: 0.72)
        }
    }

    var selectedForegroundColor: Color {
        switch self {
        case .happy, .focused:
            .black
        default:
            .white
        }
    }

    var accessibilityHint: String {
        "Selects \(rawValue.lowercased()) as your current mood."
    }

    var plantAccessibilityName: String {
        switch self {
        case .calm:
            "Calm sprout"
        case .happy:
            "Sun bloom"
        case .tired:
            "Moon bell"
        case .stressed:
            "Wind grass"
        case .unsure:
            "Question bud"
        case .overwhelmed:
            "Storm bloom"
        case .focused:
            "Compass bloom"
        case .lonely:
            "Signal flower"
        }
    }

    var gardenReflectionNote: String {
        switch self {
        case .calm:
            "This plant marks a check-in where steadiness was noticed."
        case .happy:
            "This plant marks a check-in where good energy became something shareable."
        case .tired:
            "This plant marks a check-in where low energy was allowed to move gently."
        case .stressed:
            "This plant marks a check-in where pressure became one smaller next step."
        case .unsure:
            "This plant marks a check-in where uncertainty became one clearer question."
        case .overwhelmed:
            "This plant marks a check-in where too much pressure was separated into one survivable piece."
        case .focused:
            "This plant marks a check-in where attention found one direction."
        case .lonely:
            "This plant marks a check-in where loneliness became one small signal for care."
        }
    }

    var gardenRevisitPrompt: String {
        switch self {
        case .calm:
            "Protect one small steady thing before adding more."
        case .happy:
            "Use a little of that energy for one kind action."
        case .tired:
            "Choose the version of the next step that asks for less."
        case .stressed:
            "Look for one task that can wait before starting the next tiny step."
        case .unsure:
            "Name the question before trying to answer everything."
        case .overwhelmed:
            "Lower the volume by choosing only the next visible piece."
        case .focused:
            "Protect this focus from one avoidable interruption."
        case .lonely:
            "Let one honest sentence reach a safe person or page."
        }
    }
}
