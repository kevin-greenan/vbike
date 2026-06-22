import Foundation

struct RideSummary: Codable, Equatable, Identifiable {
  let id: UUID
  let completedAt: Date
  let routeName: String
  let elapsedTime: TimeInterval
  let distance: Double
  let averagePower: Int
  let estimatedCalories: Int
  let completedFraction: Double

  init(
    id: UUID = UUID(),
    completedAt: Date = Date(),
    routeName: String,
    elapsedTime: TimeInterval,
    distance: Double,
    averagePower: Int,
    estimatedCalories: Int,
    completedFraction: Double
  ) {
    self.id = id
    self.completedAt = completedAt
    self.routeName = routeName
    self.elapsedTime = elapsedTime
    self.distance = distance
    self.averagePower = averagePower
    self.estimatedCalories = estimatedCalories
    self.completedFraction = completedFraction
  }
}
