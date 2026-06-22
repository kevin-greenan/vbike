# Schwinn IC4 Bluetooth Notes

This document tracks the BLE integration plan for vBike.

## Current Implementation

- `IC4BluetoothService` wraps `CoreBluetooth` scanning.
- Settings/debug can start and stop scanning.
- Discovered peripherals show name, RSSI, and whether they look like an IC4 or cycling sensor.
- The app can initiate a placeholder connection to a discovered peripheral.
- Successful placeholder connections persist the bike's CoreBluetooth peripheral UUID and display name.
- Settings/debug can attempt reconnecting to the known bike or forget the saved bike.
- No IC4 characteristic decoding is implemented yet.

## Current Detection Heuristics

The scanner marks a peripheral as likely relevant when:

- the advertised or peripheral name contains `IC4`
- the advertised or peripheral name contains `Schwinn`
- advertised services include Cycling Power Service UUID `1818`
- advertised services include Cycling Speed and Cadence Service UUID `1816`

These are intentionally broad until tested against a real bike.

## Next Research Questions

- Confirm the exact IC4 advertised local name.
- Confirm which standard services the IC4 exposes.
- Confirm whether power, cadence, and speed are delivered via standard Cycling Power / Cycling Speed and Cadence characteristics or vendor-specific characteristics.
- Capture sample characteristic payloads from real rides before implementing decoding.
- Validate whether CoreBluetooth peripheral UUID reconnect is stable for the IC4 across app launches and phone restarts.

## Non-Goals For This Stage

- No HealthKit write support.
- No Strava export.
- No automated resistance control.
- No production BLE parser until real IC4 payloads are captured.
