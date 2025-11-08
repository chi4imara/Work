import SwiftUI

struct OnboardingView: View {
    @StateObject private var appColors = AppColors.shared
    @State private var currentPage = 0
    @Binding var showOnboarding: Bool
    
    private let pages = [
        OnboardingPage(
            icon: "cloud.sun.fill",
            title: "Weather & Mood",
            subtitle: "One Day at a Time",
            description: "Start a simple habit: note the day's weather and how you feel."
        ),
        OnboardingPage(
            icon: "calendar",
            title: "Track Your Days",
            subtitle: "Clean Journal",
            description: "Your entries stay in a clean journal, appear on a calendar, and turn into easy-to-read stats."
        ),
        OnboardingPage(
            icon: "chart.bar.fill",
            title: "Understand Patterns",
            subtitle: "Personal Insights",
            description: "See which moods follow rainy days, how you feel in sunshine, and how the season shifts your temperature comfort. A calm, personal way to understand your days — one small check-in at a time."
        )
    ]
    
    var body: some View {
        ZStack {
            appColors.backgroundGradient
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
                
                VStack(spacing: 30) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? appColors.primaryOrange : appColors.primaryBlue.opacity(0.3))
                                .frame(width: 10, height: 10)
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
                            showOnboarding = false
                        }
                    }) {
                        HStack {
                            Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                                .font(.builderSans(.semiBold, size: 18))
                                .foregroundColor(.white)
                            
                            if currentPage < pages.count - 1 {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(appColors.buttonGradient)
                        .cornerRadius(28)
                        .shadow(color: appColors.primaryOrange.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.horizontal, 40)
                }
                .padding(.bottom, 50)
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @StateObject private var appColors = AppColors.shared
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(appColors.cardGradient)
                    .frame(width: 120, height: 120)
                    .shadow(color: appColors.primaryBlue.opacity(0.2), radius: 20, x: 0, y: 10)
                
                Image(systemName: page.icon)
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(appColors.primaryBlue)
            }
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.builderSans(.bold, size: 32))
                    .foregroundColor(appColors.textPrimary)
                    .multilineTextAlignment(.center)
                
                Text(page.subtitle)
                    .font(.builderSans(.medium, size: 20))
                    .foregroundColor(appColors.primaryOrange)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.builderSans(.regular, size: 16))
                    .foregroundColor(appColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .padding(.horizontal, 30)
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let subtitle: String
    let description: String
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
