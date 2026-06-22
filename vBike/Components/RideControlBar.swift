import SwiftUI

struct RideControlBar: View {
  let state: RideSessionState
  let start: () -> Void
  let pause: () -> Void
  let resume: () -> Void
  let stop: () -> Void

  var body: some View {
    HStack(spacing: 12) {
      switch state {
      case .idle, .completed:
        Button(action: start) {
          Label("Start", systemImage: "play.fill")
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)

      case .riding:
        Button(action: pause) {
          Label("Pause", systemImage: "pause.fill")
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)

        Button(role: .destructive, action: stop) {
          Label("Stop", systemImage: "stop.fill")
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)

      case .paused:
        Button(action: resume) {
          Label("Resume", systemImage: "play.fill")
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)

        Button(role: .destructive, action: stop) {
          Label("Stop", systemImage: "stop.fill")
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.bordered)
      }
    }
    .controlSize(.large)
  }
}
