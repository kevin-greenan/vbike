import CoreBluetooth
import Foundation

protocol BikeBluetoothService: AnyObject {
    var connectionState: BikeConnectionState { get }
    var telemetryProvider: TelemetryProvider? { get }

    func startScanning()
    func disconnect()
}

final class IC4BluetoothService: NSObject, BikeBluetoothService {
    private var centralManager: CBCentralManager?

    private(set) var connectionState: BikeConnectionState = .disconnected
    private(set) var telemetryProvider: TelemetryProvider?

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: .main)
    }

    func startScanning() {
        connectionState = .scanning
        // Future work: scan for IC4 advertisements and subscribe to cycling power/cadence characteristics.
    }

    func disconnect() {
        connectionState = .disconnected
        telemetryProvider?.stop()
    }
}

extension IC4BluetoothService: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOff {
            connectionState = .failed(message: "Bluetooth is powered off.")
        }
    }
}
