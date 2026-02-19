import SwiftUI

struct AppRootView: View {
    @EnvironmentObject var measurementStore: MeasurementStore
    @State private var isShowingSplash = true
    @State private var selectedTab: TabItem = .measurements
    
    var body: some View {
        ZStack {
            if measurementStore.isFirstLaunch {
                OnboardingView()
            } else {
                MainTabView(selectedTab: $selectedTab)
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct MainTabView: View {
    @Binding var selectedTab: TabItem
    
    var body: some View {
        ZStack {
            Group {
                switch selectedTab {
                case .measurements:
                    MeasurementsView()
                case .bodyZones:
                    BodyZonesView()
                case .dynamics:
                    DynamicsView()
                case .settings:
                    SettingsView()
                }
            }
            
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
        .appBackground()
    }
}

#Preview {
    AppRootView()
        .environmentObject(MeasurementStore())
}
