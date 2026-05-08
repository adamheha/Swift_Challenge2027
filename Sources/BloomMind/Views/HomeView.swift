import SwiftUI

struct HomeView: View {
    @Binding var checkInState: CheckInState
    let onStartCheckIn: () -> Void

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    private var pageSpacing: CGFloat {
        dynamicTypeSize.isAccessibilitySize ? 22 : 24
    }

    private var latestMood: Mood? {
        checkInState.gardenMoodsThisWeek.last
    }

    var body: some View {
        VStack(spacing: pageSpacing) {
            StormToBloomHeroView(
                isCompleteToday: checkInState.hasCompletedCheckInToday(),
                latestMood: latestMood,
                progressPercent: checkInState.bloomProgressPercent,
                completedCount: checkInState.completedCheckInsThisWeek,
                goalCount: CheckInState.weeklyCheckInGoal,
                prompt: checkInState.todayPrompt
            )

            EmotionGardenView(
                title: CheckInState.gardenPreviewTitle,
                moods: checkInState.gardenMoodsThisWeek,
                totalPlots: CheckInState.weeklyCheckInGoal,
                progressText: checkInState.gardenProgressText,
                accessibilityValue: checkInState.gardenAccessibilityValue
            )

            TodayStatusView(
                isComplete: checkInState.hasCompletedCheckInToday(),
                title: checkInState.todayStatusTitle,
                detail: checkInState.todayStatusDetail
            )

            Button(action: onStartCheckIn) {
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

            Button {
                withAnimation(.spring(response: 0.42, dampingFraction: 0.82)) {
                    checkInState.replayDemoWeek()
                }
            } label: {
                Label(CheckInState.replayWeekActionTitle, systemImage: "play.circle")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .accessibilityHint(CheckInState.replayWeekActionAccessibilityHint)
        }
        .bloomPage(maxWidth: 520, padding: 32)
        .navigationTitle("Today")
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
        }
    }
}
