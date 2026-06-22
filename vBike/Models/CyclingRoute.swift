import CoreLocation
import Foundation

struct CyclingRoute: Identifiable, Hashable {
  let id: UUID
  let name: String
  let totalDistance: Measurement<UnitLength>
  let coordinates: [CLLocationCoordinate2D]
  let elevationSamples: [ElevationSample]
  let resistanceCues: [ResistanceCue]

  init(
    id: UUID = UUID(),
    name: String,
    totalDistance: Measurement<UnitLength>,
    coordinates: [CLLocationCoordinate2D],
    elevationSamples: [ElevationSample],
    resistanceCues: [ResistanceCue]
  ) {
    self.id = id
    self.name = name
    self.totalDistance = totalDistance
    self.coordinates = coordinates
    self.elevationSamples = elevationSamples
    self.resistanceCues = resistanceCues
  }

  static func == (lhs: CyclingRoute, rhs: CyclingRoute) -> Bool {
    lhs.id == rhs.id
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
}

struct ElevationSample: Identifiable, Hashable {
  let id = UUID()
  let distance: Measurement<UnitLength>
  let elevation: Measurement<UnitLength>
}

struct ResistanceCue: Identifiable, Hashable {
  let id = UUID()
  let distance: Measurement<UnitLength>
  let targetResistance: Int
  let grade: Double
}
