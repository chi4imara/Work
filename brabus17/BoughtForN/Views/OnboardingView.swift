import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appStateManager: AppStateManager
    @State private var currentPage = 0
    @State private var isAnimating = false
    
    let pages = [
        OnboardingPage(
            title: "Log purchases as simple facts.",
            description: "This app helps you record purchases in a clear and minimal way. Write down what you bought, where it happened, and why you made the purchase.",
            systemImage: "bag.fill"
        ),
        OnboardingPage(
            title: "Stay organized and factual.",
            description: "Each entry stays factual, without budgets, calculations, or analysis. Browse your purchase history, open any record in full, edit details, or quickly search past purchases whenever you need a clean overview.",
            systemImage: "list.bullet.clipboard.fill"
        ),
        OnboardingPage(
            title: "Quick search and access.",
            description: "Find any purchase instantly with powerful search functionality. Search by item name, location, or purpose. Your purchase history is always at your fingertips.",
            systemImage: "magnifyingglass"
        ),
        OnboardingPage(
            title: "Simple and intuitive.",
            description: "No complex features, no overwhelming options. Just a clean interface to record what matters. Start tracking your purchases now and keep your history organized effortlessly.",
            systemImage: "checkmark.circle.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            ColorTheme.backgroundGradient
                .ignoresSafeArea()
            
            ForEach(0..<10, id: \.self) { index in
                Circle()
                    .fill(ColorTheme.white.opacity(0.2))
                    .frame(width: CGFloat.random(in: 10...25))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .animation(
                        Animation.linear(duration: Double.random(in: 4...8))
                            .repeatForever(autoreverses: false),
                        value: isAnimating
                    )
            }
            
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                HStack(spacing: 12) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? ColorTheme.yellow : ColorTheme.white.opacity(0.5))
                            .frame(width: 12, height: 12)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, 40)
                
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            currentPage += 1
                        }
                    } else {
                        appStateManager.completeOnboarding()
                    }
                }) {
                    HStack {
                        Text(currentPage < pages.count - 1 ? "Continue" : "Get Started")
                            .font(.ubuntu(18, weight: .medium))
                            .foregroundColor(ColorTheme.primaryBlue)
                        
                        if currentPage < pages.count - 1 {
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(ColorTheme.primaryBlue)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(ColorTheme.white)
                    .cornerRadius(28)
                    .shadow(color: ColorTheme.cardShadow, radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            isAnimating = true
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
    @State private var isVisible = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: page.systemImage)
                .font(.system(size: 80, weight: .light))
                .foregroundColor(ColorTheme.yellow)
                .scaleEffect(isVisible ? 1.0 : 0.5)
                .opacity(isVisible ? 1.0 : 0.0)
                .animation(.spring(response: 0.8, dampingFraction: 0.6), value: isVisible)
            
            VStack(spacing: 24) {
                Text(page.title)
                    .font(.ubuntu(28, weight: .bold))
                    .foregroundColor(ColorTheme.white)
                    .multilineTextAlignment(.center)
                    .opacity(isVisible ? 1.0 : 0.0)
                    .offset(y: isVisible ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.2), value: isVisible)
                
                Text(page.description)
                    .font(.ubuntu(16, weight: .regular))
                    .foregroundColor(ColorTheme.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .opacity(isVisible ? 1.0 : 0.0)
                    .offset(y: isVisible ? 0 : 30)
                    .animation(.easeOut(duration: 0.8).delay(0.4), value: isVisible)
            }
            .padding(.horizontal, 32)
            
            Spacer()
            Spacer()
        }
        .onAppear {
            withAnimation {
                isVisible = true
            }
        }
        .onDisappear {
            isVisible = false
        }
    }
}
