import XCTest

@testable import vBike

final class KnownBikeStoreTests: XCTestCase {
  func testKnownBikeRoundTripsThroughUserDefaults() {
    let defaults = UserDefaults(suiteName: "KnownBikeStoreTests.\(UUID().uuidString)")!
    let store = UserDefaultsKnownBikeStore(defaults: defaults)
    let knownBike = KnownBike(
      id: UUID(uuidString: "00000000-0000-0000-0000-000000000010")!,
      name: "Schwinn IC4"
    )

    store.save(knownBike)

    XCTAssertEqual(store.knownBike, knownBike)
  }

  func testClearRemovesKnownBike() {
    let defaults = UserDefaults(suiteName: "KnownBikeStoreTests.\(UUID().uuidString)")!
    let store = UserDefaultsKnownBikeStore(defaults: defaults)
    let knownBike = KnownBike(
      id: UUID(uuidString: "00000000-0000-0000-0000-000000000011")!,
      name: "Schwinn IC4"
    )

    store.save(knownBike)
    store.clear()

    XCTAssertNil(store.knownBike)
  }
}
