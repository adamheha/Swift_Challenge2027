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
            .yellow
        case .tired:
            .blue
        case .stressed:
            .orange
        case .unsure:
            .purple
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
        }
    }
}
