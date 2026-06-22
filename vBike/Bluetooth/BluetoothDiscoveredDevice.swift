import Foundation

struct BluetoothDiscoveredDevice: Equatable, Identifiable {
  let id: UUID
  var name: String
  var rssi: Int
  var lastSeen: Date
  var isLikelyIC4: Bool
}
