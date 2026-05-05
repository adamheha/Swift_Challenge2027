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
                encouragement: checkInState.bloomEncouragement
            )
            .bloomPanel(padding: 22)

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

            Text("\(completedCount) of 7 check-ins complete")
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
