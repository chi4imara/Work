import SwiftUI

struct MainAppView: View {
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        ZStack {
            if appViewModel.showOnboarding {
                OnboardingView(appViewModel: appViewModel)
            } else {
                NavigationStack {
                    CustomTabView(appViewModel: appViewModel)
                        .navigationBarHidden(true)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    MainAppView()
        .environmentObject(AppViewModel())
}
