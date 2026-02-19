import SwiftUI

private enum OnboardingStorage {
    static let key = "spabuddy_onboarding_completed"
}

struct OnboardingView: View {
    let onComplete: () -> Void
    @State private var currentPage = 0
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "location.magnifyingglass",
            title: "Your SPA guide near you",
            description: "Find the best SPA salons nearby, filter by distance, rating and services that matter to you."
        ),
        OnboardingPage(
            icon: "calendar.badge.clock",
            title: "Book treatments easily",
            description: "Choose your preferred time, select a service and master. Manage all your appointments in one place."
        ),
        OnboardingPage(
            icon: "chart.line.uptrend.xyaxis",
            title: "Track your care routine",
            description: "See your visit history, reach wellness goals and unlock achievements for regular self-care."
        )
    ]
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    if currentPage < pages.count - 1 {
                        Button(action: finishOnboarding) {
                            Text("Skip")
                                .font(.playfairSemiBold(size: 16))
                                .foregroundColor(ColorTheme.secondaryText)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                        }
                    }
                }
                .padding(.top, 16)
                
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Capsule()
                            .fill(index == currentPage ? ColorTheme.primaryPurple : ColorTheme.cardBorder)
                            .frame(width: index == currentPage ? 24 : 8, height: 8)
                            .animation(.easeInOut(duration: 0.25), value: currentPage)
                    }
                }
                .padding(.bottom, 24)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentPage += 1
                        }
                    } else {
                        finishOnboarding()
                    }
                }) {
                    Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                        .font(.playfairBold(size: 18))
                        .foregroundColor(ColorTheme.buttonText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(ColorTheme.buttonPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 48)
            }
        }
    }
    
    private func finishOnboarding() {
        UserDefaults.standard.set(true, forKey: OnboardingStorage.key)
        onComplete()
    }
}

struct OnboardingPage {
    let icon: String
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(ColorTheme.primaryPurple.opacity(0.2))
                    .frame(width: 160, height: 160)
                
                Circle()
                    .fill(ColorTheme.primaryPurple.opacity(0.35))
                    .frame(width: 120, height: 120)
                
                Image(systemName: page.icon)
                    .font(.system(size: 56))
                    .foregroundColor(ColorTheme.primaryWhite)
            }
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.playfairBold(size: 26))
                    .foregroundColor(ColorTheme.primaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                
                Text(page.description)
                    .font(.playfairRegular(size: 17))
                    .foregroundColor(ColorTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            Spacer()
        }
    }
}

struct PostSplashView: View {
    @AppStorage(OnboardingStorage.key) private var onboardingCompleted = false
    
    var body: some View {
        Group {
            if onboardingCompleted {
                MainTabView()
            } else {
                OnboardingView(onComplete: {
                    onboardingCompleted = true
                })
            }
        }
    }
}

#Preview {
    OnboardingView(onComplete: {})
}
