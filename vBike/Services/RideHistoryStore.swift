import Foundation

protocol RideHistoryStore: AnyObject {
  var summaries: [RideSummary] { get }

  func save(_ summary: RideSummary)
  func clear()
}

final class UserDefaultsRideHistoryStore: RideHistoryStore {
  private let defaults: UserDefaults
  private let key: String
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()

  init(defaults: UserDefaults = .standard, key: String = "rideHistory.summaries") {
    self.defaults = defaults
    self.key = key
  }

  var summaries: [RideSummary] {
    guard let data = defaults.data(forKey: key) else { return [] }
    return (try? decoder.decode([RideSummary].self, from: data)) ?? []
  }

  func save(_ summary: RideSummary) {
    let updatedSummaries = [summary] + summaries
    guard let data = try? encoder.encode(updatedSummaries) else { return }
    defaults.set(data, forKey: key)
  }

  func clear() {
    defaults.removeObject(forKey: key)
  }
}
