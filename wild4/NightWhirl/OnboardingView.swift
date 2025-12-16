import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Binding var showOnboarding: Bool
    
    var body: some View {
        ZStack {
            AppColors.backgroundPrimary
                .ignoresSafeArea()
            
            TabView(selection: $viewModel.currentPage) {
                OnboardingPageView(
                    imageName: "fork.knife.circle.fill",
                    title: "Discover One New Recipe Every Day",
                    description: "This app brings you a fresh cooking idea every day. Open it to see a single recipe — simple, inspiring, and easy to follow.",
                    isLastPage: false,
                    onNext: viewModel.nextPage,
                    onComplete: completeOnboarding
                )
                .tag(0)
                
                OnboardingPageView(
                    imageName: "heart.circle.fill",
                    title: "Save Your Favorites",
                    description: "Each recipe comes with ingredients and step-by-step instructions. Save the ones you love, explore your collection later.",
                    isLastPage: false,
                    onNext: viewModel.nextPage,
                    onComplete: completeOnboarding
                )
                .tag(1)
                
                OnboardingPageView(
                    imageName: "sparkles",
                    title: "Cooking Inspiration",
                    description: "Bring more variety to your meals without searching endlessly. Cooking inspiration, one day at a time.",
                    isLastPage: true,
                    onNext: viewModel.nextPage,
                    onComplete: completeOnboarding
                )
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
    }
    
    private func completeOnboarding() {
        viewModel.completeOnboarding()
        showOnboarding = false
    }
}

struct OnboardingPageView: View {
    let imageName: String
    let title: String
    let description: String
    let isLastPage: Bool
    let onNext: () -> Void
    let onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: imageName)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.primaryYellow)
                .shadow(color: AppColors.shadowColor, radius: 10, x: 0, y: 5)
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                Text(description)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                    .lineSpacing(4)
            }
            
            Spacer()
            
            Button(action: isLastPage ? onComplete : onNext) {
                Text(isLastPage ? "Get Started" : "Continue")
                    .font(.ubuntu(18, weight: .medium))
                    .foregroundColor(AppColors.textLight)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(AppColors.primaryYellow)
                    .cornerRadius(25)
                    .shadow(color: AppColors.shadowColor, radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
