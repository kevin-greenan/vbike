import CoreBluetooth
import Foundation

protocol BikeBluetoothService: AnyObject {
  var connectionState: BikeConnectionState { get }
  var scanStatus: BluetoothScanStatus { get }
  var discoveredDevices: [BluetoothDiscoveredDevice] { get }
  var telemetryProvider: TelemetryProvider? { get }

  func startScanning()
  func stopScanning()
  func connect(to device: BluetoothDiscoveredDevice)
  func disconnect()
}

final class IC4BluetoothService: NSObject, BikeBluetoothService, ObservableObject {
  private var centralManager: CBCentralManager?
  private var peripheralIDsByDeviceID: [UUID: CBPeripheral] = [:]
  private var scannerState = BluetoothScannerState()

  @Published private(set) var connectionState: BikeConnectionState = .disconnected
  @Published private(set) var scanStatus: BluetoothScanStatus = .idle
  @Published private(set) var discoveredDevices: [BluetoothDiscoveredDevice] = []
  private(set) var telemetryProvider: TelemetryProvider?

  override init() {
    super.init()
    centralManager = CBCentralManager(delegate: self, queue: .main)
    applyScannerState { $0.startWaitingForBluetooth() }
  }

  func startScanning() {
    guard let centralManager else {
      applyScannerState { $0.fail("Bluetooth manager unavailable.") }
      return
    }

    switch centralManager.state {
    case .poweredOn:
      connectionState = .scanning
      applyScannerState { $0.startScanning() }
      centralManager.scanForPeripherals(
        withServices: nil,
        options: [
          CBCentralManagerScanOptionAllowDuplicatesKey: true
        ])
    case .poweredOff:
      applyScannerState { $0.markPoweredOff() }
      connectionState = .failed(message: "Bluetooth is powered off.")
    case .unauthorized:
      applyScannerState { $0.markUnauthorized() }
      connectionState = .failed(message: "Bluetooth permission is not authorized.")
    case .unsupported:
      applyScannerState { $0.markUnsupported() }
      connectionState = .failed(message: "Bluetooth is not supported on this device.")
    case .resetting, .unknown:
      applyScannerState { $0.startWaitingForBluetooth() }
    @unknown default:
      applyScannerState { $0.fail("Unknown Bluetooth state.") }
    }
  }

  func stopScanning() {
    centralManager?.stopScan()
    applyScannerState { $0.stopScanning() }

    if case .scanning = connectionState {
      connectionState = .disconnected
    }
  }

  func connect(to device: BluetoothDiscoveredDevice) {
    guard let peripheral = peripheralIDsByDeviceID[device.id] else {
      connectionState = .failed(message: "Selected bike is no longer available.")
      return
    }

    stopScanning()
    connectionState = .connecting(name: device.name)
    centralManager?.connect(peripheral)
  }

  func disconnect() {
    if case .scanning = connectionState {
      stopScanning()
    }

    connectionState = .disconnected
    telemetryProvider?.stop()
  }

  private func applyScannerState(_ update: (inout BluetoothScannerState) -> Void) {
    update(&scannerState)
    scanStatus = scannerState.status
    discoveredDevices = scannerState.devices
  }

  private func recordDiscovery(
    peripheral: CBPeripheral,
    advertisementData: [String: Any],
    rssi: NSNumber
  ) {
    let advertisedName = advertisementData[CBAdvertisementDataLocalNameKey] as? String
    let name = advertisedName ?? peripheral.name ?? "Unknown Bike"
    let device = BluetoothDiscoveredDevice(
      id: peripheral.identifier,
      name: name,
      rssi: rssi.intValue,
      lastSeen: Date(),
      isLikelyIC4: Self.isLikelyIC4(name: name, advertisementData: advertisementData)
    )

    peripheralIDsByDeviceID[device.id] = peripheral
    applyScannerState { $0.recordDiscovery(device) }
  }

  static func isLikelyIC4(name: String, advertisementData: [String: Any] = [:]) -> Bool {
    let normalizedName = name.lowercased()
    if normalizedName.contains("ic4") || normalizedName.contains("schwinn") {
      return true
    }

    let serviceUUIDs = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] ?? []
    return serviceUUIDs.contains(CBUUID(string: "1818"))
      || serviceUUIDs.contains(CBUUID(string: "1816"))
  }
}

extension IC4BluetoothService: CBCentralManagerDelegate {
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    switch central.state {
    case .poweredOn:
      if scanStatus == .waitingForBluetooth {
        applyScannerState { $0.stopScanning() }
      }
    case .poweredOff:
      applyScannerState { $0.markPoweredOff() }
      connectionState = .failed(message: "Bluetooth is powered off.")
    case .unauthorized:
      applyScannerState { $0.markUnauthorized() }
      connectionState = .failed(message: "Bluetooth permission is not authorized.")
    case .unsupported:
      applyScannerState { $0.markUnsupported() }
      connectionState = .failed(message: "Bluetooth is not supported on this device.")
    case .resetting, .unknown:
      applyScannerState { $0.startWaitingForBluetooth() }
    @unknown default:
      applyScannerState { $0.fail("Unknown Bluetooth state.") }
    }
  }

  func centralManager(
    _ central: CBCentralManager,
    didDiscover peripheral: CBPeripheral,
    advertisementData: [String: Any],
    rssi RSSI: NSNumber
  ) {
    recordDiscovery(peripheral: peripheral, advertisementData: advertisementData, rssi: RSSI)
  }

  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    let name = peripheral.name ?? "Schwinn IC4"
    connectionState = .connected(name: name)
    // Future work: discover IC4 services and subscribe to cycling telemetry characteristics.
  }

  func centralManager(
    _ central: CBCentralManager,
    didFailToConnect peripheral: CBPeripheral,
    error: Error?
  ) {
    connectionState = .failed(message: error?.localizedDescription ?? "Could not connect to bike.")
  }

  func centralManager(
    _ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?
  ) {
    if let error {
      connectionState = .failed(message: error.localizedDescription)
    } else {
      connectionState = .disconnected
    }
  }
}
