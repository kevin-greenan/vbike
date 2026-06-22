import SwiftUI

struct RideHistoryDetailView: View {
  let summary: RideSummary
  let route: CyclingRoute?

  private var completedDistanceText: String {
    "\(MetricFormatters.decimal(summary.distance)) mi"
  }

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 20) {
        if let route {
          RouteMapView(
            route: route,
            riderCoordinate: RouteProgressEngine()
              .progress(
                for: route,
                distanceMiles: summary.distance
              )
              .riderCoordinate
          )
          .frame(height: 240)
          .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }

        VStack(alignment: .leading, spacing: 6) {
          Text(summary.routeName)
            .font(.title2.weight(.semibold))
          Text(MetricFormatters.rideDate(summary.completedAt))
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }

        Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 14) {
          GridRow {
            detailMetric(
              "Duration",
              MetricFormatters.elapsedTime(summary.elapsedTime),
              systemImage: "timer"
            )
            detailMetric(
              "Distance", completedDistanceText,
              systemImage: "point.topleft.down.curvedto.point.bottomright.up")
          }

          GridRow {
            detailMetric("Avg Power", "\(summary.averagePower) W", systemImage: "bolt.fill")
            detailMetric("Calories", "\(summary.estimatedCalories)", systemImage: "flame.fill")
          }

          GridRow {
            detailMetric(
              "Completion",
              MetricFormatters.percent(summary.completedFraction),
              systemImage: "checkmark.seal.fill"
            )
            detailMetric("Source", "Mock ride", systemImage: "waveform.path.ecg")
          }
        }

        if route == nil {
          Label("Route map unavailable for this saved summary.", systemImage: "map")
            .font(.footnote)
            .foregroundStyle(.secondary)
        }
      }
      .padding()
    }
    .navigationTitle("Ride Details")
    .navigationBarTitleDisplayMode(.inline)
    .background(Color(.systemGroupedBackground))
  }

  private func detailMetric(_ title: String, _ value: String, systemImage: String) -> some View {
    HStack(alignment: .top, spacing: 10) {
      Image(systemName: systemImage)
        .font(.headline)
        .foregroundStyle(.green)
        .frame(width: 24)

      VStack(alignment: .leading, spacing: 3) {
        Text(title.uppercased())
          .font(.caption2.weight(.semibold))
          .foregroundStyle(.secondary)
        Text(value)
          .font(.headline.monospacedDigit())
          .lineLimit(1)
          .minimumScaleFactor(0.8)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}
