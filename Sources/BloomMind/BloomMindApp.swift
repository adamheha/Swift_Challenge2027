import SwiftUI

private enum CheckInRoute: Hashable {
    case checkIn
    case growthAction
}

@main
struct BloomMindApp: App {
    @State private var checkInState = CheckInState()
    @State private var checkInPath: [CheckInRoute] = []
    @State private var hasSeenOriginScene = false
    @State private var shouldStartDemoDirector = false

    var body: some Scene {
        WindowGroup {
            Group {
                if hasSeenOriginScene {
                    NavigationStack(path: $checkInPath) {
                        HomeView(
                            checkInState: $checkInState,
                            shouldStartDemoDirector: $shouldStartDemoDirector,
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
                } else {
                    OriginJourneyView(
                        onBeginJourney: {
                            withAnimation(.spring(response: 0.55, dampingFraction: 0.86)) {
                                shouldStartDemoDirector = false
                                hasSeenOriginScene = true
                            }
                        },
                        onStartDemo: {
                            withAnimation(.spring(response: 0.55, dampingFraction: 0.86)) {
                                shouldStartDemoDirector = true
                                hasSeenOriginScene = true
                            }
                        }
                    )
                }
            }
            .frame(
                minWidth: 700,
                idealWidth: 980,
                minHeight: 620,
                idealHeight: 760
            )
        }
    }
}
