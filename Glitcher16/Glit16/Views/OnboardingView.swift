import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppStateManager
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    let pages = [
        OnboardingPage(
            title: "Your personal beauty catalog",
            description: "Organize your entire collection in one clean, simple space. Add products you use, track expiration dates, and keep quick notes and ratings.",
            systemImage: "heart.fill"
        ),
        OnboardingPage(
            title: "Track & Organize",
            description: "Build a clear overview of what you love, what you plan to replace, and what deserves a spot in your routine. Everything stays neatly structured and easy to review anytime.",
            systemImage: "star.fill"
        ),
        OnboardingPage(
            title: "Smart Expiration Tracking",
            description: "Never let your favorite products expire again. Get visual warnings when items are approaching their expiration date and keep your collection fresh.",
            systemImage: "calendar.badge.exclamationmark"
        ),
        OnboardingPage(
            title: "Categories & Search",
            description: "Find what you need instantly with powerful search and smart categorization. Filter by type, rating, or expiration date to discover your perfect products.",
            systemImage: "magnifyingglass.circle.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            AppColorScheme.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index], isAnimating: $isAnimating)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                VStack(spacing: 20) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.primaryYellow : Color.textSecondary)
                                .frame(width: 8, height: 8)
                                .scaleEffect(currentPage == index ? 1.2 : 1.0)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    .padding(.bottom, 10)
                    
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                currentPage += 1
                            }
                        } else {
                            appState.completeOnboarding()
                        }
                    }) {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(.playfairDisplay(18, weight: .semibold))
                            .foregroundColor(.primaryPink)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.primaryYellow)
                            .cornerRadius(25)
                    }
                    .padding(.horizontal, 40)
                    .scaleEffect(isAnimating ? 1.0 : 0.9)
                    .opacity(isAnimating ? 1.0 : 0.7)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                isAnimating = true
            }
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let systemImage: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    @Binding var isAnimating: Bool
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.systemImage)
                .font(.system(size: 80))
                .foregroundColor(.primaryYellow)
                .scaleEffect(isAnimating ? 1.0 : 0.5)
                .opacity(isAnimating ? 1.0 : 0.3)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.playfairDisplay(32, weight: .bold))
                    .foregroundColor(.textPrimary)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1.0 : 0.0)
                
                Text(page.description)
                    .font(.playfairDisplay(16, weight: .regular))
                    .foregroundColor(.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 30)
                    .opacity(isAnimating ? 1.0 : 0.0)
            }
            
            Spacer()
        }
        .animation(.easeInOut(duration: 1.0).delay(0.3), value: isAnimating)
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppStateManager())
}
