import SwiftUI

struct MetricTile: View {
  let title: String
  let value: String
  let unit: String
  var prominence: Prominence = .regular

  enum Prominence {
    case regular
    case hero
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(title.uppercased())
        .font(.caption2.weight(.semibold))
        .foregroundStyle(.secondary)

      HStack(alignment: .firstTextBaseline, spacing: 5) {
        Text(value)
          .font(
            prominence == .hero
              ? .system(size: 54, weight: .semibold, design: .rounded) : .title.weight(.semibold)
          )
          .monospacedDigit()
          .minimumScaleFactor(0.65)

        Text(unit)
          .font(.callout.weight(.medium))
          .foregroundStyle(.secondary)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(16)
    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
  }
}
