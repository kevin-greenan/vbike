import XCTest

@testable import vBike

final class BluetoothScannerStateTests: XCTestCase {
  func testScannerRecordsAndSortsLikelyIC4DevicesFirst() {
    var state = BluetoothScannerState()

    state.recordDiscovery(
      BluetoothDiscoveredDevice(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
        name: "Keyboard",
        rssi: -30,
        lastSeen: Date(),
        isLikelyIC4: false
      )
    )
    state.recordDiscovery(
      BluetoothDiscoveredDevice(
        id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
        name: "Schwinn IC4",
        rssi: -70,
        lastSeen: Date(),
        isLikelyIC4: true
      )
    )

    XCTAssertEqual(state.devices.map(\.name), ["Schwinn IC4", "Keyboard"])
  }

  func testScannerUpdatesExistingDeviceByIdentifier() {
    let id = UUID(uuidString: "00000000-0000-0000-0000-000000000003")!
    var state = BluetoothScannerState()

    state.recordDiscovery(
      BluetoothDiscoveredDevice(
        id: id,
        name: "Unknown Bike",
        rssi: -80,
        lastSeen: Date(),
        isLikelyIC4: false
      )
    )
    state.recordDiscovery(
      BluetoothDiscoveredDevice(
        id: id,
        name: "Schwinn IC4",
        rssi: -42,
        lastSeen: Date(),
        isLikelyIC4: true
      )
    )

    XCTAssertEqual(state.devices.count, 1)
    XCTAssertEqual(state.devices[0].name, "Schwinn IC4")
    XCTAssertEqual(state.devices[0].rssi, -42)
  }

  func testLikelyIC4NameDetection() {
    XCTAssertTrue(IC4BluetoothService.isLikelyIC4(name: "Schwinn IC4"))
    XCTAssertTrue(IC4BluetoothService.isLikelyIC4(name: "IC4 Bike"))
    XCTAssertFalse(IC4BluetoothService.isLikelyIC4(name: "AirPods"))
  }
}
