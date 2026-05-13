import SwiftUI

struct HomeView: View {
    @Binding var checkInState: CheckInState
    let onStartCheckIn: () -> Void

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @State private var isPreviewingDemoWeek = false

    private var pageSpacing: CGFloat {
        dynamicTypeSize.isAccessibilitySize ? 22 : 24
    }

    private var latestMood: Mood? {
        checkInState.gardenMoodsThisWeek.last
    }

    private var gardenDisplayState: CheckInState {
        isPreviewingDemoWeek ? checkInState.demoWeekPreviewState() : checkInState
    }

    var body: some View {
        ViewThatFits(in: .horizontal) {
            wideLayout
            compactLayout
        }
        .bloomPage(maxWidth: 980, padding: 32)
        .navigationTitle("Today")
        .onChange(of: checkInState.completedCheckIns) { _, _ in
            isPreviewingDemoWeek = false
        }
        .onChange(of: checkInState.gardenMoods) { _, _ in
            isPreviewingDemoWeek = false
        }
        .onChange(of: checkInState.gardenSeeds) { _, _ in
            isPreviewingDemoWeek = false
        }
    }

    private var wideLayout: some View {
        HStack(alignment: .top, spacing: 24) {
            VStack(spacing: pageSpacing) {
                heroSection
                dailyActionSection
            }
            .frame(minWidth: 360, maxWidth: 450)

            VStack(spacing: pageSpacing) {
                gardenSection
            }
            .frame(minWidth: 420, maxWidth: 520)
        }
    }

    private var compactLayout: some View {
        VStack(spacing: pageSpacing) {
            heroSection
            gardenSection
            dailyActionSection
        }
    }

    private var heroSection: some View {
        StormToBloomHeroView(
            isCompleteToday: checkInState.hasCompletedCheckInToday(),
            latestMood: latestMood,
            progressPercent: checkInState.bloomProgressPercent,
            completedCount: checkInState.completedCheckInsThisWeek,
            goalCount: CheckInState.weeklyCheckInGoal,
            prompt: checkInState.todayPrompt
        )
    }

    private var gardenSection: some View {
        VStack(spacing: pageSpacing) {
            EmotionGardenView(
                title: CheckInState.gardenPreviewTitle,
                seeds: gardenDisplayState.gardenSeedsThisWeek,
                totalPlots: CheckInState.weeklyCheckInGoal,
                progressText: gardenDisplayState.gardenProgressText,
                accessibilityValue: gardenDisplayState.gardenAccessibilityValue
            )

            if gardenDisplayState.isWeeklyBloomUnlocked {
                WeeklyBloomPayoffView(
                    payoff: gardenDisplayState.weeklyBloomPayoff,
                    seeds: gardenDisplayState.gardenSeedsThisWeek
                )
            }

            WeekReviewCardView(review: gardenDisplayState.weeklyReview)
        }
    }

    private var dailyActionSection: some View {
        VStack(spacing: pageSpacing) {
            TodayStatusView(
                isComplete: checkInState.hasCompletedCheckInToday(),
                title: checkInState.todayStatusTitle,
                detail: checkInState.todayStatusDetail
            )

            OriginLineView()

            if !gardenDisplayState.gardenSeedsThisWeek.isEmpty {
                TomorrowSeedCardView(
                    prompt: gardenDisplayState.returnTomorrowPrompt,
                    tint: gardenDisplayState.gardenSeedsThisWeek.last?.mood.tint ?? .green
                )
            }

            if isPreviewingDemoWeek {
                DemoPreviewNoticeView()
            }

            primaryActionButton
            demoWeekButton
        }
    }

    private var primaryActionButton: some View {
        Button {
            isPreviewingDemoWeek = false
            onStartCheckIn()
        } label: {
            Label(
                checkInState.primaryActionTitle,
                systemImage: "sparkles"
            )
                .font(.headline)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .accessibilityHint(checkInState.primaryActionAccessibilityHint)
    }

    private var demoWeekButton: some View {
        Button {
            withAnimation(.spring(response: 0.42, dampingFraction: 0.82)) {
                isPreviewingDemoWeek.toggle()
            }
        } label: {
            Label(
                isPreviewingDemoWeek ? CheckInState.showMyWeekActionTitle : CheckInState.previewDemoWeekActionTitle,
                systemImage: isPreviewingDemoWeek ? "person.crop.circle" : "play.circle"
            )
                .font(.headline)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
        .controlSize(.large)
        .accessibilityHint(
            isPreviewingDemoWeek
                ? CheckInState.showMyWeekActionAccessibilityHint
                : CheckInState.previewDemoWeekActionAccessibilityHint
        )
    }
}

private struct DemoPreviewNoticeView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "eye")
                .font(.title3)
                .foregroundStyle(.blue)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 3) {
                Text(CheckInState.demoWeekPreviewTitle)
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)

                Text("\(CheckInState.demoWeekPreviewDetail) This guided award demo shows storm, sorting, living garden, time-lapse, and Weekly Bloom in one path.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding(14)
        .bloomCardBackground(tint: .blue)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(CheckInState.demoWeekPreviewTitle)
        .accessibilityValue("\(CheckInState.demoWeekPreviewDetail) This guided award demo shows the complete BloomMind story.")
    }
}

private struct OriginLineView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "quote.opening")
                .font(.subheadline.bold())
                .foregroundStyle(.green)
                .frame(width: 22)
                .accessibilityHidden(true)

            Text(CheckInState.originLine)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .layoutPriority(1)
        }
        .padding(12)
        .bloomCardBackground(tint: .green)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("BloomMind origin")
        .accessibilityValue(CheckInState.originLine)
    }
}

private struct TomorrowSeedCardView: View {
    let prompt: String
    let tint: Color

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "calendar.badge.clock")
                .font(.subheadline.bold())
                .foregroundStyle(tint)
                .frame(width: 22)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text("Tomorrow's tiny seed")
                    .font(.subheadline.bold())
                    .fixedSize(horizontal: false, vertical: true)

                Text(prompt)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .layoutPriority(1)
        }
        .padding(12)
        .bloomCardBackground(tint: tint)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Tomorrow's tiny seed")
        .accessibilityValue(prompt)
    }
}

private struct WeekReviewCardView: View {
    let review: GardenWeekReview

    private var accentColor: Color {
        review.accentMood?.tint ?? .green
    }

    private var iconName: String {
        review.accentMood?.symbolName ?? "sparkles"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: iconName)
                    .font(.title3.bold())
                    .foregroundStyle(accentColor)
                    .frame(width: 28, height: 28)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 4) {
                    Text(review.title)
                        .font(.headline)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(review.detail)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .layoutPriority(1)

                Spacer(minLength: 0)
            }

            ProgressView(
                value: Double(review.completedCount),
                total: Double(max(review.totalCount, 1))
            )
            .tint(accentColor)
            .accessibilityHidden(true)
        }
        .padding(14)
        .bloomCardBackground(tint: accentColor)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(review.title)
        .accessibilityValue(review.accessibilityValue)
    }
}

private struct TodayStatusView: View {
    let isComplete: Bool
    let title: String
    let detail: String

    @ScaledMetric(relativeTo: .title3) private var iconSize: CGFloat = 22

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: isComplete ? "checkmark.circle.fill" : "lock.shield")
                .font(.system(size: iconSize, weight: .regular))
                .foregroundStyle(isComplete ? .green : .blue)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                    .fixedSize(horizontal: false, vertical: true)
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .layoutPriority(1)

            Spacer()
        }
        .padding(14)
        .bloomCardBackground(tint: isComplete ? .green : .blue)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(title)
        .accessibilityValue(detail)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationStack {
                HomeView(
                    checkInState: .constant(CheckInState()),
                    onStartCheckIn: {}
                )
            }
            .previewDisplayName("Home - Fresh")

            NavigationStack {
                HomeView(
                    checkInState: .constant(
                        CheckInState(
                            completedCheckIns: 3,
                            lastCompletedAt: Date()
                        )
                    ),
                    onStartCheckIn: {}
                )
            }
            .previewDisplayName("Home - Completed Today")

            NavigationStack {
                HomeView(
                    checkInState: .constant(
                        CheckInState(completedCheckIns: CheckInState.weeklyCheckInGoal)
                    ),
                    onStartCheckIn: {}
                )
            }
            .previewDisplayName("Home - Full Garden")

            NavigationStack {
                HomeView(
                    checkInState: .constant(HomeViewPreviewState.fullReview),
                    onStartCheckIn: {}
                )
            }
            .previewLayout(.fixed(width: 1024, height: 768))
            .previewDisplayName("Home - iPad Review")
        }
    }
}

private enum HomeViewPreviewState {
    static var fullReview: CheckInState {
        CheckInState().demoWeekPreviewState()
    }
}
