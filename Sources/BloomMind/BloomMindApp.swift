import SwiftUI

private enum CheckInRoute: Hashable {
    case checkIn
    case growthAction
}

@main
struct BloomMindApp: App {
    @State private var checkInState = CheckInState()
    @State private var checkInPath: [CheckInRoute] = []

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $checkInPath) {
                HomeView(
                    checkInState: $checkInState,
                    onStartCheckIn: {
                        checkInPath = [.checkIn]
                    }
                )
                .navigationDestination(for: CheckInRoute.self) { route in
                    switch route {
                    case .checkIn:
                        CheckInView(
                            checkInState: $checkInState,
                            onContinue: {
                                checkInPath.append(.growthAction)
                            }
                        )
                    case .growthAction:
                        GrowthActionView(
                            checkInState: $checkInState,
                            onComplete: {
                                checkInPath.removeAll()
                            }
                        )
                    }
                }
            }
            .frame(minWidth: 420, minHeight: 620)
            .preferredColorScheme(.light)
        }
    }
}
