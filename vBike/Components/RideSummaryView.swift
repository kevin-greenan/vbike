import SwiftUI

struct RideSummaryView: View {
  let summary: RideSummary

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Label("Ride Summary", systemImage: "checkmark.seal.fill")
        .font(.headline)
        .foregroundStyle(.green)

      LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
        summaryRow("Time", MetricFormatters.elapsedTime(summary.elapsedTime))
        summaryRow("Distance", "\(MetricFormatters.decimal(summary.distance)) mi")
        summaryRow("Avg Power", "\(summary.averagePower) W")
        summaryRow("Calories", "\(summary.estimatedCalories)")
        summaryRow("Complete", MetricFormatters.percent(summary.completedFraction))
        summaryRow("Route", summary.routeName)
      }
    }
    .padding(16)
    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
  }

  private func summaryRow(_ title: String, _ value: String) -> some View {
    VStack(alignment: .leading, spacing: 4) {
      Text(title.uppercased())
        .font(.caption2.weight(.semibold))
        .foregroundStyle(.secondary)
      Text(value)
        .font(.subheadline.weight(.semibold))
        .lineLimit(2)
        .minimumScaleFactor(0.75)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}
