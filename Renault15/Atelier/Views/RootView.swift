import SwiftUI
import UIKit

struct RootView: View {
    @StateObject private var viewModel = HairstyleViewModel()
    @State private var isLoading = true
    @State private var isOnboardingCompleted = UserDefaults.standard.bool(forKey: "OnboardingCompleted")
    
    var body: some View {
        ZStack {
            if !isOnboardingCompleted {
                OnboardingView(isOnboardingCompleted: $isOnboardingCompleted)
                    .onChange(of: isOnboardingCompleted) { completed in
                        if completed {
                            UserDefaults.standard.set(true, forKey: "OnboardingCompleted")
                        }
                    }
            } else {
                NavigationStack {
                    MainTabView()
                        .environmentObject(viewModel)
                        .navigationBarHidden(true)
                }
                .onAppear {
                    viewModel.loadFromStorage()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    viewModel.loadFromStorage()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)) { _ in
                    viewModel.persistToStorage()
                }
            }
        }
    }
}
