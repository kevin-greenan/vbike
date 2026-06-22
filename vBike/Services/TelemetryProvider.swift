import Foundation

protocol TelemetryProvider: AnyObject {
  var latestTelemetry: RideTelemetry { get }
  var onTelemetryUpdate: ((RideTelemetry) -> Void)? { get set }

  func reset()
  func start()
  func stop()
}
