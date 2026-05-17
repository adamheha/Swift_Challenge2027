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
            sensoryMotionLayer,
            narrativeDepth,
            awardPolishSecretGarden
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

    static var narrativeDepth: IdeaCycleStage {
        IdeaCycleStage(
            id: "narrative-depth",
            title: "Round 4: Narrative Depth",
            focus: "Make the experience feel like a short emotional story with a beginning, turning point, and memory.",
            implementedResult: "The studio now carries a story-focused round so future polish can target narrative beats, not only UI elements.",
            sparks: [
                IdeaCycleSpark(
                    id: "origin-fragments",
                    title: "Origin fragments",
                    detail: "Opening pressure pieces can feel like real student life before they become weather.",
                    dimension: "Story",
                    symbolName: "doc.text"
                ),
                IdeaCycleSpark(
                    id: "turning-point-marker",
                    title: "Turning-point marker",
                    detail: "The exact moment a storm reveals a seed can be marked as the story's turn.",
                    dimension: "Drama",
                    symbolName: "arrow.triangle.turn.up.right.circle"
                ),
                IdeaCycleSpark(
                    id: "scene-title",
                    title: "Scene title",
                    detail: "Each major step can have a short cinematic title instead of generic instruction copy.",
                    dimension: "Voice",
                    symbolName: "text.quote"
                ),
                IdeaCycleSpark(
                    id: "protagonist-voice",
                    title: "Protagonist voice",
                    detail: "Copy can sound like the student is moving through the story, not being managed by an app.",
                    dimension: "Voice",
                    symbolName: "person"
                ),
                IdeaCycleSpark(
                    id: "before-after-sky",
                    title: "Before/after sky",
                    detail: "Weekly Bloom can contrast the first storm sky with the final garden sky.",
                    dimension: "Visual",
                    symbolName: "arrow.left.and.right"
                ),
                IdeaCycleSpark(
                    id: "choice-trail",
                    title: "Choice trail",
                    detail: "Now, Later, and Let go choices can leave a visible path through the week.",
                    dimension: "Memory",
                    symbolName: "point.topleft.down.to.point.bottomright.curvepath"
                ),
                IdeaCycleSpark(
                    id: "artifact-footnote",
                    title: "Artifact footnote",
                    detail: "Each artifact can carry one small line about what made it form.",
                    dimension: "Archive",
                    symbolName: "note.text"
                ),
                IdeaCycleSpark(
                    id: "weekly-conflict",
                    title: "Weekly conflict",
                    detail: "A week can be described as a tension that changed shape, not a score.",
                    dimension: "Content",
                    symbolName: "bolt.horizontal"
                ),
                IdeaCycleSpark(
                    id: "quiet-narrator",
                    title: "Quiet narrator captions",
                    detail: "The 90-second demo can use sparse captions that feel like story beats.",
                    dimension: "Demo",
                    symbolName: "captions.bubble"
                ),
                IdeaCycleSpark(
                    id: "applicant-story-adapter",
                    title: "Applicant story adapter",
                    detail: "The final origin moment can be swapped from scaffold to the applicant's exact real story.",
                    dimension: "Submission",
                    symbolName: "person.text.rectangle"
                )
            ]
        )
    }

    static var awardPolishSecretGarden: IdeaCycleStage {
        IdeaCycleStage(
            id: "award-polish-secret-garden",
            title: "Round 5: Award Polish",
            focus: "Add the kinds of final details that make a judge feel the app has craft, depth, and a hidden life.",
            implementedResult: "The studio now closes with a fifth round, giving BloomMind fifty concrete future-facing sparks inside the product itself.",
            sparks: [
                IdeaCycleSpark(
                    id: "secret-atlas-room",
                    title: "Secret atlas room",
                    detail: "A completed week can unlock a quieter atlas corner that feels discovered, not assigned.",
                    dimension: "Explore",
                    symbolName: "map"
                ),
                IdeaCycleSpark(
                    id: "readiness-compass",
                    title: "Judge readiness compass",
                    detail: "A private rehearsal card can show whether the 90-second path has origin, interaction, payoff, and privacy.",
                    dimension: "Demo",
                    symbolName: "safari"
                ),
                IdeaCycleSpark(
                    id: "one-minute-promise",
                    title: "One-minute promise",
                    detail: "The opening can promise that one honest minute is enough to change the weather.",
                    dimension: "Voice",
                    symbolName: "timer"
                ),
                IdeaCycleSpark(
                    id: "aha-marker",
                    title: "Aha marker",
                    detail: "The moment pressure visibly becomes a seed can receive a brighter visual accent.",
                    dimension: "Impact",
                    symbolName: "lightbulb.max"
                ),
                IdeaCycleSpark(
                    id: "final-rehearsal-trail",
                    title: "Final rehearsal trail",
                    detail: "The demo path can leave a simple trail so submission practice feels reliable.",
                    dimension: "Submission",
                    symbolName: "figure.walk.motion"
                ),
                IdeaCycleSpark(
                    id: "student-made-texture",
                    title: "Student-made texture",
                    detail: "Small handwritten-feeling lines can make the app feel authored by a student, not a template.",
                    dimension: "Identity",
                    symbolName: "pencil.and.outline"
                ),
                IdeaCycleSpark(
                    id: "personal-story-slot",
                    title: "Personal story slot",
                    detail: "The final origin line can expose one clear place to insert the applicant's true school-pressure moment.",
                    dimension: "Story",
                    symbolName: "person.text.rectangle"
                ),
                IdeaCycleSpark(
                    id: "backstage-health-card",
                    title: "Backstage health card",
                    detail: "A tiny local-only readiness card can reassure that there are no accounts, tracking, or network calls.",
                    dimension: "Trust",
                    symbolName: "lock.shield"
                ),
                IdeaCycleSpark(
                    id: "completion-sparkline",
                    title: "Completion sparkline",
                    detail: "The seven-day arc can appear as a small living line beside the final artifact.",
                    dimension: "Weekly",
                    symbolName: "chart.line.uptrend.xyaxis"
                ),
                IdeaCycleSpark(
                    id: "accessibility-jewel",
                    title: "Accessibility jewel",
                    detail: "One beautiful detail can be designed specifically for VoiceOver, proving accessibility is part of the art.",
                    dimension: "Accessibility",
                    symbolName: "accessibility"
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
