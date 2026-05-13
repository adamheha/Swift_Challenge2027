import SwiftUI

struct EmotionGardenView: View {
    let title: String
    let seeds: [GardenSeed]
    let totalPlots: Int
    let progressText: String
    let accessibilityValue: String

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var newestPlantIsGrown = true
    @State private var selectedPlotIndex: Int?
    @State private var selectedWorldZone: GardenWorldZone = .centerBloom

    private var safeTotalPlots: Int {
        max(totalPlots, 0)
    }

    private var visibleSeeds: [GardenSeed] {
        Array(seeds.prefix(safeTotalPlots))
    }

    private var visibleMoods: [Mood] {
        visibleSeeds.map(\.mood)
    }

    private var newestMoodIndex: Int? {
        visibleSeeds.indices.last
    }

    private var newestSeed: GardenSeed? {
        visibleSeeds.last
    }

    private var selectedSeed: GardenSeed? {
        guard
            let selectedPlotIndex,
            visibleSeeds.indices.contains(selectedPlotIndex)
        else {
            return nil
        }

        return visibleSeeds[selectedPlotIndex]
    }

    private var wrappedColumns: [GridItem] {
        [GridItem(.adaptive(minimum: dynamicTypeSize.isAccessibilitySize ? 82 : 66), spacing: 8)]
    }

    var body: some View {
        ZStack {
            if !visibleSeeds.isEmpty {
                GardenAtmosphereView(seeds: visibleSeeds)
                    .allowsHitTesting(false)
            }

            VStack(alignment: .leading, spacing: 16) {
                header

                if let newestSeed {
                    GardenPayoffBannerView(
                        seed: newestSeed,
                        completedCount: visibleSeeds.count,
                        totalCount: safeTotalPlots
                    )

                    GardenMemoryStripView(
                        seeds: visibleSeeds,
                        totalCount: safeTotalPlots
                    )

                    GardenEcologyLineView(seeds: visibleSeeds)

                    InnerGardenWorldView(seeds: visibleSeeds)

                    GardenWorldZoneMapView(
                        seeds: visibleSeeds,
                        totalCount: safeTotalPlots,
                        selectedZone: $selectedWorldZone
                    )
                }

                plotLayout

                if let selectedSeed {
                    GardenPlantDetailView(
                        seed: selectedSeed,
                        isNewest: selectedPlotIndex == newestMoodIndex,
                        evolutionStage: selectedSeedEvolutionStage
                    )
                }
            }
        }
        .bloomPanel(padding: 16)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(title)
        .accessibilityValue(accessibilityValue)
        .onAppear(perform: animateNewestPlant)
        .onChange(of: visibleMoods.count) { _, _ in
            animateNewestPlant()
        }
        .onChange(of: reduceMotion) { _, _ in
            newestPlantIsGrown = true
        }
    }

    private func animateNewestPlant() {
        if selectedPlotIndex == nil || selectedSeed == nil {
            selectedPlotIndex = newestMoodIndex
        }

        guard !reduceMotion, newestMoodIndex != nil else {
            newestPlantIsGrown = true
            return
        }

        newestPlantIsGrown = false

        withAnimation(.spring(response: 0.62, dampingFraction: 0.74).delay(0.08)) {
            newestPlantIsGrown = true
        }
    }

    @ViewBuilder
    private var header: some View {
        ViewThatFits(in: .horizontal) {
            HStack {
                gardenTitle

                Spacer()

                progressBadge
            }

            VStack(alignment: .leading, spacing: 6) {
                gardenTitle
                progressBadge
            }
        }
    }

    private var gardenTitle: some View {
        Label(title, systemImage: "camera.macro")
            .font(.headline)
            .fixedSize(horizontal: false, vertical: true)
    }

    private var progressBadge: some View {
        Text(progressText)
            .font(.caption.bold())
            .foregroundStyle(.secondary)
            .monospacedDigit()
            .lineLimit(1)
            .minimumScaleFactor(0.8)
    }

    @ViewBuilder
    private var plotLayout: some View {
        if dynamicTypeSize.isAccessibilitySize {
            wrappedPlots
        } else {
            ViewThatFits(in: .horizontal) {
                horizontalPlots
                wrappedPlots
            }
        }
    }

    private var horizontalPlots: some View {
        HStack(spacing: 8) {
            ForEach(0..<safeTotalPlots, id: \.self) { index in
                plot(at: index)
            }
        }
    }

    private var wrappedPlots: some View {
        LazyVGrid(columns: wrappedColumns, spacing: 8) {
            ForEach(0..<safeTotalPlots, id: \.self) { index in
                plot(at: index)
            }
        }
    }

    private func plot(at index: Int) -> some View {
        let seed = visibleSeeds.indices.contains(index) ? visibleSeeds[index] : nil

        return EmotionGardenPlotView(
            seed: seed,
            evolutionStage: seed?.evolutionStage(index: index, totalCount: visibleSeeds.count),
            isSelected: selectedPlotIndex == index,
            isNewest: newestMoodIndex == index,
            newestPlantIsGrown: newestPlantIsGrown || reduceMotion
        ) {
            selectedPlotIndex = index
        }
    }

    private var selectedSeedEvolutionStage: SeedEvolutionStage {
        guard let selectedPlotIndex else {
            return .justPlanted
        }

        return selectedSeed?.evolutionStage(
            index: selectedPlotIndex,
            totalCount: visibleSeeds.count
        ) ?? .justPlanted
    }
}

private enum GardenWorldZone: String, CaseIterable, Identifiable {
    case roots
    case path
    case openSky
    case centerBloom

    var id: String { rawValue }

    var title: String {
        switch self {
        case .roots:
            "Underground roots"
        case .path:
            "Waiting path"
        case .openSky:
            "Open sky"
        case .centerBloom:
            "Center bloom"
        }
    }

    var systemImage: String {
        switch self {
        case .roots:
            "bolt.fill"
        case .path:
            "tray"
        case .openSky:
            "wind"
        case .centerBloom:
            "sparkles"
        }
    }

    func tint(newestMood: Mood?) -> Color {
        switch self {
        case .roots:
            newestMood?.tint ?? .green
        case .path:
            .blue
        case .openSky:
            .orange
        case .centerBloom:
            newestMood?.tint ?? .mint
        }
    }

    func detail(seeds: [GardenSeed], totalCount: Int) -> String {
        let nowCount = seeds.filter { $0.lane == .now }.count
        let laterCount = seeds.filter { $0.lane == .later }.count
        let releaseCount = seeds.filter { $0.lane == .release }.count

        switch self {
        case .roots:
            return nowCount == 1
                ? "1 Now choice is holding the garden from underneath."
                : "\(nowCount) Now choices are holding the garden from underneath."
        case .path:
            return laterCount == 1
                ? "1 Later choice became a patient bud on the path."
                : "\(laterCount) Later choices became patient buds on the path."
        case .openSky:
            return releaseCount == 1
                ? "1 Let go choice opened space in the sky."
                : "\(releaseCount) Let go choices opened space in the sky."
        case .centerBloom:
            return seeds.count >= totalCount
                ? "Seven seeds have awakened the center bloom."
                : "\(seeds.count) of \(totalCount) seeds are still moving toward the center bloom."
        }
    }
}

private struct GardenWorldZoneMapView: View {
    let seeds: [GardenSeed]
    let totalCount: Int
    @Binding var selectedZone: GardenWorldZone

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var newestMood: Mood? {
        seeds.last?.mood
    }

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: dynamicTypeSize.isAccessibilitySize ? 180 : 136), spacing: 8)]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Garden map", systemImage: "map")
                .font(.subheadline.bold())
                .foregroundStyle(newestMood?.tint ?? .green)
                .fixedSize(horizontal: false, vertical: true)

            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(GardenWorldZone.allCases) { zone in
                    Button {
                        withAnimation(.spring(response: 0.34, dampingFraction: 0.78)) {
                            selectedZone = zone
                        }
                    } label: {
                        GardenWorldZoneButtonView(
                            zone: zone,
                            isSelected: selectedZone == zone,
                            tint: zone.tint(newestMood: newestMood),
                            detail: zone.detail(seeds: seeds, totalCount: totalCount)
                        )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(zone.title)
                    .accessibilityValue(zone.detail(seeds: seeds, totalCount: totalCount))
                    .accessibilityAddTraits(selectedZone == zone ? .isSelected : [])
                }
            }

            GardenWorldZoneDetailView(
                zone: selectedZone,
                seeds: seeds,
                totalCount: totalCount,
                tint: selectedZone.tint(newestMood: newestMood)
            )
        }
        .padding(12)
        .background((newestMood?.tint ?? .green).opacity(0.08), in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke((newestMood?.tint ?? .green).opacity(0.18), lineWidth: 1)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Garden map")
    }
}

private struct GardenWorldZoneButtonView: View {
    let zone: GardenWorldZone
    let isSelected: Bool
    let tint: Color
    let detail: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: zone.systemImage)
                .font(.headline.bold())
                .foregroundStyle(tint)
                .accessibilityHidden(true)

            Text(zone.title)
                .font(.caption.bold())
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

            Text(detail)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, minHeight: 112, alignment: .topLeading)
        .padding(10)
        .background(tint.opacity(isSelected ? 0.16 : 0.08), in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(tint.opacity(isSelected ? 0.58 : 0.16), lineWidth: isSelected ? 2 : 1)
        }
    }
}

private struct GardenWorldZoneDetailView: View {
    let zone: GardenWorldZone
    let seeds: [GardenSeed]
    let totalCount: Int
    let tint: Color

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: zone.systemImage)
                .font(.subheadline.bold())
                .foregroundStyle(tint)
                .frame(width: 22)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(zone.title)
                    .font(.subheadline.bold())
                    .fixedSize(horizontal: false, vertical: true)

                Text(zone.detail(seeds: seeds, totalCount: totalCount))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                Text(consequenceLine)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .layoutPriority(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(tint.opacity(0.10), in: RoundedRectangle(cornerRadius: 8))
    }

    private var consequenceLine: String {
        switch zone {
        case .roots:
            "Now choices become root structure, so one next step has a place to hold."
        case .path:
            "Later choices become buds and lanterns, so the bigger worry can wait without disappearing."
        case .openSky:
            "Let go choices become wind and starlight, so the garden can breathe."
        case .centerBloom:
            "When the week reaches seven seeds, the center bloom turns the whole pattern into an artifact."
        }
    }
}

private struct GardenMemoryStripView: View {
    let seeds: [GardenSeed]
    let totalCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Week memory", systemImage: "sparkles.rectangle.stack")
                .font(.subheadline.bold())
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Array(seeds.enumerated()), id: \.offset) { index, seed in
                        GardenMemoryChipView(
                            index: index + 1,
                            seed: seed
                        )
                    }

                    ForEach(seeds.count..<max(totalCount, seeds.count), id: \.self) { index in
                        GardenMemoryEmptyChipView(index: index + 1)
                    }
                }
                .padding(.vertical, 1)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Week memory")
        .accessibilityValue(accessibilityValue)
    }

    private var accessibilityValue: String {
        guard !seeds.isEmpty else {
            return "No transformed storms yet."
        }

        let memory = seeds
            .enumerated()
            .map { index, seed in
                "Seed \(index + 1): \(seed.mood.rawValue), \(seed.lane.title)"
            }
            .joined(separator: ", ")

        return memory
    }
}

private struct GardenMemoryChipView: View {
    let index: Int
    let seed: GardenSeed

    private var mood: Mood {
        seed.mood
    }

    var body: some View {
        HStack(spacing: 6) {
            Text("\(index)")
                .font(.caption2.bold())
                .monospacedDigit()
                .foregroundStyle(.white)
                .frame(width: 20, height: 20)
                .background(mood.tint, in: Circle())

            Image(systemName: mood.symbolName)
                .font(.caption.bold())
                .foregroundStyle(mood.tint)
                .accessibilityHidden(true)

            Image(systemName: seed.lane.symbolName)
                .font(.caption2.bold())
                .foregroundStyle(mood.tint.opacity(0.82))
                .accessibilityHidden(true)

            Text(mood.rawValue)
                .font(.caption.weight(.medium))
                .foregroundStyle(.primary)
        }
        .padding(.horizontal, 9)
        .padding(.vertical, 7)
        .background(mood.tint.opacity(0.11), in: Capsule())
        .overlay {
            Capsule()
                .stroke(mood.tint.opacity(0.22), lineWidth: 1)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Seed \(index), \(mood.rawValue), \(seed.lane.title)")
    }
}

private struct GardenMemoryEmptyChipView: View {
    let index: Int

    var body: some View {
        Text("\(index)")
            .font(.caption2.bold())
            .monospacedDigit()
            .foregroundStyle(.secondary)
            .frame(width: 28, height: 28)
            .background(Color.secondary.opacity(0.10), in: Circle())
            .accessibilityLabel("Empty seed \(index)")
    }
}

private struct GardenEcologyLineView: View {
    let seeds: [GardenSeed]

    private var newestSeed: GardenSeed? {
        seeds.last
    }

    private var dominantMood: Mood? {
        dominantValue(in: seeds.map(\.mood))
    }

    private var dominantLane: GrowthLane? {
        dominantValue(in: seeds.map(\.lane))
    }

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: dominantLane?.symbolName ?? "sparkles")
                .font(.subheadline.bold())
                .foregroundStyle(newestSeed?.mood.tint ?? .green)
                .frame(width: 22)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 3) {
                Text("Living garden")
                    .font(.subheadline.bold())
                    .fixedSize(horizontal: false, vertical: true)

                Text(ecologyLine)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .layoutPriority(1)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Living garden")
        .accessibilityValue(ecologyLine)
    }

    private var ecologyLine: String {
        guard let dominantMood, let dominantLane else {
            return "The garden is waiting for its first weather pattern."
        }

        let moodPhrase = switch dominantMood {
        case .calm:
            "clearer light"
        case .happy:
            "warmer bloom"
        case .tired:
            "quieter night growth"
        case .stressed:
            "softened storm traces"
        case .unsure:
            "half-open question buds"
        }

        let lanePhrase = switch dominantLane {
        case .now:
            "stronger roots"
        case .later:
            "patient buds"
        case .release:
            "more open air"
        }

        return "\(dominantMood.rawValue) gives the garden \(moodPhrase), while \(dominantLane.title.lowercased()) adds \(lanePhrase)."
    }

    private func dominantValue<Value: Hashable>(in values: [Value]) -> Value? {
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

private struct InnerGardenWorldView: View {
    let seeds: [GardenSeed]

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var sceneHeight: CGFloat {
        dynamicTypeSize.isAccessibilitySize ? 250 : 210
    }

    private var newestMood: Mood {
        seeds.last?.mood ?? .calm
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            TimelineView(.animation) { timeline in
                Canvas { context, size in
                    drawWorld(
                        in: &context,
                        size: size,
                        time: reduceMotion ? 0 : timeline.date.timeIntervalSinceReferenceDate
                    )
                }
            }

            VStack(alignment: .leading, spacing: 5) {
                Label("Inner garden world", systemImage: "map")
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.45), radius: 5, x: 0, y: 2)

                Text(worldSummary)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.84))
                    .fixedSize(horizontal: false, vertical: true)
                    .shadow(color: .black.opacity(0.45), radius: 4, x: 0, y: 2)
            }
            .padding(14)
        }
        .frame(height: sceneHeight)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(newestMood.tint.opacity(0.34), lineWidth: 1)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Inner garden world")
        .accessibilityValue(worldSummary)
    }

    private var worldSummary: String {
        let roots = seeds.filter { $0.lane == .now }.count
        let buds = seeds.filter { $0.lane == .later }.count
        let air = seeds.filter { $0.lane == .release }.count
        return "\(roots) roots, \(buds) buds, and \(air) pieces of open air are shaping this week."
    }

    private func drawWorld(
        in context: inout GraphicsContext,
        size: CGSize,
        time: TimeInterval
    ) {
        let width = max(size.width, 1)
        let height = max(size.height, 1)
        drawSky(in: &context, width: width, height: height)
        drawWeather(in: &context, width: width, height: height, time: time)
        drawGround(in: &context, width: width, height: height)
        drawSeedConsequences(in: &context, width: width, height: height, time: time)
        drawWorldPlants(in: &context, width: width, height: height, time: time)
    }

    private func drawSky(in context: inout GraphicsContext, width: CGFloat, height: CGFloat) {
        context.fill(
            Path(CGRect(x: 0, y: 0, width: width, height: height)),
            with: .linearGradient(
                Gradient(colors: [
                    Color(red: 0.05, green: 0.10, blue: 0.16),
                    newestMood.tint.opacity(0.24),
                    Color(red: 0.09, green: 0.16, blue: 0.13)
                ]),
                startPoint: CGPoint(x: width * 0.12, y: 0),
                endPoint: CGPoint(x: width, y: height)
            )
        )
    }

    private func drawWeather(
        in context: inout GraphicsContext,
        width: CGFloat,
        height: CGFloat,
        time: TimeInterval
    ) {
        for (index, seed) in seeds.enumerated() {
            let x = width * (0.12 + CGFloat(index % 4) * 0.23)
            let y = height * (0.16 + CGFloat(index / 4) * 0.14) + sin(time + Double(index)) * 4
            let radius = CGFloat(24 + (index % 3) * 8)
            context.fill(
                Path(ellipseIn: CGRect(
                    x: x - radius,
                    y: y - radius * 0.55,
                    width: radius * 2.2,
                    height: radius * 1.1
                )),
                with: .color(seed.mood.tint.opacity(0.12))
            )
        }
    }

    private func drawGround(in context: inout GraphicsContext, width: CGFloat, height: CGFloat) {
        var ground = Path()
        ground.move(to: CGPoint(x: 0, y: height * 0.72))
        ground.addCurve(
            to: CGPoint(x: width, y: height * 0.70),
            control1: CGPoint(x: width * 0.28, y: height * 0.62),
            control2: CGPoint(x: width * 0.70, y: height * 0.80)
        )
        ground.addLine(to: CGPoint(x: width, y: height))
        ground.addLine(to: CGPoint(x: 0, y: height))
        ground.closeSubpath()

        context.fill(
            ground,
            with: .linearGradient(
                Gradient(colors: [
                    Color(red: 0.24, green: 0.36, blue: 0.24).opacity(0.86),
                    Color(red: 0.22, green: 0.16, blue: 0.10).opacity(0.92)
                ]),
                startPoint: CGPoint(x: width * 0.5, y: height * 0.64),
                endPoint: CGPoint(x: width * 0.5, y: height)
            )
        )
    }

    private func drawSeedConsequences(
        in context: inout GraphicsContext,
        width: CGFloat,
        height: CGFloat,
        time: TimeInterval
    ) {
        for (index, seed) in seeds.enumerated() {
            let x = width * (0.11 + CGFloat(index) / CGFloat(max(seeds.count - 1, 1)) * 0.78)
            let groundY = height * (0.72 + CGFloat(index % 2) * 0.035)

            switch seed.lane {
            case .now:
                for rootIndex in 0..<3 {
                    var root = Path()
                    let spread = CGFloat(rootIndex - 1) * 0.11 * width
                    root.move(to: CGPoint(x: x, y: groundY))
                    root.addQuadCurve(
                        to: CGPoint(x: x + spread, y: height * 0.96),
                        control: CGPoint(x: x + spread * 0.18, y: height * 0.84)
                    )
                    context.stroke(
                        root,
                        with: .color(seed.mood.tint.opacity(0.34)),
                        style: StrokeStyle(lineWidth: 1.8, lineCap: .round)
                    )
                }
            case .later:
                let budRect = CGRect(
                    x: x + 10,
                    y: groundY - 34 - sin(time + Double(index)) * 2,
                    width: 22,
                    height: 34
                )
                context.fill(
                    Path(ellipseIn: budRect),
                    with: .color(seed.mood.tint.opacity(0.44))
                )
            case .release:
                for windIndex in 0..<2 {
                    var wind = Path()
                    let y = height * (0.34 + CGFloat(windIndex) * 0.10) + CGFloat(index % 2) * 6
                    wind.move(to: CGPoint(x: x - 34, y: y))
                    wind.addCurve(
                        to: CGPoint(x: min(width - 16, x + 58), y: y + sin(time) * 4),
                        control1: CGPoint(x: x - 10, y: y - 12),
                        control2: CGPoint(x: x + 26, y: y + 12)
                    )
                    context.stroke(
                        wind,
                        with: .color(seed.mood.tint.opacity(0.36)),
                        style: StrokeStyle(lineWidth: 1.4, lineCap: .round)
                    )
                }
            }
        }
    }

    private func drawWorldPlants(
        in context: inout GraphicsContext,
        width: CGFloat,
        height: CGFloat,
        time: TimeInterval
    ) {
        for (index, seed) in seeds.enumerated() {
            let x = width * (0.12 + CGFloat(index) / CGFloat(max(seeds.count - 1, 1)) * 0.76)
            let baseY = height * (0.72 + CGFloat(index % 2) * 0.035)
            let plantHeight = height * (0.13 + CGFloat(index % 3) * 0.025)
            var stem = Path()
            stem.move(to: CGPoint(x: x, y: baseY))
            stem.addQuadCurve(
                to: CGPoint(x: x + CGFloat(index % 2 == 0 ? -1 : 1) * 8, y: baseY - plantHeight),
                control: CGPoint(x: x + CGFloat(index % 3 - 1) * 8, y: baseY - plantHeight * 0.48)
            )
            context.stroke(
                stem,
                with: .color(seed.mood.tint.opacity(0.78)),
                style: StrokeStyle(lineWidth: 2.4, lineCap: .round)
            )

            let bloomRadius = CGFloat(7 + index % 3)
            let bloomCenter = CGPoint(
                x: x + CGFloat(index % 2 == 0 ? -1 : 1) * 8,
                y: baseY - plantHeight + sin(time * 0.8 + Double(index)) * 2
            )
            context.fill(
                Path(ellipseIn: CGRect(
                    x: bloomCenter.x - bloomRadius,
                    y: bloomCenter.y - bloomRadius,
                    width: bloomRadius * 2,
                    height: bloomRadius * 2
                )),
                with: .color(seed.mood.tint.opacity(0.86))
            )
        }
    }
}

private struct GardenAtmosphereView: View {
    let seeds: [GardenSeed]

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                drawAtmosphere(
                    in: &context,
                    size: size,
                    time: reduceMotion ? 0 : timeline.date.timeIntervalSinceReferenceDate
                )
            }
        }
        .opacity(0.78)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .accessibilityHidden(true)
    }

    private func drawAtmosphere(
        in context: inout GraphicsContext,
        size: CGSize,
        time: TimeInterval
    ) {
        guard !seeds.isEmpty else {
            return
        }

        let width = max(size.width, 1)
        let height = max(size.height, 1)
        let denominator = max(seeds.count - 1, 1)

        for (index, seed) in seeds.enumerated() {
            let mood = seed.mood
            let progress = CGFloat(index) / CGFloat(denominator)
            let drift = sin(time * 0.8 + Double(index) * 0.9) * 10
            let center = CGPoint(
                x: width * (0.12 + progress * 0.76),
                y: height * (0.28 + CGFloat(index % 3) * 0.18) + drift
            )
            let radius = min(width, height) * (0.13 + CGFloat(index % 2) * 0.035)

            context.fill(
                Path(ellipseIn: CGRect(
                    x: center.x - radius,
                    y: center.y - radius,
                    width: radius * 2,
                    height: radius * 2
                )),
                with: .color(mood.tint.opacity(0.08))
            )

            context.stroke(
                Path(ellipseIn: CGRect(
                    x: center.x - radius * 0.46,
                    y: center.y - radius * 0.46,
                    width: radius * 0.92,
                    height: radius * 0.92
                )),
                with: .color(mood.tint.opacity(0.10)),
                lineWidth: 1
            )

            drawLaneConsequence(
                seed.lane,
                mood: mood,
                in: &context,
                center: center,
                radius: radius,
                time: time
            )
        }
    }

    private func drawLaneConsequence(
        _ lane: GrowthLane,
        mood: Mood,
        in context: inout GraphicsContext,
        center: CGPoint,
        radius: CGFloat,
        time: TimeInterval
    ) {
        switch lane {
        case .now:
            for rootIndex in 0..<3 {
                var root = Path()
                let angle = CGFloat(rootIndex - 1) * 0.42
                root.move(to: CGPoint(x: center.x, y: center.y + radius * 0.25))
                root.addQuadCurve(
                    to: CGPoint(
                        x: center.x + sin(angle) * radius * 0.62,
                        y: center.y + radius * 0.74
                    ),
                    control: CGPoint(
                        x: center.x + sin(angle) * radius * 0.22,
                        y: center.y + radius * 0.52
                    )
                )
                context.stroke(
                    root,
                    with: .color(mood.tint.opacity(0.12)),
                    style: StrokeStyle(lineWidth: 1.4, lineCap: .round)
                )
            }
        case .later:
            let budRadius = radius * 0.13
            let budCenter = CGPoint(
                x: center.x + radius * 0.38,
                y: center.y - radius * 0.30 + sin(time + center.x) * 2
            )
            context.fill(
                Path(ellipseIn: CGRect(
                    x: budCenter.x - budRadius,
                    y: budCenter.y - budRadius,
                    width: budRadius * 2,
                    height: budRadius * 2.3
                )),
                with: .color(mood.tint.opacity(0.16))
            )
        case .release:
            for windIndex in 0..<2 {
                var wind = Path()
                let y = center.y - radius * (0.18 + CGFloat(windIndex) * 0.18)
                wind.move(to: CGPoint(x: center.x - radius * 0.48, y: y))
                wind.addCurve(
                    to: CGPoint(x: center.x + radius * 0.55, y: y + sin(time) * 3),
                    control1: CGPoint(x: center.x - radius * 0.12, y: y - 9),
                    control2: CGPoint(x: center.x + radius * 0.24, y: y + 9)
                )
                context.stroke(
                    wind,
                    with: .color(mood.tint.opacity(0.13)),
                    style: StrokeStyle(lineWidth: 1.2, lineCap: .round)
                )
            }
        }
    }
}

private struct GardenPayoffBannerView: View {
    let seed: GardenSeed
    let completedCount: Int
    let totalCount: Int

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var glow = false

    private var mood: Mood {
        seed.mood
    }

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                Circle()
                    .fill(mood.tint.opacity(glow ? 0.28 : 0.16))

                Image(systemName: mood.symbolName)
                    .font(.title3.bold())
                    .foregroundStyle(mood.tint)
                    .accessibilityHidden(true)
            }
            .frame(width: 48, height: 48)

            VStack(alignment: .leading, spacing: 4) {
                Text("Storm planted")
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)

                Text("\(mood.rawValue) became \(mood.plantAccessibilityName.lowercased()). \(seed.lane.gardenConsequenceTitle) changed the garden. \(completedCount)/\(totalCount) \(seedWord) growing this week.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .layoutPriority(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(mood.tint.opacity(0.10), in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(mood.tint.opacity(glow ? 0.42 : 0.22), lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Storm planted")
        .accessibilityValue("\(mood.rawValue) became \(mood.plantAccessibilityName.lowercased()). \(seed.lane.gardenConsequenceDetail) \(completedCount) of \(totalCount) \(seedWord) growing this week.")
        .onAppear {
            guard !reduceMotion else {
                glow = true
                return
            }

            withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                glow = true
            }
        }
    }

    private var seedWord: String {
        completedCount == 1 ? "seed is" : "seeds are"
    }
}

private struct EmotionGardenPlotView: View {
    let seed: GardenSeed?
    let evolutionStage: SeedEvolutionStage?
    let isSelected: Bool
    let isNewest: Bool
    let newestPlantIsGrown: Bool
    let onSelect: () -> Void

    @Environment(\.colorScheme) private var colorScheme
    @ScaledMetric(relativeTo: .body) private var plotMinWidth: CGFloat = 58
    @ScaledMetric(relativeTo: .body) private var plotMinHeight: CGFloat = 104
    @ScaledMetric(relativeTo: .body) private var plantFrameHeight: CGFloat = 78

    private var isGrown: Bool {
        seed != nil
    }

    private var mood: Mood? {
        seed?.mood
    }

    private var growthScale: CGFloat {
        isNewest && isGrown ? (newestPlantIsGrown ? 1 : 0.58) : 1
    }

    private var plantOpacity: Double {
        isNewest && isGrown ? (newestPlantIsGrown ? 1 : 0.2) : 1
    }

    var body: some View {
        Group {
            if isGrown {
                Button(action: onSelect) {
                    plotContent
                }
                .buttonStyle(.plain)
            } else {
                plotContent
            }
        }
    }

    private var plotContent: some View {
        VStack(spacing: 6) {
            ZStack(alignment: .bottom) {
                if let mood {
                    EmotionPlantView(mood: mood)
                        .scaleEffect(growthScale, anchor: .bottom)
                        .opacity(plantOpacity)

                    if let seed {
                        LaneConsequenceGlyphView(
                            lane: seed.lane,
                            tint: mood.tint
                        )
                        .offset(x: 18, y: -4)

                        if let evolutionStage {
                            SeedEvolutionGlyphView(
                                stage: evolutionStage,
                                tint: mood.tint
                            )
                            .offset(x: -18, y: -4)
                        }
                    }
                } else {
                    EmptyPlotSeedView()
                }
            }
            .frame(height: plantFrameHeight)

            RoundedRectangle(cornerRadius: 4)
                .fill(soilColor)
                .frame(height: 9)
        }
        .frame(minWidth: plotMinWidth, maxWidth: .infinity, minHeight: plotMinHeight)
        .padding(.vertical, 8)
        .background(backgroundColor, in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(borderColor, lineWidth: isSelected ? 2 : 1)
        }
        .accessibilityLabel(accessibilityLabel)
        .accessibilityValue(accessibilityValue)
        .accessibilityHint(accessibilityHint)
    }

    private var backgroundColor: Color {
        guard let mood else {
            return colorScheme == .dark ? Color.white.opacity(0.08) : Color.white.opacity(0.48)
        }

        return mood.tint.opacity(0.1)
    }

    private var borderColor: Color {
        guard let mood else {
            return Color.secondary.opacity(0.12)
        }

        return mood.tint.opacity(isSelected ? 0.72 : 0.24)
    }

    private var soilColor: Color {
        isGrown ? Color(red: 0.45, green: 0.31, blue: 0.19).opacity(0.24) : Color.gray.opacity(0.14)
    }

    private var accessibilityLabel: String {
        mood?.plantAccessibilityName ?? "Empty garden plot"
    }

    private var accessibilityValue: String {
        guard let mood else {
            return "Ready for a future check-in."
        }

        let newestPrefix = isNewest ? "Newest plant. " : ""
        let stageLine = evolutionStage.map { "\($0.title). \($0.detail)" } ?? ""
        return "\(newestPrefix)Represents \(mood.rawValue.lowercased()). \(stageLine)"
    }

    private var accessibilityHint: String {
        isGrown ? "Shows a private garden note for this plant." : "Completing a check-in grows a plant here."
    }
}

private struct GardenPlantDetailView: View {
    let seed: GardenSeed
    let isNewest: Bool
    let evolutionStage: SeedEvolutionStage

    private var mood: Mood {
        seed.mood
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(detailTitle, systemImage: mood.symbolName)
                .font(.subheadline.bold())
                .foregroundStyle(mood.tint)
                .fixedSize(horizontal: false, vertical: true)

            Text(seed.memoryTitle)
                .font(.caption.bold())
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Text(mood.gardenReflectionNote)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Text(mood.gardenRevisitPrompt)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

            Divider()

            Label(seed.lane.gardenConsequenceTitle, systemImage: seed.lane.symbolName)
                .font(.subheadline.bold())
                .foregroundStyle(mood.tint)
                .fixedSize(horizontal: false, vertical: true)

            Text(seed.lane.gardenConsequenceDetail)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Divider()

            Label("Seed memory", systemImage: "book.closed")
                .font(.subheadline.bold())
                .foregroundStyle(mood.tint)
                .fixedSize(horizontal: false, vertical: true)

            Text(seed.memoryDetail)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Text(seed.tinyActionMemory)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Text(seed.worldChangeSummary)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

            Divider()

            Label(evolutionStage.title, systemImage: evolutionStage.symbolName)
                .font(.subheadline.bold())
                .foregroundStyle(mood.tint)
                .fixedSize(horizontal: false, vertical: true)

            Text(evolutionStage.detail)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Text(seed.privateMemorySentence)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(mood.tint.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(mood.tint.opacity(0.22), lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(detailTitle)
        .accessibilityValue("\(mood.gardenReflectionNote) \(mood.gardenRevisitPrompt) \(seed.lane.gardenConsequenceDetail) \(evolutionStage.detail) \(seed.privateMemorySentence)")
    }

    private var detailTitle: String {
        isNewest ? "Newest \(mood.plantAccessibilityName)" : mood.plantAccessibilityName
    }
}

private struct SeedEvolutionGlyphView: View {
    let stage: SeedEvolutionStage
    let tint: Color

    var body: some View {
        Image(systemName: stage.symbolName)
            .font(.caption2.bold())
            .foregroundStyle(tint)
            .frame(width: 22, height: 22)
            .background(Color.white.opacity(0.82), in: Circle())
            .overlay {
                Circle()
                    .stroke(tint.opacity(0.34), lineWidth: 1)
            }
            .accessibilityHidden(true)
    }
}

private struct LaneConsequenceGlyphView: View {
    let lane: GrowthLane
    let tint: Color

    var body: some View {
        Image(systemName: lane.symbolName)
            .font(.caption2.bold())
            .foregroundStyle(.white)
            .frame(width: 22, height: 22)
            .background(tint.opacity(0.88), in: Circle())
            .overlay {
                Circle()
                    .stroke(Color.white.opacity(0.72), lineWidth: 1)
            }
            .accessibilityHidden(true)
    }
}

private struct EmotionPlantView: View {
    let mood: Mood

    var body: some View {
        ZStack(alignment: .bottom) {
            StemShape(lean: stemLean)
                .stroke(stemColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: 42, height: 58)
                .offset(y: -8)

            leaves

            flower
        }
        .frame(width: 58, height: 78)
        .accessibilityHidden(true)
    }

    @ViewBuilder
    private var leaves: some View {
        switch mood {
        case .calm:
            LeafPairView(color: .green, leftRotation: -34, rightRotation: 28, yOffset: -16)
        case .happy:
            LeafPairView(color: .green, leftRotation: -28, rightRotation: 26, yOffset: -12)
        case .tired:
            LeafPairView(color: .blue, leftRotation: -42, rightRotation: 36, yOffset: -10)
                .opacity(0.72)
        case .stressed:
            WindGrassLeavesView()
        case .unsure:
            LeafPairView(color: .purple, leftRotation: -24, rightRotation: 24, yOffset: -14)
                .opacity(0.78)
        }
    }

    @ViewBuilder
    private var flower: some View {
        switch mood {
        case .calm:
            CalmSproutView()
                .offset(y: -32)
        case .happy:
            SunBloomView()
                .offset(y: -34)
        case .tired:
            MoonBellView()
                .offset(y: -31)
        case .stressed:
            WindGrassView()
                .offset(y: -18)
        case .unsure:
            QuestionBudView()
                .offset(y: -32)
        }
    }

    private var stemColor: Color {
        switch mood {
        case .calm:
            Color.green.opacity(0.76)
        case .happy:
            Color.green.opacity(0.7)
        case .tired:
            Color.blue.opacity(0.58)
        case .stressed:
            Color.orange.opacity(0.72)
        case .unsure:
            Color.purple.opacity(0.62)
        }
    }

    private var stemLean: CGFloat {
        switch mood {
        case .calm:
            -0.05
        case .happy:
            0
        case .tired:
            -0.18
        case .stressed:
            0.22
        case .unsure:
            0.08
        }
    }
}

private struct EmptyPlotSeedView: View {
    var body: some View {
        VStack(spacing: 5) {
            Circle()
                .fill(Color.secondary.opacity(0.18))
                .frame(width: 12, height: 12)

            Capsule()
                .fill(Color.secondary.opacity(0.16))
                .frame(width: 20, height: 5)
        }
        .accessibilityHidden(true)
    }
}

private struct LeafPairView: View {
    let color: Color
    let leftRotation: Double
    let rightRotation: Double
    let yOffset: CGFloat

    var body: some View {
        ZStack {
            LeafShape()
                .fill(color.opacity(0.72).gradient)
                .frame(width: 16, height: 30)
                .rotationEffect(.degrees(leftRotation), anchor: .bottom)
                .offset(x: -9, y: yOffset)

            LeafShape()
                .fill(color.opacity(0.62).gradient)
                .frame(width: 15, height: 27)
                .rotationEffect(.degrees(rightRotation), anchor: .bottom)
                .offset(x: 9, y: yOffset + 3)
        }
    }
}

private struct CalmSproutView: View {
    var body: some View {
        ZStack {
            LeafShape()
                .fill(Color.mint.opacity(0.86).gradient)
                .frame(width: 19, height: 34)
                .rotationEffect(.degrees(-18), anchor: .bottom)
                .offset(x: -7)

            LeafShape()
                .fill(Color.green.opacity(0.82).gradient)
                .frame(width: 19, height: 34)
                .rotationEffect(.degrees(18), anchor: .bottom)
                .offset(x: 7)
        }
        .frame(width: 42, height: 42)
    }
}

private struct SunBloomView: View {
    var body: some View {
        ZStack {
            ForEach(0..<8, id: \.self) { index in
                PetalShape()
                    .fill(Color.yellow.opacity(0.86).gradient)
                    .frame(width: 11, height: 24)
                    .offset(y: -14)
                    .rotationEffect(.degrees(Double(index) * 45), anchor: .center)
            }

            Circle()
                .fill(Color.orange.opacity(0.88).gradient)
                .frame(width: 19, height: 19)
        }
        .frame(width: 48, height: 48)
    }
}

private struct MoonBellView: View {
    var body: some View {
        ZStack {
            BellShape()
                .fill(Color.blue.opacity(0.68).gradient)
                .frame(width: 32, height: 36)
                .rotationEffect(.degrees(-8))

            Circle()
                .fill(Color.white.opacity(0.7))
                .frame(width: 17, height: 17)
                .offset(x: 6, y: -5)
        }
        .frame(width: 42, height: 42)
    }
}

private struct WindGrassLeavesView: View {
    var body: some View {
        ZStack {
            WindBladeShape(lean: -0.36)
                .stroke(Color.orange.opacity(0.55), style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .frame(width: 30, height: 50)
                .offset(x: -8, y: -10)

            WindBladeShape(lean: 0.42)
                .stroke(Color.red.opacity(0.42), style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .frame(width: 30, height: 48)
                .offset(x: 8, y: -8)
        }
    }
}

private struct WindGrassView: View {
    var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { index in
                PetalShape()
                    .fill(Color.orange.opacity(0.74).gradient)
                    .frame(width: 9, height: 32)
                    .offset(y: -16)
                    .rotationEffect(.degrees(Double(index - 1) * 28), anchor: .bottom)
            }
        }
        .frame(width: 44, height: 50)
    }
}

private struct QuestionBudView: View {
    var body: some View {
        ZStack {
            BudShape()
                .fill(Color.purple.opacity(0.72).gradient)
                .frame(width: 31, height: 38)

            Circle()
                .stroke(Color.white.opacity(0.75), lineWidth: 2)
                .frame(width: 13, height: 13)
                .offset(y: -5)

            Circle()
                .fill(Color.white.opacity(0.82))
                .frame(width: 4, height: 4)
                .offset(y: 10)
        }
        .frame(width: 42, height: 46)
    }
}

private struct StemShape: Shape {
    let lean: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addQuadCurve(
            to: CGPoint(x: rect.midX + (lean * rect.width), y: rect.minY),
            control: CGPoint(x: rect.midX + (lean * rect.width * 0.35), y: rect.midY)
        )
        return path
    }
}

private struct LeafShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addQuadCurve(
            to: CGPoint(x: rect.midX, y: rect.minY),
            control: CGPoint(x: rect.minX, y: rect.midY)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.midX, y: rect.maxY),
            control: CGPoint(x: rect.maxX, y: rect.midY)
        )
        return path
    }
}

private struct PetalShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.midX, y: rect.maxY),
            control: CGPoint(x: rect.minX, y: rect.midY)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.midX, y: rect.minY),
            control: CGPoint(x: rect.maxX, y: rect.midY)
        )
        return path
    }
}

private struct BellShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.maxY * 0.72),
            control: CGPoint(x: rect.minX, y: rect.midY)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.midX, y: rect.maxY),
            control: CGPoint(x: rect.minX + rect.width * 0.2, y: rect.maxY)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.maxY * 0.72),
            control: CGPoint(x: rect.maxX - rect.width * 0.2, y: rect.maxY)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.midX, y: rect.minY),
            control: CGPoint(x: rect.maxX, y: rect.midY)
        )
        return path
    }
}

private struct BudShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.midY),
            control: CGPoint(x: rect.minX + rect.width * 0.12, y: rect.minY)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.midX, y: rect.maxY),
            control: CGPoint(x: rect.minX, y: rect.maxY * 0.82)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.midY),
            control: CGPoint(x: rect.maxX, y: rect.maxY * 0.82)
        )
        path.addQuadCurve(
            to: CGPoint(x: rect.midX, y: rect.minY),
            control: CGPoint(x: rect.maxX - rect.width * 0.12, y: rect.minY)
        )
        return path
    }
}

private struct WindBladeShape: Shape {
    let lean: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addCurve(
            to: CGPoint(x: rect.midX + (lean * rect.width), y: rect.minY),
            control1: CGPoint(x: rect.midX - (lean * rect.width * 0.6), y: rect.maxY * 0.68),
            control2: CGPoint(x: rect.midX + (lean * rect.width * 0.9), y: rect.maxY * 0.34)
        )
        return path
    }
}
