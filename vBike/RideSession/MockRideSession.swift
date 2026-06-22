import Foundation

final class MockRideSession: ObservableObject {
  @Published private(set) var state: RideSessionState = .idle
  @Published private(set) var telemetry: RideTelemetry = .zero
  @Published private(set) var completedSummary: RideSummary?
  @Published private(set) var rideHistory: [RideSummary]
  @Published var selectedRoute: CyclingRoute {
    didSet {
      if state == .idle || state == .completed {
        completedSummary = nil
      }
    }
  }

  private let telemetryProvider: TelemetryProvider
  private let rideHistoryStore: RideHistoryStore
  private let routeProgressEngine = RouteProgressEngine()
  let courseLibrary: CourseLibrary

  init(
    telemetryProvider: TelemetryProvider = MockTelemetryProvider(),
    courseLibrary: CourseLibrary = .mock,
    rideHistoryStore: RideHistoryStore = UserDefaultsRideHistoryStore()
  ) {
    self.telemetryProvider = telemetryProvider
    self.courseLibrary = courseLibrary
    self.rideHistoryStore = rideHistoryStore
    rideHistory = rideHistoryStore.summaries
    selectedRoute = courseLibrary.defaultRoute
    self.telemetryProvider.onTelemetryUpdate = { [weak self] telemetry in
      self?.telemetry = telemetry
      if self?.progress.isComplete == true {
        self?.completeRide()
      }
    }
  }

  var progress: RouteProgress {
    routeProgressEngine.progress(
      for: selectedRoute,
      distanceMiles: telemetry.distance,
      speedMilesPerHour: telemetry.speed
    )
  }

  var upcomingCue: ResistanceCue? {
    selectedRoute.resistanceCues.first {
      $0.distance.converted(to: .miles).value >= telemetry.distance
    }
  }

  func start() {
    telemetryProvider.reset()
    completedSummary = nil
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
    completeRide()
  }

  func selectRoute(_ route: CyclingRoute) {
    guard state == .idle || state == .completed else { return }
    selectedRoute = route
  }

  func clearRideHistory() {
    rideHistoryStore.clear()
    rideHistory = []
    completedSummary = nil
  }

  private func completeRide() {
    guard state != .completed else { return }
    telemetryProvider.stop()
    let summary = RideSummary(
      routeName: selectedRoute.name,
      elapsedTime: telemetry.elapsedTime,
      distance: telemetry.distance,
      averagePower: telemetry.averagePower,
      estimatedCalories: telemetry.estimatedCalories,
      completedFraction: progress.completedFraction
    )
    rideHistoryStore.save(summary)
    rideHistory = rideHistoryStore.summaries
    completedSummary = summary
    state = .completed
  }
}
