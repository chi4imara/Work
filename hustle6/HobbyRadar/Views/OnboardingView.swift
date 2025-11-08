import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var dragOffset: CGSize = .zero
    
    var onComplete: () -> Void
    
    private let pages = OnboardingPage.allPages
    
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
                                .fill(index == currentPage ? AppColors.primary : AppColors.primary.opacity(0.3))
                                .frame(width: 10, height: 10)
                                .scaleEffect(index == currentPage ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentPage += 1
                            }
                        } else {
                            onComplete()
                        }
                    }) {
                        HStack {
                            Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                                .font(AppFonts.buttonTitle)
                                .foregroundColor(AppColors.onPrimary)
                            
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(AppColors.onPrimary)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(AppColors.primaryGradient)
                        .cornerRadius(28)
                        .shadow(color: AppColors.primary.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal, 40)
                    
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            onComplete()
                        }
                        .font(AppFonts.callout)
                        .foregroundColor(AppColors.secondaryText)
                    }
                }
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(AppColors.primary.opacity(0.1))
                    .frame(width: 200, height: 200)
                
                Image(systemName: page.iconName)
                    .font(.system(size: 80, weight: .light))
                    .foregroundColor(AppColors.primary)
            }
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(AppFonts.title1)
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(AppFonts.body)
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 30)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let iconName: String
    
    static let allPages = [
        OnboardingPage(
            title: "Discover fun. Anytime.",
            description: "Boredom is gone when you have endless ideas at your fingertips. This app is your pocket generator for free time: one tap — and you get a fresh idea.",
            iconName: "lightbulb.fill"
        ),
        OnboardingPage(
            title: "Endless Possibilities",
            description: "Watch a movie, cook something new, start a drawing, go for a walk, or play a board game. Every idea comes with a category, so you can find the right one for your mood.",
            iconName: "sparkles"
        ),
        OnboardingPage(
            title: "Make It Personal",
            description: "Add your own ideas to make the generator truly personal, and save your favorites to return to them anytime. Browse the full list when you need inspiration.",
            iconName: "heart.fill"
        ),
        OnboardingPage(
            title: "Never Run Out",
            description: "Whether alone or with friends, your leisure time will always feel full of variety and easy to plan. Dive into your history to recall past activities.",
            iconName: "infinity"
        )
    ]
}

#Preview {
    OnboardingView {
        print("Onboarding completed")
    }
}
