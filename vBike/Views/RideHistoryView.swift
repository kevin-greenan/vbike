import SwiftUI

struct RideHistoryView: View {
  @EnvironmentObject private var rideSession: MockRideSession
  @State private var isShowingClearConfirmation = false

  var body: some View {
    List {
      if rideSession.rideHistory.isEmpty {
        ContentUnavailableView(
          "No Rides Yet",
          systemImage: "figure.indoor.cycle",
          description: Text("Completed mock rides will appear here.")
        )
      } else {
        Section("Completed Rides") {
          ForEach(rideSession.rideHistory) { summary in
            NavigationLink {
              RideHistoryDetailView(
                summary: summary,
                route: rideSession.courseLibrary.featuredRoutes.first {
                  $0.name == summary.routeName
                }
              )
            } label: {
              RideHistoryRow(summary: summary)
            }
          }
        }
      }
    }
    .navigationTitle("History")
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button(role: .destructive) {
          isShowingClearConfirmation = true
        } label: {
          Label("Clear History", systemImage: "trash")
        }
        .disabled(rideSession.rideHistory.isEmpty)
      }
    }
    .confirmationDialog(
      "Clear ride history?",
      isPresented: $isShowingClearConfirmation,
      titleVisibility: .visible
    ) {
      Button("Clear History", role: .destructive) {
        rideSession.clearRideHistory()
      }
      Button("Cancel", role: .cancel) {}
    } message: {
      Text("This removes locally saved mock ride summaries from this device.")
    }
  }
}

private struct RideHistoryRow: View {
  let summary: RideSummary

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      HStack(alignment: .firstTextBaseline) {
        VStack(alignment: .leading, spacing: 3) {
          Text(summary.routeName)
            .font(.headline)
          Text(MetricFormatters.rideDate(summary.completedAt))
            .font(.caption)
            .foregroundStyle(.secondary)
        }

        Spacer()

        Text(MetricFormatters.percent(summary.completedFraction))
          .font(.subheadline.weight(.semibold))
          .foregroundStyle(summary.completedFraction >= 1 ? .green : .secondary)
      }

      Grid(alignment: .leading, horizontalSpacing: 18, verticalSpacing: 8) {
        GridRow {
          historyMetric("Time", MetricFormatters.elapsedTime(summary.elapsedTime))
          historyMetric("Distance", "\(MetricFormatters.decimal(summary.distance)) mi")
        }

        GridRow {
          historyMetric("Avg Power", "\(summary.averagePower) W")
          historyMetric("Calories", "\(summary.estimatedCalories)")
        }
      }
    }
    .padding(.vertical, 6)
  }

  private func historyMetric(_ title: String, _ value: String) -> some View {
    VStack(alignment: .leading, spacing: 2) {
      Text(title.uppercased())
        .font(.caption2.weight(.semibold))
        .foregroundStyle(.secondary)
      Text(value)
        .font(.subheadline.monospacedDigit().weight(.medium))
        .lineLimit(1)
        .minimumScaleFactor(0.8)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}
