import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppStateManager
    @State private var currentPage = 0
    
    private let pages = [
        OnboardingPage(
            title: "Plan gently. Live intentionally.",
            description: "A simple space to organize your day and take care of yourself without pressure.",
            icon: "heart.circle.fill"
        ),
        OnboardingPage(
            title: "Tiny habits. Big change.",
            description: "Track small routines, mark progress, and feel supported every day.",
            icon: "star.circle.fill"
        ),
        OnboardingPage(
            title: "Let's build your rhythm.",
            description: "Just a few minutes a day can make a difference.",
            icon: "circle.grid.3x3.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            AppBackgroundView()
            
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
                                .fill(currentPage == index ? AppColors.accentYellow : AppColors.primaryText.opacity(0.3))
                                .frame(width: 12, height: 12)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.spring(response: 0.3), value: currentPage)
                        }
                    }
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentPage += 1
                            }
                        } else {
                            appState.completeOnboarding()
                        }
                    }) {
                        HStack {
                            Text(currentPage == pages.count - 1 ? "Continue" : "Next")
                                .font(AppFonts.playfairSemiBold(size: 18))
                                .foregroundColor(AppColors.primaryBlue)
                            
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .foregroundColor(AppColors.primaryBlue)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(AppColors.accentYellow)
                        .cornerRadius(28)
                    }
                    .padding(.horizontal, 40)
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
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.icon)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(AppColors.accentYellow)
                .shadow(color: AppColors.accentYellow.opacity(0.3), radius: 10)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(AppFonts.playfairBold(size: 32))
                    .foregroundColor(AppColors.primaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(AppFonts.playfairRegular(size: 18))
                    .foregroundColor(AppColors.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}
