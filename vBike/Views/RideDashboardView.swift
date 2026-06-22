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

        RideControlBar(
          state: rideSession.state,
          start: rideSession.start,
          pause: rideSession.pause,
          resume: rideSession.resume,
          stop: rideSession.stop
        )

        if let completedSummary = rideSession.completedSummary {
          RideSummaryView(summary: completedSummary)
        }

        MetricTile(title: "Power", value: "\(telemetry.currentPower)", unit: "W", prominence: .hero)

        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
          MetricTile(title: "Average", value: "\(telemetry.averagePower)", unit: "W")
          MetricTile(title: "Cadence", value: "\(telemetry.cadence)", unit: "RPM")
          MetricTile(title: "Speed", value: MetricFormatters.decimal(telemetry.speed), unit: "MPH")
          MetricTile(
            title: "Distance", value: MetricFormatters.decimal(telemetry.distance), unit: "MI")
          MetricTile(
            title: "Elapsed", value: MetricFormatters.elapsedTime(telemetry.elapsedTime), unit: "")
          MetricTile(
            title: "Remaining",
            value: MetricFormatters.decimal(
              rideSession.progress.remainingDistance.converted(to: .miles).value), unit: "MI")
          MetricTile(title: "Calories", value: "\(telemetry.estimatedCalories)", unit: "KCAL")
        }

        RouteProgressPanel(progress: rideSession.progress)
        ResistanceCueView(telemetry: telemetry, cue: rideSession.upcomingCue)

        RouteMapView(
          route: rideSession.selectedRoute, riderCoordinate: rideSession.progress.riderCoordinate
        )
        .frame(height: 280)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
      }
      .padding()
    }
    .navigationTitle("vBike")
    .toolbar {
      ToolbarItem(placement: .primaryAction) {
        Button(action: rideSession.stop) {
          Image(systemName: "stop.fill")
        }
        .disabled(rideSession.state == .idle || rideSession.state == .completed)
        .accessibilityLabel("Stop ride")
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
}
