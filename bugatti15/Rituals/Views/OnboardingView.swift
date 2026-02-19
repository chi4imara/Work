import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var appViewModel: AppViewModel
    @State private var currentPage = 0
    @State private var showMainApp = false
    
    let pages = [
        OnboardingPage(
            title: "Your daily mood companion",
            description: "Track emotions, plan small joys, and see progress daily.",
            icon: "heart.fill",
            color: AppColors.accent
        ),
        OnboardingPage(
            title: "Small actions, big smiles",
            description: "Create daily mini-goals and self-care moments.",
            icon: "star.fill",
            color: AppColors.secondary
        ),
        OnboardingPage(
            title: "Let's start your journey",
            description: "Interactive tasks, prompts, and visual rewards await you.",
            icon: "sparkles",
            color: AppColors.success
        )
    ]
    
    var body: some View {
        ZStack {
            AnimatedBackground()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 30) {
                    HStack(spacing: 12) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? AppColors.secondary : AppColors.white.opacity(0.3))
                                .frame(width: 12, height: 12)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentPage += 1
                            }
                        } else {
                            appViewModel.completeOnboarding()
                        }
                    }) {
                        HStack {
                            Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                                .font(.ubuntu(18, weight: .medium))
                                .foregroundColor(AppColors.primary)
                            
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(AppColors.primary)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(AppColors.secondary)
                        .cornerRadius(28)
                        .shadow(color: AppColors.shadow, radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 40)
                    
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            appViewModel.completeOnboarding()
                        }
                        .font(.ubuntu(16))
                        .foregroundColor(AppColors.textSecondary)
                    }
                }
                .padding(.bottom, 50)
            }
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
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(page.color.opacity(0.2))
                    .frame(width: 190, height: 190)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                
                Circle()
                    .fill(page.color.opacity(0.1))
                    .frame(width: 160, height: 160)
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
                
                Image(systemName: page.icon)
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(page.color)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
            }
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: 2.0)
                        .repeatForever(autoreverses: true)
                ) {
                    isAnimating = true
                }
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(AppColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(.ubuntu(18))
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
}
