import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appViewModel: AppViewModel
    @State private var currentPage = 0
    @State private var showingMainApp = false
    
    let onBoardingDescription = """
        🟢 means recently fed.
        🟡 means soon it will be time.
        🔴 means it's time to fertilize now.
        
        All data stays on your device — clear, private, and easy to update. A calm, simple way to care for your plants and never forget when to nourish them.
        """
    var body: some View {
        ZStack {
            AppTheme.backgroundGradient
                .ignoresSafeArea()
            
            GridBackgroundView()
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    OnboardingPageView(
                        imageName: "leaf.circle.fill",
                        title: "Keep Your Plants Nourished",
                        description: "This app helps you track when your plants were last fertilized — no reminders, no notifications, just simple awareness.",
                        pageNumber: 0
                    )
                    .tag(0)
                    
                    OnboardingPageView(
                        imageName: "calendar.circle.fill",
                        title: "Simple Plant Care",
                        description: "Add each plant, note the type of fertilizer and how often you feed it. The app shows which plants are doing fine, which are getting close to their next feeding, and which already need attention.",
                        pageNumber: 1
                    )
                    .tag(1)
                    
                    OnboardingPageView(
                        imageName: "checkmark.circle.fill",
                        title: "Status at a Glance",
                        description: onBoardingDescription,
                        pageNumber: 2
                    )
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                
                OnboardingNavigationView(
                    currentPage: $currentPage,
                    onComplete: {
                        appViewModel.completeOnboarding()
                    }
                )
            }
        }
    }
}

struct OnboardingPageView: View {
    let imageName: String
    let title: String
    let description: String
    let pageNumber: Int
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: imageName)
                .font(.system(size: 80))
                .foregroundColor(AppTheme.primaryYellow)
                .shadow(color: AppTheme.shadowColor, radius: 10, x: 0, y: 5)
            
            VStack(spacing: 24) {
                Text(title)
                    .font(.appTitle)
                    .foregroundColor(AppTheme.primaryWhite)
                    .multilineTextAlignment(.center)
                    .shadow(color: AppTheme.shadowColor, radius: 5, x: 0, y: 2)
                
                Text(description)
                    .font(.appBody)
                    .foregroundColor(AppTheme.primaryWhite)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 32)
                    .shadow(color: AppTheme.shadowColor, radius: 3, x: 0, y: 1)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

struct OnboardingNavigationView: View {
    @Binding var currentPage: Int
    let onComplete: () -> Void
    
    private let totalPages = 3
    
    var body: some View {
        HStack(spacing: 20) {
            if currentPage > 0 {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentPage -= 1
                    }
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                        
                        Text("Back")
                            .font(.buttonMedium)
                    }
                    .foregroundColor(AppTheme.primaryWhite)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppTheme.primaryWhite.opacity(0.2))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(AppTheme.primaryWhite.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
            } else {
                Spacer()
            }
            
            Spacer()
            
            Button(action: {
                if currentPage < totalPages - 1 {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        currentPage += 1
                    }
                } else {
                    onComplete()
                }
            }) {
                HStack(spacing: 8) {
                    Text(currentPage < totalPages - 1 ? "Continue" : "Get Started")
                        .font(.buttonLarge)
                    
                    Image(systemName: currentPage < totalPages - 1 ? "arrow.right" : "checkmark")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(AppTheme.darkBlue)
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .background(AppTheme.yellowGradient)
                .cornerRadius(25)
                .shadow(color: AppTheme.shadowColor, radius: 10, x: 0, y: 5)
            }
        }
        .padding(.horizontal, 32)
        .padding(.bottom, 50)
    }
}

#Preview {
    OnboardingView(appViewModel: AppViewModel())
}
