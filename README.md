# vBike

vBike is a native iOS companion app for the Schwinn IC4 indoor bike. The long-term product vision is a first-party-feeling cycling experience that combines Apple Fitness-style metrics, Apple Maps route context, and cycling-computer clarity.

The app will eventually connect to the IC4 over Bluetooth, display live cycling telemetry, simulate progress across real-world routes, and prompt riders to manually adjust resistance based on route elevation.

## Local Development

Requirements:

- Xcode with the iOS 17 SDK or newer
- iOS 17 simulator or device
- SwiftUI and MapKit support from the native Apple SDKs

Open `vBike.xcodeproj` in Xcode, select the `vBike` scheme, and run on an iPhone simulator.

This repository currently avoids third-party dependencies. The app is mock-data driven, so an IC4 is not required to exercise the dashboard and course map.

## Architecture Overview

- `App`: SwiftUI app entry point and root tab navigation.
- `Models`: Core route, elevation, resistance cue, and telemetry types.
- `Services`: Telemetry provider abstractions and mock telemetry generation.
- `Bluetooth`: IC4-specific Bluetooth service placeholder with clean BLE-facing protocol boundaries.
- `RideSession`: Ride state and mock session orchestration.
- `Routes`: Bundled mock routes and route progress calculations.
- `Views`: Root, dashboard, course selection, map, and settings/debug screens.
- `Components`: Reusable SwiftUI controls for metrics and resistance cues.
- `Utilities`: Formatting helpers for elapsed time, decimal values, and progress.

## Current Limitations

- IC4 BLE discovery and characteristic decoding are placeholders only.
- Ride data is not persisted.
- HealthKit is not implemented.
- Strava and file export are not implemented.
- Resistance is advisory only; the app does not control the bike.
- Route data is bundled mock data rather than Apple Maps routing output.

## Next Recommended Tasks

1. Verify the project in Xcode and add a first smoke-test target.
2. Research IC4 BLE services and document discovered characteristics.
3. Build a real BLE scanner behind `BikeBluetoothService`.
4. Add start, pause, stop, and completion polish to the ride session flow.
5. Replace mock route coordinates with a MapKit route creation flow.
