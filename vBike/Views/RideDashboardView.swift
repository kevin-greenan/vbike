import SwiftUI

struct RideDashboardView: View {
    @EnvironmentObject private var rideSession: MockRideSession

    private var telemetry: RideTelemetry {
        rideSession.telemetry
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                header

                MetricTile(title: "Power", value: "\(telemetry.currentPower)", unit: "W", prominence: .hero)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    MetricTile(title: "Average", value: "\(telemetry.averagePower)", unit: "W")
                    MetricTile(title: "Cadence", value: "\(telemetry.cadence)", unit: "RPM")
                    MetricTile(title: "Speed", value: MetricFormatters.decimal(telemetry.speed), unit: "MPH")
                    MetricTile(title: "Distance", value: MetricFormatters.decimal(telemetry.distance), unit: "MI")
                    MetricTile(title: "Elapsed", value: MetricFormatters.elapsedTime(telemetry.elapsedTime), unit: "")
                    MetricTile(title: "Remaining", value: MetricFormatters.decimal(rideSession.progress.remainingDistance.converted(to: .miles).value), unit: "MI")
                }

                ResistanceCueView(telemetry: telemetry, cue: rideSession.upcomingCue)

                RouteMapView(route: rideSession.selectedRoute, riderCoordinate: rideSession.progress.riderCoordinate)
                    .frame(height: 280)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
            .padding()
        }
        .navigationTitle("vBike")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: toggleRide) {
                    Image(systemName: rideSession.state == .riding ? "pause.fill" : "play.fill")
                }
                .accessibilityLabel(rideSession.state == .riding ? "Pause ride" : "Start ride")
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(rideSession.selectedRoute.name)
                        .font(.title2.weight(.semibold))
                    Text("\(MetricFormatters.percent(rideSession.progress.completedFraction)) complete")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text(rideSession.state.rawValue.uppercased())
                    .font(.caption.weight(.bold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.blue.opacity(0.22), in: Capsule())
            }

            ProgressView(value: rideSession.progress.completedFraction)
                .tint(.green)
        }
        .padding(16)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private func toggleRide() {
        switch rideSession.state {
        case .idle, .completed:
            rideSession.start()
        case .riding:
            rideSession.pause()
        case .paused:
            rideSession.resume()
        }
    }
}
