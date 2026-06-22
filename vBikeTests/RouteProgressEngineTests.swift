import CoreLocation
import XCTest

@testable import vBike

final class RouteProgressEngineTests: XCTestCase {
  func testProgressClampsAtRouteCompletion() {
    let route = CyclingRoute(
      name: "Test Route",
      totalDistance: Measurement(value: 10, unit: .miles),
      coordinates: [
        CLLocationCoordinate2D(latitude: 41.0, longitude: -87.0),
        CLLocationCoordinate2D(latitude: 42.0, longitude: -88.0),
      ],
      elevationSamples: [],
      resistanceCues: []
    )

    let progress = RouteProgressEngine().progress(
      for: route,
      distanceMiles: 12,
      speedMilesPerHour: 18
    )

    XCTAssertEqual(progress.completedFraction, 1)
    XCTAssertEqual(progress.remainingDistance.converted(to: .miles).value, 0)
    XCTAssertTrue(progress.isComplete)
  }

  func testProgressInterpolatesRiderCoordinateAndETA() {
    let route = CyclingRoute(
      name: "Test Route",
      totalDistance: Measurement(value: 10, unit: .miles),
      coordinates: [
        CLLocationCoordinate2D(latitude: 40.0, longitude: -80.0),
        CLLocationCoordinate2D(latitude: 42.0, longitude: -82.0),
      ],
      elevationSamples: [],
      resistanceCues: []
    )

    let progress = RouteProgressEngine().progress(
      for: route,
      distanceMiles: 5,
      speedMilesPerHour: 20
    )

    XCTAssertEqual(progress.completedFraction, 0.5)
    XCTAssertEqual(progress.riderCoordinate?.latitude ?? 0, 41.0, accuracy: 0.0001)
    XCTAssertEqual(progress.riderCoordinate?.longitude ?? 0, -81.0, accuracy: 0.0001)
    XCTAssertEqual(progress.estimatedRemainingTime ?? 0, 900, accuracy: 0.1)
  }
}
