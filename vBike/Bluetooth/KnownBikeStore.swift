import Foundation

protocol KnownBikeStore: AnyObject {
  var knownBike: KnownBike? { get }

  func save(_ knownBike: KnownBike)
  func clear()
}

final class UserDefaultsKnownBikeStore: KnownBikeStore {
  private let defaults: UserDefaults
  private let key: String
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()

  init(defaults: UserDefaults = .standard, key: String = "bluetooth.knownBike") {
    self.defaults = defaults
    self.key = key
  }

  var knownBike: KnownBike? {
    guard let data = defaults.data(forKey: key) else { return nil }
    return try? decoder.decode(KnownBike.self, from: data)
  }

  func save(_ knownBike: KnownBike) {
    guard let data = try? encoder.encode(knownBike) else { return }
    defaults.set(data, forKey: key)
  }

  func clear() {
    defaults.removeObject(forKey: key)
  }
}
