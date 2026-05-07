import SwiftUI

struct HomeView: View {
    @Binding var checkInState: CheckInState
    let onStartCheckIn: () -> Void

    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @ScaledMetric(relativeTo: .largeTitle) private var heroIconSize: CGFloat = 58

    private var pageSpacing: CGFloat {
        dynamicTypeSize.isAccessibilitySize ? 22 : 28
    }

    var body: some View {
        VStack(spacing: pageSpacing) {
            VStack(spacing: 10) {
                Image(systemName: "camera.macro")
                    .font(.system(size: min(heroIconSize, 74), weight: .regular))
                    .foregroundStyle(.green.gradient)
                    .accessibilityHidden(true)

                Text("BloomMind")
                    .font(.largeTitle.bold())
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Text(checkInState.todayPrompt)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            BloomProgressView(
                progress: checkInState.bloomProgress,
                percent: checkInState.bloomProgressPercent,
                completedCount: checkInState.completedCheckInsThisWeek,
                goalCount: CheckInState.weeklyCheckInGoal,
                accessibilityValue: checkInState.weeklyProgressAccessibilityValue,
                encouragement: checkInState.bloomEncouragement
            )
            .bloomPanel(padding: 22)

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

private struct BloomProgressView: View {
    let progress: Double
    let percent: Int
    let completedCount: Int
    let goalCount: Int
    let accessibilityValue: String
    let encouragement: String

    @ScaledMetric(relativeTo: .title) private var ringSize: CGFloat = 190
    @ScaledMetric(relativeTo: .body) private var ringLineWidth: CGFloat = 18

    private var displayedRingSize: CGFloat {
        min(ringSize, 230)
    }

    private var displayedRingLineWidth: CGFloat {
        min(ringLineWidth, 24)
    }

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .stroke(.green.opacity(0.16), lineWidth: displayedRingLineWidth)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(.green.gradient, style: StrokeStyle(lineWidth: displayedRingLineWidth, lineCap: .round))
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 4) {
                    Text("\(percent)%")
                        .font(.title.bold())
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                    Text("weekly bloom")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                }
            }
            .frame(width: displayedRingSize, height: displayedRingSize)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Weekly bloom progress")
            .accessibilityValue(accessibilityValue)
            .accessibilityHint("Updates after each completed local check-in.")

            Text("\(completedCount) of \(goalCount) check-ins complete")
                .font(.headline)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            Text(encouragement)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
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
