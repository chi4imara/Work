import SwiftUI

struct MainAppView: View {
    @EnvironmentObject var makeupStore: MakeupStore
    
    var body: some View {
        Group {
            if !makeupStore.hasCompletedOnboarding {
                OnboardingView()
            } else {
                NavigationStack {
                    MainTabView()
                        .navigationBarHidden(true)
                }
            }
        }
    }
}

struct MainAppView_Previews: PreviewProvider {
    static var previews: some View {
        MainAppView()
            .environmentObject(MakeupStore())
    }
}
