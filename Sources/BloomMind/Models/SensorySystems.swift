import Foundation
#if canImport(AudioToolbox)
import AudioToolbox
#endif

enum SensorySoundEvent: String, CaseIterable, Identifiable {
    case storm
    case root
    case glass
    case wind
    case soil
    case bloom

    var id: String { rawValue }

    var title: String {
        switch self {
        case .storm:
            "Storm"
        case .root:
            "Root"
        case .glass:
            "Glass"
        case .wind:
            "Wind"
        case .soil:
            "Soil"
        case .bloom:
            "Bloom"
        }
    }

    var detail: String {
        switch self {
        case .storm:
            "A low pulse for pressure gathering."
        case .root:
            "A grounded tap for Now choices."
        case .glass:
            "A small chime for Later choices."
        case .wind:
            "A light release for Let go choices."
        case .soil:
            "A warm pulse for planting."
        case .bloom:
            "A soft chord for the weekly reveal."
        }
    }

    var symbolName: String {
        switch self {
        case .storm:
            "tornado"
        case .root:
            "arrow.down.to.line"
        case .glass:
            "circle.dotted"
        case .wind:
            "wind"
        case .soil:
            "camera.macro"
        case .bloom:
            "sparkles"
        }
    }

    var systemSoundID: UInt32 {
        switch self {
        case .storm:
            1104
        case .root:
            1105
        case .glass:
            1057
        case .wind:
            1103
        case .soil:
            1106
        case .bloom:
            1025
        }
    }
}

struct SoundscapeProfile: Equatable {
    let title: String
    let detail: String
    let events: [SensorySoundEvent]
    let dominantMood: Mood?
    let dominantLane: GrowthLane?

    var accessibilityValue: String {
        let eventNames = events.map(\.title).joined(separator: ", ")
        return "\(detail) Available local sound cues: \(eventNames)."
    }
}

enum SensorySoundEngine {
    static func play(_ event: SensorySoundEvent) {
        #if canImport(AudioToolbox)
        AudioServicesPlaySystemSound(event.systemSoundID)
        #endif
    }
}

struct WeatherInstrumentReading: Equatable, Identifiable {
    let id: String
    let title: String
    let value: String
    let detail: String
    let symbolName: String
}

struct RareBloom: Equatable, Identifiable {
    let id: String
    let title: String
    let detail: String
    let atlasLine: String
    let symbolName: String
    let mood: Mood
    let lane: GrowthLane
    let theme: ReflectionTheme
}

struct EmotionalSeason: Equatable {
    let title: String
    let detail: String
    let symbolName: String
}

enum SensoryObservatory {
    static func soundscape(for seeds: [GardenSeed]) -> SoundscapeProfile {
        let dominantMood = dominantValue(in: seeds.map(\.mood))
        let dominantLane = dominantValue(in: seeds.map(\.lane))
        var events: [SensorySoundEvent] = [.storm, .soil]

        switch dominantLane {
        case .now?:
            events.append(.root)
        case .later?:
            events.append(.glass)
        case .release?:
            events.append(.wind)
        case nil:
            events.append(contentsOf: [.root, .wind])
        }

        if seeds.count >= CheckInState.weeklyCheckInGoal {
            events.append(.bloom)
        }

        return SoundscapeProfile(
            title: "Local soundscape",
            detail: soundscapeDetail(mood: dominantMood, lane: dominantLane, isComplete: seeds.count >= CheckInState.weeklyCheckInGoal),
            events: Array(events.prefix(4)),
            dominantMood: dominantMood,
            dominantLane: dominantLane
        )
    }

    static func weatherInstruments(
        for seeds: [GardenSeed],
        completedCount: Int,
        totalCount: Int
    ) -> [WeatherInstrumentReading] {
        let safeTotal = max(totalCount, 1)
        let pressureCount = seeds.filter { seed in
            seed.mood == .stressed || seed.mood == .overwhelmed || seed.theme == .pressure
        }.count
        let releaseCount = seeds.filter { $0.lane == .release }.count
        let unsureCount = seeds.filter { $0.mood == .unsure || $0.theme == .uncertainty }.count
        let dominantLane = dominantValue(in: seeds.map(\.lane)) ?? .now
        let newestMood = seeds.last?.mood

        return [
            WeatherInstrumentReading(
                id: "barometer",
                title: "Inner barometer",
                value: pressureCount >= 3 ? "High" : pressureCount == 0 ? "Clear" : "Moving",
                detail: "\(pressureCount) pressure signals are visible this week.",
                symbolName: "gauge"
            ),
            WeatherInstrumentReading(
                id: "compass",
                title: "Root compass",
                value: dominantLane.title,
                detail: dominantLane.gardenConsequenceDetail,
                symbolName: dominantLane.symbolName
            ),
            WeatherInstrumentReading(
                id: "clock",
                title: "Weather clock",
                value: newestMood?.rawValue ?? "Waiting",
                detail: newestMood == nil ? "The first signal has not arrived yet." : "The newest weather color is \(newestMood?.rawValue.lowercased() ?? "present").",
                symbolName: newestMood?.symbolName ?? "clock"
            ),
            WeatherInstrumentReading(
                id: "fog",
                title: "Fog meter",
                value: unsureCount == 0 ? "Low" : "\(unsureCount)",
                detail: unsureCount == 0 ? "No uncertainty layer is leading right now." : "Questions are visible instead of hidden in the storm.",
                symbolName: "cloud.fog"
            ),
            WeatherInstrumentReading(
                id: "air",
                title: "Air gauge",
                value: "\(releaseCount)/\(safeTotal)",
                detail: releaseCount == 0 ? "No Let go choices yet." : "Let go choices have opened more air in the garden.",
                symbolName: "wind"
            )
        ]
    }

    static func rareBloom(for seed: GardenSeed) -> RareBloom {
        let bloomID = "\(seed.mood.rawValue)-\(seed.lane.rawValue)-\(seed.theme.rawValue)"

        switch (seed.mood, seed.lane, seed.theme) {
        case (.overwhelmed, .release, .pressure):
            return RareBloom(
                id: bloomID,
                title: "Storm-break bloom",
                detail: "A rare bloom for a too-much day that made more air.",
                atlasLine: "Overwhelm became smaller when one pressure was allowed to leave this minute.",
                symbolName: "cloud.bolt",
                mood: seed.mood,
                lane: seed.lane,
                theme: seed.theme
            )
        case (.focused, .now, .school):
            return RareBloom(
                id: bloomID,
                title: "Compass bloom",
                detail: "A rare bloom for attention that found one direction.",
                atlasLine: "Focus became growth when it was protected as the next visible step.",
                symbolName: "scope",
                mood: seed.mood,
                lane: seed.lane,
                theme: seed.theme
            )
        case (.lonely, .later, .friendship):
            return RareBloom(
                id: bloomID,
                title: "Signal flower",
                detail: "A rare bloom for a social worry that did not need to be solved immediately.",
                atlasLine: "Loneliness became a signal for care instead of proof of isolation.",
                symbolName: "bubble.left.and.bubble.right",
                mood: seed.mood,
                lane: seed.lane,
                theme: seed.theme
            )
        case (.stressed, .release, .pressure):
            return RareBloom(
                id: bloomID,
                title: "Weather stone bloom",
                detail: "A rare bloom for pressure that learned to make air.",
                atlasLine: "Stress became lighter when one urgent thing stopped carrying the whole sky.",
                symbolName: "wind",
                mood: seed.mood,
                lane: seed.lane,
                theme: seed.theme
            )
        case (.tired, .later, .rest):
            return RareBloom(
                id: bloomID,
                title: "Moon bell garden",
                detail: "A rare bloom for rest protected from the whole schedule.",
                atlasLine: "Low energy became information instead of a failure signal.",
                symbolName: "moon.stars",
                mood: seed.mood,
                lane: seed.lane,
                theme: seed.theme
            )
        case (.unsure, .now, .uncertainty):
            return RareBloom(
                id: bloomID,
                title: "Question lantern",
                detail: "A rare bloom for fog that became one answerable question.",
                atlasLine: "Uncertainty moved when it became one clear next question.",
                symbolName: "questionmark.bubble",
                mood: seed.mood,
                lane: seed.lane,
                theme: seed.theme
            )
        case (.happy, .later, .friendship):
            return RareBloom(
                id: bloomID,
                title: "Sun archive bloom",
                detail: "A rare bloom for warm social energy protected from rushing.",
                atlasLine: "Good energy became part of the record instead of something to skip past.",
                symbolName: "sun.max",
                mood: seed.mood,
                lane: seed.lane,
                theme: seed.theme
            )
        case (.calm, .now, .school):
            return RareBloom(
                id: bloomID,
                title: "Root compass flower",
                detail: "A rare bloom for school pressure turned into one visible step.",
                atlasLine: "Steadiness became useful when it pointed at the next small task.",
                symbolName: "arrow.down.right.circle",
                mood: seed.mood,
                lane: seed.lane,
                theme: seed.theme
            )
        default:
            return RareBloom(
                id: bloomID,
                title: "\(seed.mood.rawValue) \(seed.lane.title) bloom",
                detail: "A private bloom shaped by mood, pressure layer, and sorting choice.",
                atlasLine: "\(seed.mood.rawValue) became \(seed.lane.gardenConsequenceTitle.lowercased()) through a \(seed.theme.displayName.lowercased()) seed.",
                symbolName: seed.mood.symbolName,
                mood: seed.mood,
                lane: seed.lane,
                theme: seed.theme
            )
        }
    }

    static func rareBloomAtlas(for seeds: [GardenSeed]) -> [RareBloom] {
        var seen = Set<String>()
        var blooms: [RareBloom] = []

        for seed in seeds {
            let bloom = rareBloom(for: seed)
            guard !seen.contains(bloom.id) else {
                continue
            }

            seen.insert(bloom.id)
            blooms.append(bloom)
        }

        return blooms
    }

    static func season(for seeds: [GardenSeed]) -> EmotionalSeason {
        let dominantMood = dominantValue(in: seeds.map(\.mood))
        let dominantLane = dominantValue(in: seeds.map(\.lane))

        switch (dominantMood, dominantLane) {
        case (.overwhelmed?, _), (.stressed?, _):
            return EmotionalSeason(title: "Storm season", detail: "Many signals were loud, but they still became visible.", symbolName: "cloud.bolt")
        case (.tired?, _):
            return EmotionalSeason(title: "Rest season", detail: "The garden kept making room for lower energy.", symbolName: "moon")
        case (.calm?, _), (.focused?, _):
            return EmotionalSeason(title: "Clear season", detail: "The week protected steadiness and attention.", symbolName: "scope")
        case (.unsure?, _):
            return EmotionalSeason(title: "Question season", detail: "The week turned fog into answerable questions.", symbolName: "questionmark.circle")
        case (.lonely?, _):
            return EmotionalSeason(title: "Signal season", detail: "The garden noticed small signals for care.", symbolName: "bubble.left")
        case (.happy?, _):
            return EmotionalSeason(title: "Sun season", detail: "Bright energy became part of the record.", symbolName: "sun.max")
        case (_, .release?):
            return EmotionalSeason(title: "Open-air season", detail: "Let go choices made the garden lighter.", symbolName: "wind")
        default:
            return EmotionalSeason(title: "Mixed season", detail: "The week did not need one mood to become a landscape.", symbolName: "sparkles")
        }
    }

    private static func soundscapeDetail(
        mood: Mood?,
        lane: GrowthLane?,
        isComplete: Bool
    ) -> String {
        if isComplete {
            return "The week has enough seeds for a soft bloom chord."
        }

        guard let mood else {
            return "The observatory can play local cues once the first seed appears."
        }

        let laneLine = lane?.title ?? "unplaced"
        return "\(mood.rawValue) weather is mapped to a \(laneLine.lowercased()) sound cue."
    }

    private static func dominantValue<Value: Hashable>(in values: [Value]) -> Value? {
        guard let newest = values.last else {
            return nil
        }

        let counts = values.reduce(into: [Value: Int]()) { partialResult, value in
            partialResult[value, default: 0] += 1
        }

        var dominant = newest
        var dominantCount = counts[dominant, default: 0]

        for value in values.reversed() {
            let count = counts[value, default: 0]
            if count > dominantCount {
                dominant = value
                dominantCount = count
            }
        }

        return dominant
    }
}
