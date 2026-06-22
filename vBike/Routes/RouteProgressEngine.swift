import CoreLocation
import Foundation

struct RouteProgress {
    let completedFraction: Double
    let remainingDistance: Measurement<UnitLength>
    let riderCoordinate: CLLocationCoordinate2D?
}

struct RouteProgressEngine {
    func progress(for route: CyclingRoute, distanceMiles: Double) -> RouteProgress {
        let totalMiles = route.totalDistance.converted(to: .miles).value
        let fraction = min(max(distanceMiles / totalMiles, 0), 1)
        let coordinate = coordinate(on: route.coordinates, fraction: fraction)

        return RouteProgress(
            completedFraction: fraction,
            remainingDistance: Measurement(value: max(totalMiles - distanceMiles, 0), unit: .miles),
            riderCoordinate: coordinate
        )
    }

    private func coordinate(on coordinates: [CLLocationCoordinate2D], fraction: Double) -> CLLocationCoordinate2D? {
        guard !coordinates.isEmpty else { return nil }
        guard coordinates.count > 1 else { return coordinates[0] }

        let scaledIndex = fraction * Double(coordinates.count - 1)
        let lowerIndex = Int(floor(scaledIndex))
        let upperIndex = min(lowerIndex + 1, coordinates.count - 1)
        let interpolation = scaledIndex - Double(lowerIndex)

        let lower = coordinates[lowerIndex]
        let upper = coordinates[upperIndex]

        return CLLocationCoordinate2D(
            latitude: lower.latitude + ((upper.latitude - lower.latitude) * interpolation),
            longitude: lower.longitude + ((upper.longitude - lower.longitude) * interpolation)
        )
    }
}
