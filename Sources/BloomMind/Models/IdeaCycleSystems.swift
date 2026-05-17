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

struct IdeaCycleResonance: Equatable {
    let title: String
    let detail: String
    let symbolName: String
    let dominantDimension: String
}

enum BloomMindIdeaCycles {
    static func completedCycles() -> [IdeaCycleStage] {
        [
            livingMicroDetails,
            returnHooks,
            sensoryMotionLayer
        ]
    }

    static var totalIdeaCount: Int {
        completedCycles().reduce(0) { $0 + $1.sparks.count }
    }

    static func resonance(for cycles: [IdeaCycleStage] = completedCycles()) -> IdeaCycleResonance {
        let dimensions = cycles.flatMap(\.sparks).map(\.dimension)
        let dominant = dominantDimension(in: dimensions) ?? "World"

        return IdeaCycleResonance(
            title: "\(cycles.count) idea cycles are active",
            detail: "\(cycles.reduce(0) { $0 + $1.sparks.count }) sparks are pulling BloomMind toward \(dominant.lowercased()) depth.",
            symbolName: "waveform.path.ecg",
            dominantDimension: dominant
        )
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

    static var returnHooks: IdeaCycleStage {
        IdeaCycleStage(
            id: "return-hooks",
            title: "Round 2: Return Hooks",
            focus: "Give the student gentle reasons to come back without streak pressure or shame.",
            implementedResult: "The Idea Cycle Studio now includes a return-focused round that frames tomorrow as curiosity, not obligation.",
            sparks: [
                IdeaCycleSpark(
                    id: "tomorrow-postcard",
                    title: "Tomorrow postcard",
                    detail: "After a check-in, the garden can send a tiny visual postcard to tomorrow's self.",
                    dimension: "Return",
                    symbolName: "postcard"
                ),
                IdeaCycleSpark(
                    id: "no-shame-streak",
                    title: "No-shame streak",
                    detail: "Progress language can celebrate returns without punishing missed days.",
                    dimension: "Trust",
                    symbolName: "calendar.badge.clock"
                ),
                IdeaCycleSpark(
                    id: "surprise-seed",
                    title: "Surprise seed",
                    detail: "A completed week can leave one hidden seed that opens only after the next check-in.",
                    dimension: "Wonder",
                    symbolName: "gift"
                ),
                IdeaCycleSpark(
                    id: "mini-quest",
                    title: "Mini quest",
                    detail: "The next visit can ask the student to notice one small thing, not complete a task list.",
                    dimension: "Content",
                    symbolName: "flag.checkered"
                ),
                IdeaCycleSpark(
                    id: "unfinished-cloud",
                    title: "Unfinished cloud",
                    detail: "If the day is not checked in, a soft cloud waits at the edge of the garden.",
                    dimension: "Visual",
                    symbolName: "cloud"
                ),
                IdeaCycleSpark(
                    id: "weekly-invitation",
                    title: "Weekly invitation",
                    detail: "The Home lens can invite the student toward the next emotional artifact.",
                    dimension: "Story",
                    symbolName: "arrow.forward.circle"
                ),
                IdeaCycleSpark(
                    id: "garden-postcard",
                    title: "Garden postcard",
                    detail: "A tiny share-free postcard can summarize the week privately inside the app.",
                    dimension: "Memory",
                    symbolName: "photo"
                ),
                IdeaCycleSpark(
                    id: "time-window-whisper",
                    title: "Time-window whisper",
                    detail: "Morning, afternoon, and evening can each offer a different one-line invitation.",
                    dimension: "Timing",
                    symbolName: "clock"
                ),
                IdeaCycleSpark(
                    id: "focus-breadcrumb",
                    title: "Focus breadcrumb",
                    detail: "A Now choice can leave a breadcrumb that helps restart without rereading the reflection.",
                    dimension: "Action",
                    symbolName: "point.topleft.down.curvedto.point.bottomright.up"
                ),
                IdeaCycleSpark(
                    id: "soft-reminder-script",
                    title: "Soft reminder script",
                    detail: "Reminder copy can sound like a kind older student instead of an app demanding activity.",
                    dimension: "Voice",
                    symbolName: "bell.badge"
                )
            ]
        )
    }

    static var sensoryMotionLayer: IdeaCycleStage {
        IdeaCycleStage(
            id: "sensory-motion-layer",
            title: "Round 3: Sensory Motion Layer",
            focus: "Make motion feel meaningful and sound-like even when the app stays quiet.",
            implementedResult: "The studio now summarizes all active idea cycles with a resonance line, turning the brainstorm into a visible product direction.",
            sparks: [
                IdeaCycleSpark(
                    id: "ambient-metronome",
                    title: "Ambient metronome",
                    detail: "A barely visible rhythm can help the storm feel alive without becoming distracting.",
                    dimension: "Motion",
                    symbolName: "metronome"
                ),
                IdeaCycleSpark(
                    id: "pressure-tint-drift",
                    title: "Pressure tint drift",
                    detail: "Stress-heavy weeks can slowly tint the sky before the garden clears it.",
                    dimension: "Visual",
                    symbolName: "cloud.bolt"
                ),
                IdeaCycleSpark(
                    id: "haptic-visual-pulse",
                    title: "Haptic visual pulse",
                    detail: "A planting pulse can look tactile even without relying on real haptics.",
                    dimension: "Feeling",
                    symbolName: "dot.radiowaves.left.and.right"
                ),
                IdeaCycleSpark(
                    id: "silent-chime",
                    title: "Silent chime",
                    detail: "A small ring of light can replace sound when Local sound is muted.",
                    dimension: "Sound",
                    symbolName: "bell"
                ),
                IdeaCycleSpark(
                    id: "bloom-chord-palette",
                    title: "Bloom chord palette",
                    detail: "Each mood can contribute a note-like color to the final weekly bloom.",
                    dimension: "Color",
                    symbolName: "music.note"
                ),
                IdeaCycleSpark(
                    id: "orbit-tempo",
                    title: "Orbit tempo",
                    detail: "The storm's orbit speed can reflect calibration loudness and week density.",
                    dimension: "Motion",
                    symbolName: "circle.dashed"
                ),
                IdeaCycleSpark(
                    id: "reduce-motion-flipbook",
                    title: "Reduce Motion flipbook",
                    detail: "Motion-heavy reveals can become clear step cards when Reduce Motion is on.",
                    dimension: "Accessibility",
                    symbolName: "rectangle.stack"
                ),
                IdeaCycleSpark(
                    id: "reflection-ink-ripple",
                    title: "Reflection ink ripple",
                    detail: "Typed words can ripple once before becoming safe weather fragments.",
                    dimension: "Privacy",
                    symbolName: "drop"
                ),
                IdeaCycleSpark(
                    id: "constellation-hum",
                    title: "Constellation hum",
                    detail: "The weekly constellation can pulse like a quiet chord while staying visual-first.",
                    dimension: "Weekly",
                    symbolName: "sparkles"
                ),
                IdeaCycleSpark(
                    id: "museum-spotlight",
                    title: "Museum spotlight",
                    detail: "The newest artifact can receive a soft spotlight so archive history feels curated.",
                    dimension: "Archive",
                    symbolName: "lightbulb"
                )
            ]
        )
    }

    private static func dominantDimension(in dimensions: [String]) -> String? {
        var counts: [String: Int] = [:]
        for dimension in dimensions {
            counts[dimension, default: 0] += 1
        }

        return counts.max { left, right in
            if left.value == right.value {
                return left.key > right.key
            }
            return left.value < right.value
        }?.key
    }
}
