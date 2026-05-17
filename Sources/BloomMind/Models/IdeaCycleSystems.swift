import Foundation

struct IdeaCycleSpark: Equatable, Identifiable {
    let id: String
    let title: String
    let detail: String
    let dimension: String
    let symbolName: String
}

struct IdeaCycleStage: Equatable, Identifiable {
    let id: String
    let title: String
    let focus: String
    let implementedResult: String
    let sparks: [IdeaCycleSpark]

    var accessibilityValue: String {
        "\(title). \(focus). \(implementedResult). \(sparks.count) ideas."
    }
}

enum BloomMindIdeaCycles {
    static func completedCycles() -> [IdeaCycleStage] {
        [
            livingMicroDetails
        ]
    }

    static var totalIdeaCount: Int {
        completedCycles().reduce(0) { $0 + $1.sparks.count }
    }

    static var livingMicroDetails: IdeaCycleStage {
        IdeaCycleStage(
            id: "living-micro-details",
            title: "Round 1: Living Micro-Details",
            focus: "Make the world feel alive in the small places between major screens.",
            implementedResult: "Home now includes an Idea Cycle Studio that turns this round's ten sparks into an explorable creative layer.",
            sparks: [
                IdeaCycleSpark(
                    id: "thought-fireflies",
                    title: "Thought fireflies",
                    detail: "Tiny moving sparks gather around the newest seed when the week has momentum.",
                    dimension: "Visual",
                    symbolName: "sparkle"
                ),
                IdeaCycleSpark(
                    id: "lens-fingerprints",
                    title: "Lens fingerprints",
                    detail: "The observatory lens can keep faint traces of choices the student made this week.",
                    dimension: "Memory",
                    symbolName: "scope"
                ),
                IdeaCycleSpark(
                    id: "garden-breath-meter",
                    title: "Garden breath meter",
                    detail: "The garden can show whether the week feels cramped or spacious.",
                    dimension: "Feeling",
                    symbolName: "wind"
                ),
                IdeaCycleSpark(
                    id: "seed-shimmer",
                    title: "Seed shimmer",
                    detail: "A carry seed can pulse when the next check-in is waiting.",
                    dimension: "Return",
                    symbolName: "circle.dotted"
                ),
                IdeaCycleSpark(
                    id: "hidden-whispers",
                    title: "Hidden whispers",
                    detail: "Long-press moments can reveal tiny non-private lines about how the world changed.",
                    dimension: "Explore",
                    symbolName: "hand.tap"
                ),
                IdeaCycleSpark(
                    id: "color-echoes",
                    title: "Color echoes",
                    detail: "Mood colors can softly echo across buttons, borders, and memory stamps.",
                    dimension: "Polish",
                    symbolName: "paintpalette"
                ),
                IdeaCycleSpark(
                    id: "weather-crumbs",
                    title: "Weather crumbs",
                    detail: "Small sky marks can guide the student back into the strongest part of the story.",
                    dimension: "Guidance",
                    symbolName: "cloud.sun"
                ),
                IdeaCycleSpark(
                    id: "quiet-empty-states",
                    title: "Quiet empty states",
                    detail: "Empty garden spaces can feel intentionally quiet instead of unfinished.",
                    dimension: "Content",
                    symbolName: "square.dotted"
                ),
                IdeaCycleSpark(
                    id: "hover-halo",
                    title: "Hover halo",
                    detail: "Plants can answer a hover or tap with a small air ripple.",
                    dimension: "Motion",
                    symbolName: "circle"
                ),
                IdeaCycleSpark(
                    id: "carry-line-glow",
                    title: "Carry-line glow",
                    detail: "The chosen weekly line can glow as a promise rather than sitting like normal text.",
                    dimension: "Ritual",
                    symbolName: "quote.bubble"
                )
            ]
        )
    }
}
