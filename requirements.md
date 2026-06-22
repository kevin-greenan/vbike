IC4 Virtual Cycling Companion

Product Roadmap & Agile Tracker

Current Implementation Status

Completed initial app setup:

* Created an iOS SwiftUI Xcode project scaffold.
* Added native app structure for App, Models, Services, Bluetooth, RideSession, Routes, Views, Components, and Utilities.
* Built a placeholder app shell with Ride, Courses, and Settings tabs.
* Added a mock ride dashboard with current power, average power, cadence, speed, elapsed time, distance, target resistance, and estimated calories.
* Added a mock ride session that updates fake telemetry over time.
* Added workout start, pause, resume, stop, and completed-summary UI states for mock rides.
* Added a dedicated History tab for completed ride summaries with local clear-history support.
* Added a placeholder IC4 Bluetooth service/protocol for future BLE integration.
* Added mock route models with coordinates, elevation samples, and resistance cues.
* Added route progress calculation with rider position, remaining distance, completion percentage, and ETA.
* Added a bundled course library abstraction with featured mock courses.
* Added a MapKit route display using bundled mock coordinates and simulated rider progress.
* Added lightweight local ride-history persistence for completed mock rides.
* Added an XCTest target covering route progress math and mock ride session state transitions.
* Added a CoreBluetooth scanner shell with debug UI for discovered peripherals.
* Added preliminary IC4 BLE detection heuristics and Bluetooth integration notes.
* Added known-bike persistence, reconnect, and forget actions for future IC4 pairing flows.
* Added project README with setup, architecture, limitations, and next tasks.
* Added git ignores for local Xcode build and user metadata.

Not yet implemented:

* IC4 BLE telemetry decoding.
* HealthKit integration and true calorie/energy recording.
* Strava integration or export.
* Real Apple Maps route generation.
* Automated UI tests.

Vision

Build a native iOS application that transforms a Schwinn IC4 indoor bike into a virtual outdoor riding experience.

The application will:

* Connect directly to a Schwinn IC4 via Bluetooth.
* Display real-world routes using Apple Maps.
* Simulate course progression based on bike telemetry.
* Convert route elevation into resistance recommendations.
* Record workout metrics and export ride data.
* Integrate with Apple Health/Fitness.
* Optionally integrate with Strava.

The design philosophy is:

Apple Fitness + Apple Maps + Cycling Computer

Not a Peloton clone.
Not a gamified experience.
Not a social network.

The application should feel like a first-party Apple fitness application.

⸻

Product Goals

Primary Goals

* Create immersive virtual rides from real-world routes.
* Make indoor cycling less monotonous.
* Preserve realistic route progression and geography.
* Provide meaningful cycling metrics.
* Maintain a clean Apple-native user experience.

Non-Goals (v1)

* Multiplayer riding
* Social features
* Peloton-style classes
* Video streaming
* Automatic resistance control
* AI coaching
* Apple Watch companion app
* Real-time Strava uploads

⸻

Milestone 1

Bike Connectivity Foundation

Epic: IC4 Bluetooth Integration

Story

As a rider, I want the app to connect directly to my IC4 so that ride metrics can be captured in real time.

Tasks

* Research IC4 Bluetooth services
* Build BLE scanner
* Discover bike advertisements
* Persist known bike identifier
* Auto-reconnect to known bike
* Parse power metrics
* Parse cadence metrics
* Parse speed metrics
* Create telemetry abstraction layer
* Implement connection state handling
* Implement error handling

Acceptance Criteria

* Bike connects in <5 seconds
* Power updates continuously
* Cadence updates continuously
* Speed updates continuously
* Connection survives brief interruptions

⸻

Milestone 2

Ride Dashboard

Epic: Workout Experience

Story

As a rider, I want a clean workout dashboard while riding.

Tasks

* Create ride session model
* Build workout start flow
* Build workout pause flow
* Build workout stop flow
* Display current power
* Display average power
* Display cadence
* Display elapsed time
* Display distance
* Display estimated calories
* Build dark mode support

Acceptance Criteria

* Ride can be completed end-to-end
* Ride data persists locally
* Dashboard updates in real time

⸻

Milestone 3

Apple Maps Route Engine

Epic: Route Selection

Story

As a rider, I want to select a route using Apple Maps.

Tasks

* Integrate MapKit
* Add location search
* Add start location selector
* Add destination selector
* Generate route using Apple routing APIs
* Display route polyline
* Calculate total route distance
* Persist route locally

Acceptance Criteria

* User can create route from A → B
* Route appears on map
* Route can be reused later

⸻

Milestone 4

Virtual Rider Simulation

Epic: Route Progression

Story

As a rider, I want my position to advance along the route based on bike activity.

Tasks

* Create route progress engine
* Convert bike distance into route progress
* Create rider marker
* Animate marker movement
* Display remaining distance
* Display completion percentage
* Display ETA

Acceptance Criteria

* Rider marker moves smoothly
* Route completion accurately tracks bike effort

⸻

Milestone 5

Elevation & Resistance Engine

Epic: Grade Simulation

Story

As a rider, I want terrain elevation to influence recommended resistance.

Tasks

* Evaluate elevation data providers
* Retrieve route elevation samples
* Generate elevation profile
* Smooth elevation data
* Calculate route grades
* Convert grades to resistance targets
* Build resistance recommendation engine
* Add resistance notifications
* Add climb/descent indicators

Acceptance Criteria

* Resistance changes occur naturally
* No rapid unrealistic transitions
* User receives clear guidance

⸻

Milestone 6

Course Library

Epic: Saved Courses

Story

As a rider, I want access to curated routes.

Tasks

* Create course data model
* Create bundled course system
* Add Chicago Lakefront Trail
* Add Chicago City Loop
* Add Seattle Waterfront Route
* Add Mountain Climb Route
* Add Favorites functionality
* Add Recently Ridden list

Acceptance Criteria

* Users can ride curated routes immediately
* Routes remain available offline

⸻

Milestone 7

Apple Health Integration

Epic: HealthKit

Story

As a rider, I want rides stored in Apple Health.

Tasks

* Configure HealthKit permissions
* Create workout records
* Save workout duration
* Save workout distance
* Save calories
* Save cycling workout metadata

Acceptance Criteria

* Completed rides appear in Apple Fitness
* Health data syncs correctly

⸻

Milestone 8

Export & Sharing

Epic: Ride Export

Story

As a rider, I want to export my rides.

Tasks

* Generate FIT files
* Generate GPX files
* Generate TCX files
* Export workout package
* Add share sheet

Acceptance Criteria

* Exported rides open in third-party platforms

⸻

Milestone 9

Strava Compatibility

Epic: Strava Support

Story

As a rider, I want exported rides to appear as virtual rides.

Tasks

* Research Strava activity requirements
* Generate GPS track from route progression
* Mark activity as virtual ride
* Validate uploads
* Create export workflow

Acceptance Criteria

* Exported rides appear correctly in Strava
* Route visualization preserved

⸻

Future Roadmap (Post-MVP)

v2

* Apple Watch companion app
* Live heart rate integration
* Live watch metrics
* Route collections
* Ride achievements
* FTP estimation
* Training zones
* Structured workouts

v3

* AI ride recommendations
* Dynamic route generation
* Multi-device sync
* iPad support
* macOS companion app
* Cloud backup

v4

* Real-time Strava integration
* Friends and group rides
* Route marketplace
* Community-created routes

⸻

Definition of Done

A release is considered complete when:

* Feature implemented
* Unit tests written
* UI tested
* Accessibility reviewed
* Dark mode verified
* Performance reviewed
* Documentation updated
* No critical bugs remain
