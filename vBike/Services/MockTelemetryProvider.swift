import Foundation

final class MockTelemetryProvider: TelemetryProvider {
    private var timer: Timer?
    private var tick: Int = 0
    private var powerSamples: [Int] = []

    private(set) var latestTelemetry: RideTelemetry = .zero
    var onTelemetryUpdate: ((RideTelemetry) -> Void)?

    func reset() {
        stop()
        tick = 0
        powerSamples = []
        latestTelemetry = .zero
        onTelemetryUpdate?(latestTelemetry)
    }

    func start() {
        guard timer == nil else { return }

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.advance()
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    private func advance() {
        tick += 1

        let wave = sin(Double(tick) / 7.0)
        let climbPulse = sin(Double(tick) / 23.0)
        let power = max(85, Int(165 + (wave * 42) + (climbPulse * 28)))
        powerSamples.append(power)

        let averagePower = powerSamples.reduce(0, +) / max(powerSamples.count, 1)
        let cadence = max(62, Int(86 + sin(Double(tick) / 5.0) * 10))
        let speed = max(12.0, 18.5 + wave * 2.8 + climbPulse)
        let distance = latestTelemetry.distance + speed / 3600.0
        let resistance = max(18, min(58, Int(34 + climbPulse * 16)))

        latestTelemetry = RideTelemetry(
            currentPower: power,
            averagePower: averagePower,
            cadence: cadence,
            speed: speed,
            elapsedTime: TimeInterval(tick),
            distance: distance,
            targetResistance: resistance
        )

        onTelemetryUpdate?(latestTelemetry)
    }
}
