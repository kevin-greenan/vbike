import Foundation

struct RideTelemetry: Equatable {
    var currentPower: Int
    var averagePower: Int
    var cadence: Int
    var speed: Double
    var elapsedTime: TimeInterval
    var distance: Double
    var targetResistance: Int

    static let zero = RideTelemetry(
        currentPower: 0,
        averagePower: 0,
        cadence: 0,
        speed: 0,
        elapsedTime: 0,
        distance: 0,
        targetResistance: 0
    )
}
