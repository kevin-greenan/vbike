import Foundation

struct RideSummary: Equatable {
  let routeName: String
  let elapsedTime: TimeInterval
  let distance: Double
  let averagePower: Int
  let estimatedCalories: Int
  let completedFraction: Double
}
