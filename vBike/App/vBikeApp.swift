import SwiftUI

@main
struct vBikeApp: App {
  @StateObject private var rideSession = MockRideSession()

  var body: some Scene {
    WindowGroup {
      RootView()
        .environmentObject(rideSession)
        .preferredColorScheme(.dark)
    }
  }
}
