import SwiftUI

struct ContentView: View {
    @ObservedObject var weatherData: WeatherDataManager
    @ObservedObject var appState: AppStateManager
    
    var body: some View {
        ZStack {
            if appState.isFirstLaunch {
                OnboardingView(appState: appState)
                    .transition(.slide)
            } else {
                MainTabView(weatherData: weatherData, appState: appState)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: appState.showingSplash)
        .animation(.easeInOut(duration: 0.5), value: appState.isFirstLaunch)
    }
}

#Preview {
    ContentView(weatherData: WeatherDataManager(), appState: AppStateManager())
}
