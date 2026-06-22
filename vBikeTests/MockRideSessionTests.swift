import XCTest

@testable import vBike

final class MockRideSessionTests: XCTestCase {
  func testStartPauseResumeStopCreatesRideSummary() {
    let telemetryProvider = TestTelemetryProvider()
    let historyStore = InMemoryRideHistoryStore()
    let session = MockRideSession(
      telemetryProvider: telemetryProvider,
      rideHistoryStore: historyStore
    )

    session.start()
    XCTAssertEqual(session.state, .riding)

    telemetryProvider.emit(
      RideTelemetry(
        currentPower: 180,
        averagePower: 170,
        cadence: 88,
        speed: 18,
        elapsedTime: 120,
        distance: 1,
        targetResistance: 35,
        estimatedCalories: 18
      )
    )

    session.pause()
    XCTAssertEqual(session.state, .paused)

    session.resume()
    XCTAssertEqual(session.state, .riding)

    session.stop()
    XCTAssertEqual(session.state, .completed)
    XCTAssertEqual(session.completedSummary?.averagePower, 170)
    XCTAssertEqual(session.rideHistory.count, 1)
  }

  func testCannotSelectRouteDuringActiveRide() {
    let session = MockRideSession(
      telemetryProvider: TestTelemetryProvider(),
      courseLibrary: .mock,
      rideHistoryStore: InMemoryRideHistoryStore()
    )
    let originalRoute = session.selectedRoute
    let nextRoute = MockRoutes.routes[1]

    session.start()
    session.selectRoute(nextRoute)

    XCTAssertEqual(session.selectedRoute.id, originalRoute.id)
  }
}

private final class TestTelemetryProvider: TelemetryProvider {
  private(set) var latestTelemetry: RideTelemetry = .zero
  var onTelemetryUpdate: ((RideTelemetry) -> Void)?

  func reset() {
    latestTelemetry = .zero
    onTelemetryUpdate?(latestTelemetry)
  }

  func start() {}

  func stop() {}

  func emit(_ telemetry: RideTelemetry) {
    latestTelemetry = telemetry
    onTelemetryUpdate?(telemetry)
  }
}

private final class InMemoryRideHistoryStore: RideHistoryStore {
  private(set) var summaries: [RideSummary] = []

  func save(_ summary: RideSummary) {
    summaries.insert(summary, at: 0)
  }

  func clear() {
    summaries = []
  }
}
