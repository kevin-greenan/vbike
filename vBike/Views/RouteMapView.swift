import CoreLocation
import MapKit
import SwiftUI

struct RouteMapView: View {
  let route: CyclingRoute
  let riderCoordinate: CLLocationCoordinate2D?

  private var cameraPosition: MapCameraPosition {
    guard let first = route.coordinates.first else {
      return .automatic
    }

    return .region(
      MKCoordinateRegion(
        center: first,
        span: MKCoordinateSpan(latitudeDelta: 0.09, longitudeDelta: 0.09)
      )
    )
  }

  var body: some View {
    Map(initialPosition: cameraPosition) {
      if route.coordinates.count > 1 {
        MapPolyline(coordinates: route.coordinates)
          .stroke(.green, lineWidth: 5)
      }

      if let riderCoordinate {
        Annotation("Rider", coordinate: riderCoordinate) {
          Image(systemName: "figure.indoor.cycle.circle.fill")
            .font(.title2)
            .symbolRenderingMode(.palette)
            .foregroundStyle(.white, .green)
            .shadow(radius: 4)
        }
      }
    }
    .mapStyle(.standard(elevation: .realistic))
  }
}
