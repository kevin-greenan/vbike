import CoreLocation
import Foundation

enum MockRoutes {
  static let routes: [CyclingRoute] = [
    CyclingRoute(
      name: "Chicago Lakefront Preview",
      totalDistance: Measurement(value: 18.4, unit: .miles),
      coordinates: [
        CLLocationCoordinate2D(latitude: 41.8807, longitude: -87.6233),
        CLLocationCoordinate2D(latitude: 41.8921, longitude: -87.6090),
        CLLocationCoordinate2D(latitude: 41.9117, longitude: -87.6268),
        CLLocationCoordinate2D(latitude: 41.9417, longitude: -87.6367),
        CLLocationCoordinate2D(latitude: 41.9697, longitude: -87.6501),
      ],
      elevationSamples: [
        ElevationSample(
          distance: Measurement(value: 0, unit: .miles),
          elevation: Measurement(value: 594, unit: .feet)),
        ElevationSample(
          distance: Measurement(value: 4, unit: .miles),
          elevation: Measurement(value: 601, unit: .feet)),
        ElevationSample(
          distance: Measurement(value: 9, unit: .miles),
          elevation: Measurement(value: 587, unit: .feet)),
        ElevationSample(
          distance: Measurement(value: 14, unit: .miles),
          elevation: Measurement(value: 610, unit: .feet)),
        ElevationSample(
          distance: Measurement(value: 18.4, unit: .miles),
          elevation: Measurement(value: 596, unit: .feet)),
      ],
      resistanceCues: [
        ResistanceCue(
          distance: Measurement(value: 0.5, unit: .miles), targetResistance: 28, grade: 0.2),
        ResistanceCue(
          distance: Measurement(value: 4.0, unit: .miles), targetResistance: 34, grade: 1.1),
        ResistanceCue(
          distance: Measurement(value: 9.2, unit: .miles), targetResistance: 24, grade: -0.8),
        ResistanceCue(
          distance: Measurement(value: 14.8, unit: .miles), targetResistance: 41, grade: 2.4),
      ]
    ),
    CyclingRoute(
      name: "Seattle Waterfront Climb",
      totalDistance: Measurement(value: 12.6, unit: .miles),
      coordinates: [
        CLLocationCoordinate2D(latitude: 47.6062, longitude: -122.3401),
        CLLocationCoordinate2D(latitude: 47.6178, longitude: -122.3553),
        CLLocationCoordinate2D(latitude: 47.6295, longitude: -122.3599),
        CLLocationCoordinate2D(latitude: 47.6414, longitude: -122.3493),
        CLLocationCoordinate2D(latitude: 47.6510, longitude: -122.3295),
      ],
      elevationSamples: [
        ElevationSample(
          distance: Measurement(value: 0, unit: .miles),
          elevation: Measurement(value: 18, unit: .feet)),
        ElevationSample(
          distance: Measurement(value: 3, unit: .miles),
          elevation: Measurement(value: 72, unit: .feet)),
        ElevationSample(
          distance: Measurement(value: 6, unit: .miles),
          elevation: Measurement(value: 148, unit: .feet)),
        ElevationSample(
          distance: Measurement(value: 9, unit: .miles),
          elevation: Measurement(value: 82, unit: .feet)),
        ElevationSample(
          distance: Measurement(value: 12.6, unit: .miles),
          elevation: Measurement(value: 36, unit: .feet)),
      ],
      resistanceCues: [
        ResistanceCue(
          distance: Measurement(value: 1.0, unit: .miles), targetResistance: 30, grade: 0.7),
        ResistanceCue(
          distance: Measurement(value: 3.4, unit: .miles), targetResistance: 44, grade: 3.1),
        ResistanceCue(
          distance: Measurement(value: 7.5, unit: .miles), targetResistance: 38, grade: 1.8),
        ResistanceCue(
          distance: Measurement(value: 10.2, unit: .miles), targetResistance: 25, grade: -1.2),
      ]
    ),
  ]
}
