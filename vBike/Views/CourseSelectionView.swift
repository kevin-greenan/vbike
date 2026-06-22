import SwiftUI

struct CourseSelectionView: View {
    @EnvironmentObject private var rideSession: MockRideSession

    var body: some View {
        List {
            ForEach(MockRoutes.routes) { route in
                Button {
                    rideSession.selectedRoute = route
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
                            Label(route.totalDistance.formatted(.measurement(width: .abbreviated, usage: .road)), systemImage: "point.topleft.down.curvedto.point.bottomright.up")
                            Spacer()
                            Label("\(route.resistanceCues.count) cues", systemImage: "dial.medium")
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 8)
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle("Courses")
    }
}
