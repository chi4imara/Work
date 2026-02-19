import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appViewModel: AppViewModel
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            title: "Collect your world of scents",
            description: "Build your personal fragrance library and rediscover every note that defines you.",
            icon: "waterbottle.fill",
            color: AppColors.accentYellow
        ),
        OnboardingPage(
            title: "Organize by seasons",
            description: "Add your favorite perfumes, describe their scent profiles, mark the season and mood they fit best.",
            icon: "calendar",
            color: AppColors.accentYellow
        ),
        OnboardingPage(
            title: "Discover your story",
            description: "From light daytime florals to deep evening blends. Sort your collection by season or atmosphere and explore how your perfumes reflect each moment of your life.",
            icon: "sparkles",
            color: AppColors.primaryPurple
        ),
        OnboardingPage(
            title: "Simple and elegant",
            description: "Whether it's cozy autumn warmth or crisp summer freshness, your fragrances tell a story — and this app keeps them beautifully organized. Your scent journey starts here.",
            icon: "heart.fill",
            color: AppColors.accentYellow
        )
    ]
    
    var body: some View {
        ZStack {
            AppColors.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                bottomControls
            }
        }
    }
    
    private var bottomControls: some View {
        VStack(spacing: 24) {
            HStack(spacing: 8) {
                ForEach(0..<pages.count, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? AppColors.accentYellow : AppColors.secondaryText.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .scaleEffect(currentPage == index ? 1.2 : 1.0)
                        .animation(.easeInOut(duration: 0.3), value: currentPage)
                }
            }
            
            Button(action: handleButtonTap) {
                Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                    .font(.ubuntu(18, weight: .semibold))
                    .foregroundColor(AppColors.buttonText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(AppColors.buttonPrimary)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 20)
            
            if currentPage < pages.count - 1 {
                Button(action: { appViewModel.completeOnboarding() }) {
                    Text("Skip")
                        .font(.ubuntu(16, weight: .medium))
                        .foregroundColor(AppColors.tertiaryText)
                }
            }
        }
        .padding(.bottom, 40)
    }
    
    private func handleButtonTap() {
        if currentPage < pages.count - 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentPage += 1
            }
        } else {
            appViewModel.completeOnboarding()
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let icon: String
    let color: Color
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.icon)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(page.color)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.ubuntu(32, weight: .bold))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.ubuntu(18))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 30)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView(appViewModel: AppViewModel())
}
