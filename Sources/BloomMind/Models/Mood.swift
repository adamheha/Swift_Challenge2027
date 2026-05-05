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

    var growthAction: String {
        switch self {
        case .calm:
            "Write down one thing you want to protect today."
        case .happy:
            "Share one kind sentence with someone."
        case .tired:
            "Take three slow breaths and lower one expectation."
        case .stressed:
            "Choose the smallest next step and do only that."
        case .unsure:
            "Write one question you want to understand better."
        }
    }
}
