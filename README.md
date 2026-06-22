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

Command-line build:

```bash
xcodebuild -project vBike.xcodeproj -scheme vBike -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' -derivedDataPath /tmp/vbike-deriveddata build
```

Command-line tests:

```bash
xcodebuild test -project vBike.xcodeproj -scheme vBike -destination 'platform=iOS Simulator,name=iPhone 17' -derivedDataPath /tmp/vbike-deriveddata
```

Using `/tmp/vbike-deriveddata` avoids file-provider metadata issues that can affect local app signing when build products are generated inside the project directory.

## Architecture Overview

- `App`: SwiftUI app entry point and root tab navigation.
- `Models`: Core route, elevation, resistance cue, and telemetry types.
- `Services`: Telemetry provider abstractions, mock telemetry generation, and local ride-history storage.
- `Bluetooth`: IC4-specific CoreBluetooth scanner shell, discovered-device model, known-bike storage, reconnect controls, and clean BLE-facing protocol boundaries.
- `RideSession`: Ride state, controls, completion summary, and mock session orchestration.
- `Routes`: Bundled mock routes, featured course library, route progress calculations, rider position, and ETA.
- `Views`: Root, dashboard, course selection, ride history, map, and settings/debug screens.
- `Components`: Reusable SwiftUI controls for metrics, ride controls, route progress, summaries, and resistance cues.
- `Utilities`: Formatting helpers for elapsed time, decimal values, progress, and optional ETA values.

## Current Limitations

- IC4 BLE discovery and characteristic decoding are placeholders only.
- Bluetooth scanning is debug-only and still needs testing against a real Schwinn IC4.
- Known-bike reconnect stores the CoreBluetooth peripheral UUID and display name, but still depends on real-bike validation.
- Ride persistence is currently limited to lightweight local summary history with an in-app clear action.
- HealthKit is not implemented.
- Strava and file export are not implemented.
- Resistance is advisory only; the app does not control the bike.
- Route data is bundled mock data rather than Apple Maps routing output.
- Estimated calories are mock approximations, not HealthKit-grade energy calculations.

## Next Recommended Tasks

1. Test Bluetooth scan results against a real Schwinn IC4 and capture advertised services.
2. Document discovered IC4 characteristics and sample payloads in `Docs/IC4Bluetooth.md`.
3. Validate known-bike reconnect behavior against the real IC4 after a successful scan/connect.
4. Add ride detail drill-down for completed workouts.
5. Replace mock route coordinates with a MapKit route creation flow.
