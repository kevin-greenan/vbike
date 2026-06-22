import SwiftUI

struct CourseSelectionView: View {
  @EnvironmentObject private var rideSession: MockRideSession

  var body: some View {
    List {
      if rideSession.state == .riding || rideSession.state == .paused {
        Section {
          Label(
            "Finish or stop the active ride before switching courses.", systemImage: "lock.fill"
          )
          .foregroundStyle(.secondary)
        }
      }

      Section("Featured") {
        ForEach(rideSession.courseLibrary.featuredRoutes) { route in
          courseButton(for: route)
        }
      }
    }
    .navigationTitle("Courses")
  }

  private func courseButton(for route: CyclingRoute) -> some View {
    Button {
      rideSession.selectRoute(route)
    } label: {
      VStack(alignment: .leading, spacing: 10) {
        HStack {
          Text(route.name)
            .font(.headline)
            .foregroundStyle(.primary)

          Spacer()

          if route.id == rideSession.selectedRoute.id {
            Image(systemName: "checkmark.circle.fill")
              .foregroundStyle(.green)
          }
        }

        RouteMapView(route: route, riderCoordinate: nil)
          .frame(height: 170)
          .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

        HStack {
          Label(
            route.totalDistance.formatted(.measurement(width: .abbreviated, usage: .road)),
            systemImage: "point.topleft.down.curvedto.point.bottomright.up")
          Spacer()
          Label("\(route.resistanceCues.count) cues", systemImage: "dial.medium")
        }
        .font(.caption)
        .foregroundStyle(.secondary)
      }
      .padding(.vertical, 8)
    }
    .buttonStyle(.plain)
    .disabled(rideSession.state == .riding || rideSession.state == .paused)
  }
}
