import SwiftUI

struct EmotionGardenView: View {
    let title: String
    let moods: [Mood]
    let totalPlots: Int
    let progressText: String
    let accessibilityValue: String

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var newestPlantIsGrown = true
    @State private var selectedPlotIndex: Int?

    private var safeTotalPlots: Int {
        max(totalPlots, 0)
    }

    private var visibleMoods: [Mood] {
        Array(moods.prefix(safeTotalPlots))
    }

    private var newestMoodIndex: Int? {
        visibleMoods.indices.last
    }

    private var newestMood: Mood? {
        visibleMoods.last
    }

    private var selectedMood: Mood? {
        guard
            let selectedPlotIndex,
            visibleMoods.indices.contains(selectedPlotIndex)
        else {
            return nil
        }

        return visibleMoods[selectedPlotIndex]
    }

    private var wrappedColumns: [GridItem] {
        [GridItem(.adaptive(minimum: dynamicTypeSize.isAccessibilitySize ? 82 : 66), spacing: 8)]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            header

            if let newestMood {
                GardenPayoffBannerView(
                    mood: newestMood,
                    completedCount: visibleMoods.count,
                    totalCount: safeTotalPlots
                )
            }

            plotLayout

            if let selectedMood {
                GardenPlantDetailView(
                    mood: selectedMood,
                    isNewest: selectedPlotIndex == newestMoodIndex
                )
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
        if selectedPlotIndex == nil || selectedMood == nil {
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
        EmotionGardenPlotView(
            mood: visibleMoods.indices.contains(index) ? visibleMoods[index] : nil,
            isSelected: selectedPlotIndex == index,
            isNewest: newestMoodIndex == index,
            newestPlantIsGrown: newestPlantIsGrown || reduceMotion
        ) {
            selectedPlotIndex = index
        }
    }
}

private struct GardenPayoffBannerView: View {
    let mood: Mood
    let completedCount: Int
    let totalCount: Int

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var glow = false

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

                Text("\(mood.rawValue) became \(mood.plantAccessibilityName.lowercased()). \(completedCount)/\(totalCount) \(seedWord) growing this week.")
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
        .accessibilityValue("\(mood.rawValue) became \(mood.plantAccessibilityName.lowercased()). \(completedCount) of \(totalCount) \(seedWord) growing this week.")
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
    let mood: Mood?
    let isSelected: Bool
    let isNewest: Bool
    let newestPlantIsGrown: Bool
    let onSelect: () -> Void

    @Environment(\.colorScheme) private var colorScheme
    @ScaledMetric(relativeTo: .body) private var plotMinWidth: CGFloat = 58
    @ScaledMetric(relativeTo: .body) private var plotMinHeight: CGFloat = 104
    @ScaledMetric(relativeTo: .body) private var plantFrameHeight: CGFloat = 78

    private var isGrown: Bool {
        mood != nil
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
        return "\(newestPrefix)Represents \(mood.rawValue.lowercased())."
    }

    private var accessibilityHint: String {
        isGrown ? "Shows a private garden note for this plant." : "Completing a check-in grows a plant here."
    }
}

private struct GardenPlantDetailView: View {
    let mood: Mood
    let isNewest: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(detailTitle, systemImage: mood.symbolName)
                .font(.subheadline.bold())
                .foregroundStyle(mood.tint)
                .fixedSize(horizontal: false, vertical: true)

            Text(mood.gardenReflectionNote)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Text(mood.gardenRevisitPrompt)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.primary)
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
        .accessibilityValue("\(mood.gardenReflectionNote) \(mood.gardenRevisitPrompt)")
    }

    private var detailTitle: String {
        isNewest ? "Newest \(mood.plantAccessibilityName)" : mood.plantAccessibilityName
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
