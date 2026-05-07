import SwiftUI

enum Mood: String, CaseIterable, Identifiable {
    case calm = "Calm"
    case happy = "Happy"
    case tired = "Tired"
    case stressed = "Stressed"
    case unsure = "Unsure"

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
        }
    }

    var selectedForegroundColor: Color {
        self == .happy ? .black : .white
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
        }
    }
}
