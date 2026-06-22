import SwiftUI

struct SettingsDebugView: View {
  @EnvironmentObject private var rideSession: MockRideSession
  @StateObject private var bluetoothService = IC4BluetoothService()

  var body: some View {
    List {
      Section("Bike") {
        LabeledContent("Connection", value: connectionLabel)
        LabeledContent("Scanner", value: bluetoothService.scanStatus.displayText)
        LabeledContent("Target hardware", value: "Schwinn IC4")
        LabeledContent("Telemetry source", value: "Mock")

        HStack {
          Button {
            bluetoothService.startScanning()
          } label: {
            Label("Scan", systemImage: "antenna.radiowaves.left.and.right")
          }
          .disabled(bluetoothService.scanStatus == .scanning)

          Spacer()

          Button {
            bluetoothService.stopScanning()
          } label: {
            Label("Stop", systemImage: "stop.fill")
          }
          .disabled(bluetoothService.scanStatus != .scanning)
        }
      }

      if !bluetoothService.discoveredDevices.isEmpty {
        Section("Discovered Devices") {
          ForEach(bluetoothService.discoveredDevices) { device in
            Button {
              bluetoothService.connect(to: device)
            } label: {
              HStack(spacing: 12) {
                Image(
                  systemName: device.isLikelyIC4
                    ? "bicycle.circle.fill" : "dot.radiowaves.left.and.right"
                )
                .font(.title3)
                .foregroundStyle(device.isLikelyIC4 ? .green : .secondary)

                VStack(alignment: .leading, spacing: 4) {
                  Text(device.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                  Text(
                    device.isLikelyIC4
                      ? "Likely Schwinn IC4 or cycling sensor" : "Bluetooth peripheral"
                  )
                  .font(.caption)
                  .foregroundStyle(.secondary)
                }

                Spacer()

                Text("\(device.rssi) dBm")
                  .font(.caption.monospacedDigit())
                  .foregroundStyle(.secondary)
              }
            }
          }
        }
      }

      Section("Ride Session") {
        LabeledContent("State", value: rideSession.state.rawValue.capitalized)
        LabeledContent("Selected route", value: rideSession.selectedRoute.name)
        LabeledContent(
          "Progress", value: MetricFormatters.percent(rideSession.progress.completedFraction))
        LabeledContent("Calories", value: "\(rideSession.telemetry.estimatedCalories)")
        LabeledContent(
          "ETA",
          value: MetricFormatters.optionalElapsedTime(rideSession.progress.estimatedRemainingTime))
        LabeledContent("Saved rides", value: "\(rideSession.rideHistory.count)")
      }

      if !rideSession.rideHistory.isEmpty {
        Section("Recent Rides") {
          ForEach(rideSession.rideHistory.prefix(5)) { summary in
            VStack(alignment: .leading, spacing: 6) {
              Text(summary.routeName)
                .font(.headline)
              HStack {
                Text(MetricFormatters.elapsedTime(summary.elapsedTime))
                Text("\(MetricFormatters.decimal(summary.distance)) mi")
                Text("\(summary.averagePower) W avg")
              }
              .font(.caption)
              .foregroundStyle(.secondary)
            }
            .padding(.vertical, 4)
          }
        }
      }

      Section("Future Services") {
        Label("BLE decoding pending", systemImage: "antenna.radiowaves.left.and.right")
        Label("HealthKit intentionally deferred", systemImage: "heart.text.square")
        Label("Strava export intentionally deferred", systemImage: "square.and.arrow.up")
      }
    }
    .navigationTitle("Settings")
  }

  private var connectionLabel: String {
    switch bluetoothService.connectionState {
    case .disconnected:
      return "Disconnected"
    case .scanning:
      return "Scanning"
    case .connecting(let name):
      return "Connecting to \(name)"
    case .connected(let name):
      return "Connected to \(name)"
    case .failed(let message):
      return message
    }
  }
}
