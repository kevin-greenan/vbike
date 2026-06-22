import Foundation

struct KnownBike: Codable, Equatable, Identifiable {
  let id: UUID
  var name: String
  var lastConnectedAt: Date

  init(id: UUID, name: String, lastConnectedAt: Date = Date()) {
    self.id = id
    self.name = name
    self.lastConnectedAt = lastConnectedAt
  }
}
