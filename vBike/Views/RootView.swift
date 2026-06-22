import SwiftUI

struct RootView: View {
    @State private var selectedTab: AppTab = .ride

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                RideDashboardView()
            }
            .tabItem {
                Label("Ride", systemImage: "figure.indoor.cycle")
            }
            .tag(AppTab.ride)

            NavigationStack {
                CourseSelectionView()
            }
            .tabItem {
                Label("Courses", systemImage: "map")
            }
            .tag(AppTab.courses)

            NavigationStack {
                SettingsDebugView()
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape")
            }
            .tag(AppTab.settings)
        }
    }
}
