import SwiftUI

struct HomeView: View {
    @Binding var checkInState: CheckInState
    let onStartCheckIn: () -> Void

    var body: some View {
        VStack(spacing: 28) {
            VStack(spacing: 10) {
                Image(systemName: "camera.macro")
                    .font(.system(size: 58, weight: .regular))
                    .foregroundStyle(.green.gradient)
                    .accessibilityHidden(true)

                Text("BloomMind")
                    .font(.largeTitle.bold())

                Text(checkInState.todayPrompt)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }

            BloomProgressView(
                progress: checkInState.bloomProgress,
                percent: checkInState.bloomProgressPercent,
                completedCount: checkInState.completedCheckInsThisWeek,
                goalCount: CheckInState.weeklyCheckInGoal,
                encouragement: checkInState.bloomEncouragement
            )
            .bloomPanel(padding: 22)

            GardenPreviewView(
                completedCount: checkInState.completedCheckInsThisWeek,
                totalPlots: CheckInState.weeklyCheckInGoal
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
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .bloomPage(maxWidth: 520, padding: 32)
        .navigationTitle("Today")
    }
}

private struct GardenPreviewView: View {
    let completedCount: Int
    let totalPlots: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Label("Garden preview", systemImage: "leaf")
                    .font(.headline)

                Spacer()

                Text("\(completedCount)/\(totalPlots)")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 8) {
                ForEach(0..<totalPlots, id: \.self) { index in
                    GardenPlotView(isGrown: index < completedCount)
                }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Garden preview")
            .accessibilityValue("\(completedCount) of \(totalPlots) plants grown")
        }
        .bloomPanel(padding: 16)
    }
}

private struct GardenPlotView: View {
    let isGrown: Bool

    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: isGrown ? "leaf.fill" : "circle")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(isGrown ? Color.green : Color.secondary.opacity(0.45))
                .frame(height: 22)
                .accessibilityHidden(true)

            RoundedRectangle(cornerRadius: 4)
                .fill(isGrown ? Color.green.opacity(0.22) : Color.gray.opacity(0.14))
                .frame(height: 8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(
            isGrown ? Color.green.opacity(0.09) : Color.white.opacity(0.55),
            in: RoundedRectangle(cornerRadius: 8)
        )
    }
}

private struct TodayStatusView: View {
    let isComplete: Bool
    let title: String
    let detail: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: isComplete ? "checkmark.circle.fill" : "lock.shield")
                .font(.title3)
                .foregroundStyle(isComplete ? .green : .blue)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(14)
        .background(.white.opacity(0.7), in: RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke((isComplete ? Color.green : Color.blue).opacity(0.28), lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
    }
}

private struct BloomProgressView: View {
    let progress: Double
    let percent: Int
    let completedCount: Int
    let goalCount: Int
    let encouragement: String

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .stroke(.green.opacity(0.16), lineWidth: 18)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(.green.gradient, style: StrokeStyle(lineWidth: 18, lineCap: .round))
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 4) {
                    Text("\(percent)%")
                        .font(.title.bold())
                    Text("weekly bloom")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 190, height: 190)
            .accessibilityLabel("Weekly bloom progress")
            .accessibilityValue("\(percent) percent")

            Text("\(completedCount) of \(goalCount) check-ins complete")
                .font(.headline)

            Text(encouragement)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
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
    }
}
