import SwiftUI

struct RouteProgressPanel: View {
  let progress: RouteProgress

  var body: some View {
    HStack(spacing: 12) {
      Label(MetricFormatters.percent(progress.completedFraction), systemImage: "flag.checkered")
        .frame(maxWidth: .infinity, alignment: .leading)

      Label(
        MetricFormatters.optionalElapsedTime(progress.estimatedRemainingTime), systemImage: "timer"
      )
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .font(.subheadline.weight(.medium))
    .foregroundStyle(.secondary)
    .padding(14)
    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
  }
}
