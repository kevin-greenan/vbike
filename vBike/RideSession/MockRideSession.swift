import Foundation

final class MockRideSession: ObservableObject {
    @Published private(set) var state: RideSessionState = .idle
    @Published private(set) var telemetry: RideTelemetry = .zero
    @Published var selectedRoute: CyclingRoute = MockRoutes.routes[0]

    private let telemetryProvider: TelemetryProvider
    private let routeProgressEngine = RouteProgressEngine()

    init(telemetryProvider: TelemetryProvider = MockTelemetryProvider()) {
        self.telemetryProvider = telemetryProvider
        self.telemetryProvider.onTelemetryUpdate = { [weak self] telemetry in
            self?.telemetry = telemetry
        }
    }

    var progress: RouteProgress {
        routeProgressEngine.progress(for: selectedRoute, distanceMiles: telemetry.distance)
    }

    var upcomingCue: ResistanceCue? {
        selectedRoute.resistanceCues.first {
            $0.distance.converted(to: .miles).value >= telemetry.distance
        }
    }

    func start() {
        telemetryProvider.reset()
        state = .riding
        telemetryProvider.start()
    }

    func pause() {
        guard state == .riding else { return }
        state = .paused
        telemetryProvider.stop()
    }

    func resume() {
        guard state == .paused else { return }
        state = .riding
        telemetryProvider.start()
    }

    func stop() {
        state = .completed
        telemetryProvider.stop()
    }
}
