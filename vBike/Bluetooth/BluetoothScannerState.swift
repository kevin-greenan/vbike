import Foundation

struct BluetoothScannerState: Equatable {
  private(set) var status: BluetoothScanStatus = .idle
  private(set) var devices: [BluetoothDiscoveredDevice] = []

  var isScanning: Bool {
    status == .scanning
  }

  mutating func startWaitingForBluetooth() {
    status = .waitingForBluetooth
  }

  mutating func startScanning() {
    status = .scanning
  }

  mutating func stopScanning() {
    status = .idle
  }

  mutating func fail(_ message: String) {
    status = .failed(message: message)
  }

  mutating func markPoweredOff() {
    status = .poweredOff
  }

  mutating func markUnauthorized() {
    status = .unauthorized
  }

  mutating func markUnsupported() {
    status = .unsupported
  }

  mutating func recordDiscovery(_ device: BluetoothDiscoveredDevice) {
    if let index = devices.firstIndex(where: { $0.id == device.id }) {
      devices[index] = device
    } else {
      devices.append(device)
    }

    devices.sort { lhs, rhs in
      if lhs.isLikelyIC4 != rhs.isLikelyIC4 {
        return lhs.isLikelyIC4 && !rhs.isLikelyIC4
      }

      return lhs.rssi > rhs.rssi
    }
  }
}
