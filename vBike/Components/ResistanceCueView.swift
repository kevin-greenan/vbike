import SwiftUI

struct ResistanceCueView: View {
  let telemetry: RideTelemetry
  let cue: ResistanceCue?

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        Label("Resistance", systemImage: "dial.medium")
          .font(.headline)
        Spacer()
        Text("\(telemetry.targetResistance)")
          .font(.title2.weight(.semibold))
          .monospacedDigit()
      }

      if let cue {
        HStack {
          Text("Next cue")
            .foregroundStyle(.secondary)
          Spacer()
          Text(
            "\(cue.targetResistance) at \(cue.distance.formatted(.measurement(width: .abbreviated, usage: .road)))"
          )
          .fontWeight(.medium)
        }
        .font(.subheadline)

        Gauge(value: Double(telemetry.targetResistance), in: 0...100) {
          EmptyView()
        }
        .tint(.orange)
      } else {
        Text("No upcoming cue")
          .font(.subheadline)
          .foregroundStyle(.secondary)
      }
    }
    .padding(16)
    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
  }
}
