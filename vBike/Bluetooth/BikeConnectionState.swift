import Foundation

enum BikeConnectionState: Equatable {
    case disconnected
    case scanning
    case connecting(name: String)
    case connected(name: String)
    case failed(message: String)
}
