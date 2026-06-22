import Foundation

enum BluetoothScanStatus: Equatable {
  case idle
  case waitingForBluetooth
  case scanning
  case unsupported
  case unauthorized
  case poweredOff
  case failed(message: String)

  var displayText: String {
    switch self {
    case .idle:
      return "Idle"
    case .waitingForBluetooth:
      return "Waiting for Bluetooth"
    case .scanning:
      return "Scanning"
    case .unsupported:
      return "Unsupported"
    case .unauthorized:
      return "Unauthorized"
    case .poweredOff:
      return "Powered off"
    case .failed(let message):
      return message
    }
  }
}
