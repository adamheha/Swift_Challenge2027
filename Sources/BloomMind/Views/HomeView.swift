import SwiftUI

struct HomeView: View {
    @Binding var checkInState: CheckInState
    let onStartCheckIn: () -> Void

    var body: some View {
        VStack(spacing: 28) {
            VStack(spacing: 10) {
                Image(systemName: "camera.macro")
                    .font(.system(size: 58, weight: .regular))
                    .foregroundStyle(.green)
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
                .padding(.vertical, 8)

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
        .padding(32)
        .frame(maxWidth: 520)
        .navigationTitle("Today")
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
                    .stroke(.green.opacity(0.18), lineWidth: 18)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(.green, style: StrokeStyle(lineWidth: 18, lineCap: .round))
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
